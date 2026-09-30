import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
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
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
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
        showAppSnackBar(
          context,
          error.messageIn(context.l10n),
          tone: SnackTone.error,
        );
      }
    });
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(shop.valueOrNull?.name ?? l.shopLabel),
        actions: [
          const TourHelpButton(),
          if (shop.valueOrNull != null)
            TourAnchor(
              id: TourIds.edit,
              child: IconButton(
                tooltip: l.shopEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    context.push(AppRoutes.superadminShopEdit(shopId)),
              ),
            ),
        ],
      ),
      body: AsyncValueView<ShopVO?>(
        value: shop,
        onRetry: () => ref.invalidate(shopProvider(shopId)),
        isEmpty: (s) => s == null,
        empty: EmptyView(
          icon: Icons.storefront_outlined,
          title: l.shopNotFound,
          message: l.notFoundRemoved,
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
    final l = context.l10n;

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
                    semanticsPrefix: l.shopStatusPrefix,
                    size: StatusBadgeSize.medium,
                  ),
                  StatusBadge.fromVisual(
                    shopListingVisual(isListed: shop.isListed),
                    semanticsPrefix: l.listingPrefix,
                    size: StatusBadgeSize.medium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _statusExplainer(shop, l),
                style: context.textStyles.bodyMedium?.copyWith(color: muted),
              ),
              const SizedBox(height: AppSpacing.lg),
              TourAnchor(
                id: TourIds.status,
                child: _StatusActions(shop: shop),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    DetailRow(
                      icon: Icons.phone_outlined,
                      label: l.profilePhone,
                      value: shop.phone,
                    ),
                    DetailRow(
                      icon: Icons.mail_outline,
                      label: l.emailLabel,
                      value: shop.email,
                    ),
                    DetailRow(
                      icon: Icons.place_outlined,
                      label: l.locationLabel,
                      value: location,
                    ),
                    if ((shop.description ?? '').trim().isNotEmpty)
                      DetailRow(
                        icon: Icons.notes,
                        label: l.descriptionLabel,
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
                child: TourAnchor(
                  id: TourIds.admins,
                  child: ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings_outlined,
                      size: AppSizes.iconLg,
                    ),
                    title: Text(l.audienceShopAdmins),
                    subtitle: Text(l.shopAdminsSub),
                    trailing: Icon(Icons.chevron_right, color: muted),
                    onTap: () =>
                        context.push(AppRoutes.superadminShopAdmins(shop.id)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _statusExplainer(ShopVO shop, AppLocalizations l) =>
      switch (shop.status) {
        ShopStatus.pending => l.explainPending,
        ShopStatus.active =>
          shop.isListed ? l.explainLive : l.explainUnlisted,
        ShopStatus.suspended => l.explainSuspended,
        ShopStatus.rejected => l.explainRejected,
        ShopStatus.inactive => l.explainInactive,
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
    final l = context.l10n;

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
          dismissLabel: l.commonCancel,
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
      label: l.approveAndList,
      icon: Icons.verified_outlined,
      isLoading: busy,
      expand: true,
      onPressed: () => change(
        ShopStatus.active,
        isListed: true,
        done: l.shopApprovedListed,
      ),
    );
    final reactivate = PrimaryButton(
      label: l.reactivateAction,
      icon: Icons.play_circle_outline,
      isLoading: busy,
      expand: true,
      onPressed: () => change(
        ShopStatus.active,
        isListed: shop.isListed,
        done: l.shopReactivated,
      ),
    );
    final deactivate = AppTextButton(
      label: l.deactivateShop,
      icon: Icons.power_settings_new,
      onPressed: busy
          ? null
          : () => change(
                ShopStatus.inactive,
                isListed: false,
                done: l.shopDeactivated,
                confirm: (
                  title: l.deactivateShopTitle,
                  message: l.deactivateShopMessage,
                  confirm: l.deactivateAction,
                ),
              ),
    );

    final List<Widget> children = switch (shop.status) {
      ShopStatus.pending => [
          approve,
          const SizedBox(height: AppSpacing.sm),
          DestructiveButton(
            label: l.rejectAction,
            icon: Icons.cancel_outlined,
            expand: true,
            onPressed: busy
                ? null
                : () => change(
                      ShopStatus.rejected,
                      isListed: false,
                      done: l.shopRejectedDone,
                      confirm: (
                        title: l.rejectShopTitle,
                        message: l.rejectShopMessage,
                        confirm: l.rejectAction,
                      ),
                    ),
          ),
        ],
      ShopStatus.active => [
          AppCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              title: Text(l.listedForCustomers),
              subtitle: Text(l.listedForCustomersSub),
              value: shop.isListed,
              onChanged: busy
                  ? null
                  : (listed) => change(
                        ShopStatus.active,
                        isListed: listed,
                        done:
                            listed ? l.shopListedDone : l.shopUnlistedDone,
                      ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DestructiveButton(
            label: l.suspendAction,
            icon: Icons.pause_circle_outline,
            expand: true,
            onPressed: busy
                ? null
                : () => change(
                      ShopStatus.suspended,
                      isListed: shop.isListed,
                      done: l.shopSuspendedDone,
                      confirm: (
                        title: l.suspendShopTitle,
                        message: l.suspendShopMessage,
                        confirm: l.suspendAction,
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
    final l = context.l10n;
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
            child: Text(
              l.ownerPrivateTitle,
              style: context.textStyles.titleSmall,
            ),
          ),
          DetailRow(
            icon: Icons.person_outline,
            label: l.ownerNameLabel,
            value: details?.ownerName,
          ),
          DetailRow(
            icon: Icons.phone_outlined,
            label: l.ownerPhoneLabel,
            value: details?.ownerPhone,
          ),
          if ((details?.suspendedReason ?? '').isNotEmpty)
            DetailRow(
              icon: Icons.info_outline,
              label: l.suspensionReason,
              value: details?.suspendedReason,
            ),
        ],
      ),
    );
  }
}
