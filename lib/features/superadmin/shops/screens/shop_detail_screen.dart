import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/detail_row.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/shop_private_vo.dart';
import '../../../../data/vos/shop_vo.dart';
import '../providers/shops_providers.dart';

/// `/superadmin/shops/:shopId` — PLATFORM scope: shop profile, status
/// (approve / reject / suspend / reactivate), listing, admins.
///
/// Status and listing changes also re-sync the shop's stadiums in the same
/// batch, so discovery follows immediately; bookings are protected by the
/// rules regardless (they re-check the shop on every booking).
class ShopDetailScreen extends ConsumerWidget {
  const ShopDetailScreen({super.key, required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shop = ref.watch(shopProvider(shopId));
    ref.listen(shopStatusControllerProvider, (_, next) {
      final error = next.appError;
      if (error != null) {
        showAppSnackBar(context, error.message, tone: SnackTone.error);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(shop.valueOrNull?.name ?? 'Shop'),
        actions: [
          if (shop.valueOrNull != null)
            IconButton(
              tooltip: 'Edit shop',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push(AppRoutes.superadminShopEdit(shopId)),
            ),
        ],
      ),
      body: AsyncValueView<ShopVO?>(
        value: shop,
        onRetry: () => ref.invalidate(shopProvider(shopId)),
        isEmpty: (s) => s == null,
        empty: const EmptyView(
          icon: Icons.storefront_outlined,
          title: 'Shop not found',
          message: 'It may have been removed.',
        ),
        data: (s) => _ShopDetailBody(shop: s!),
      ),
    );
  }
}

class _ShopDetailBody extends ConsumerWidget {
  const _ShopDetailBody({required this.shop});

  final ShopVO shop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(shopPrivateProvider(shop.id)).valueOrNull;
    final muted = context.colors.onSurfaceVariant;
    final location = [shop.address, shop.township, shop.city]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(', ');

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      children: [
        ContentConstraint(
          width: ContentWidth.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  StatusBadge.fromVisual(
                    shop.status.visual,
                    semanticsPrefix: 'Shop status',
                    size: StatusBadgeSize.medium,
                  ),
                  StatusBadge.fromVisual(
                    shopListingVisual(isListed: shop.isListed),
                    semanticsPrefix: 'Listing',
                    size: StatusBadgeSize.medium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _statusExplainer(shop),
                style: context.textStyles.bodyMedium?.copyWith(color: muted),
              ),
              const SizedBox(height: AppSpacing.lg),
              _StatusActions(shop: shop),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    DetailRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: shop.phone,
                    ),
                    DetailRow(
                      icon: Icons.mail_outline,
                      label: 'Email',
                      value: shop.email,
                    ),
                    DetailRow(
                      icon: Icons.place_outlined,
                      label: 'Location',
                      value: location,
                    ),
                    if ((shop.description ?? '').trim().isNotEmpty)
                      DetailRow(
                        icon: Icons.notes,
                        label: 'Description',
                        value: shop.description,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _OwnerCard(details: details),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(
                    Icons.admin_panel_settings_outlined,
                    size: AppSizes.iconLg,
                  ),
                  title: const Text('Shop admins'),
                  subtitle: const Text('Who can manage this shop'),
                  trailing: Icon(Icons.chevron_right, color: muted),
                  onTap: () =>
                      context.push(AppRoutes.superadminShopAdmins(shop.id)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _statusExplainer(ShopVO shop) => switch (shop.status) {
        ShopStatus.pending =>
          'Waiting for review. Hidden from customers; its admins can already '
              'set up stadiums and courts.',
        ShopStatus.active => shop.isListed
            ? 'Live: customers can find and book it.'
            : 'Approved but unlisted: hidden from customers, no new bookings.',
        ShopStatus.suspended =>
          'Suspended: hidden from customers, no new bookings. Existing '
              'bookings stay as they are.',
        ShopStatus.rejected => 'Rejected: hidden from customers.',
        ShopStatus.inactive =>
          'Inactive: hidden from customers, no new bookings.',
      };
}

/// Buttons for the status changes that make sense from the current status.
class _StatusActions extends ConsumerWidget {
  const _StatusActions({required this.shop});

  final ShopVO shop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(shopStatusControllerProvider).isLoading;
    final controller = ref.read(shopStatusControllerProvider.notifier);

    Future<void> change(
      ShopStatus status, {
      required bool isListed,
      required String done,
      ({String title, String message, String confirm})? confirm,
    }) async {
      if (confirm != null) {
        final ok = await showConfirmDialog(
          context,
          title: confirm.title,
          message: confirm.message,
          confirmLabel: confirm.confirm,
          dismissLabel: 'Cancel',
          destructive: true,
        );
        if (!ok) return;
      }
      final saved =
          await controller.setStatus(shop.id, status: status, isListed: isListed);
      if (saved && context.mounted) {
        showAppSnackBar(context, done, tone: SnackTone.success);
      }
    }

    final approve = PrimaryButton(
      label: 'Approve and list',
      icon: Icons.verified_outlined,
      isLoading: busy,
      expand: true,
      onPressed: () => change(
        ShopStatus.active,
        isListed: true,
        done: 'Shop approved and listed',
      ),
    );
    final reactivate = PrimaryButton(
      label: 'Reactivate',
      icon: Icons.play_circle_outline,
      isLoading: busy,
      expand: true,
      onPressed: () => change(
        ShopStatus.active,
        isListed: shop.isListed,
        done: 'Shop reactivated',
      ),
    );
    final deactivate = AppTextButton(
      label: 'Deactivate shop',
      icon: Icons.power_settings_new,
      onPressed: busy
          ? null
          : () => change(
                ShopStatus.inactive,
                isListed: false,
                done: 'Shop deactivated',
                confirm: (
                  title: 'Deactivate this shop?',
                  message: 'It will be hidden from customers and take no new '
                      'bookings. You can reactivate it later.',
                  confirm: 'Deactivate',
                ),
              ),
    );

    final List<Widget> children = switch (shop.status) {
      ShopStatus.pending => [
          approve,
          const SizedBox(height: AppSpacing.sm),
          DestructiveButton(
            label: 'Reject',
            icon: Icons.cancel_outlined,
            expand: true,
            onPressed: busy
                ? null
                : () => change(
                      ShopStatus.rejected,
                      isListed: false,
                      done: 'Shop rejected',
                      confirm: (
                        title: 'Reject this shop?',
                        message: 'It stays hidden from customers. You can '
                            'still approve it later.',
                        confirm: 'Reject',
                      ),
                    ),
          ),
        ],
      ShopStatus.active => [
          AppCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              title: const Text('Listed for customers'),
              subtitle: const Text(
                'When off, the shop is hidden and takes no new bookings.',
              ),
              value: shop.isListed,
              onChanged: busy
                  ? null
                  : (listed) => change(
                        ShopStatus.active,
                        isListed: listed,
                        done: listed ? 'Shop listed' : 'Shop unlisted',
                      ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DestructiveButton(
            label: 'Suspend',
            icon: Icons.pause_circle_outline,
            expand: true,
            onPressed: busy
                ? null
                : () => change(
                      ShopStatus.suspended,
                      isListed: shop.isListed,
                      done: 'Shop suspended',
                      confirm: (
                        title: 'Suspend this shop?',
                        message: 'Customers stop seeing it and it takes no '
                            'new bookings. Existing bookings are not '
                            'cancelled.',
                        confirm: 'Suspend',
                      ),
                    ),
          ),
          deactivate,
        ],
      ShopStatus.suspended => [reactivate, deactivate],
      ShopStatus.rejected => [approve],
      ShopStatus.inactive => [reactivate],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.details});

  final ShopPrivateVO? details;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            child: Text('Owner (private)', style: context.textStyles.titleSmall),
          ),
          DetailRow(
            icon: Icons.person_outline,
            label: 'Owner name',
            value: details?.ownerName,
          ),
          DetailRow(
            icon: Icons.phone_outlined,
            label: 'Owner phone',
            value: details?.ownerPhone,
          ),
          if ((details?.suspendedReason ?? '').isNotEmpty)
            DetailRow(
              icon: Icons.info_outline,
              label: 'Suspension reason',
              value: details?.suspendedReason,
            ),
        ],
      ),
    );
  }
}
