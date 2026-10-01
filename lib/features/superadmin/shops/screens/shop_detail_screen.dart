import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/venue_location_card.dart';
import '../../../../data/vos/shop_private_vo.dart';
import '../../../../data/vos/shop_vo.dart';
import '../../console/widgets/console_kit.dart';
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
      appBar: ConsoleAppBar(
        title: shop.valueOrNull?.name ?? l.shopLabel,
        actions: [
          if (shop.valueOrNull != null)
            IconButton(
              tooltip: l.shopEdit,
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
    final place = [shop.township, shop.city]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(', ');
    final fullAddress = [shop.address, place]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(', ');
    final l = context.l10n;

    return ConsoleBody(
      header: ConsoleBand(
        overline: '${l.consolePlatform} · ${l.shopLabel}',
        title: shop.name,
        subtitle: place.isEmpty ? null : place,
        badges: [
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
      children: [
        ConsoleColumns(
          children: [
            ConsolePanel(
              title: l.consoleStatusListing,
              padded: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _statusExplainer(shop, l),
                    style: context.textStyles.bodyMedium
                        ?.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _StatusActions(shop: shop),
                ],
              ),
            ),
            ConsolePanel(
              title: l.consoleContact,
              child: Column(
                children: [
                  ConsoleField(label: l.profilePhone, value: shop.phone),
                  ConsoleField(label: l.emailLabel, value: shop.email),
                  ConsoleField(
                    label: l.locationLabel,
                    value: fullAddress,
                  ),
                  ConsoleField(
                    label: l.descriptionLabel,
                    value: shop.description,
                    last: true,
                  ),
                ],
              ),
            ),
            // Map + "Directions" (opens Google Maps); falls back to an
            // address search when no pin is set.
            VenueLocationCard(
              name: shop.name,
              address: fullAddress,
              point: shop.latitude != null && shop.longitude != null
                  ? (latitude: shop.latitude!, longitude: shop.longitude!)
                  : null,
            ),
            _OwnerPanel(details: details),
            ConsolePanel(
              title: l.audienceShopAdmins,
              child: ConsoleLinkRow(
                icon: Icons.admin_panel_settings_outlined,
                label: l.audienceShopAdmins,
                detail: l.shopAdminsSub,
                last: true,
                onTap: () =>
                    context.push(AppRoutes.superadminShopAdmins(shop.id)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _statusExplainer(ShopVO shop, AppLocalizations l) =>
      switch (shop.status) {
        ShopStatus.pending => l.explainPending,
        ShopStatus.active => shop.isListed ? l.explainLive : l.explainUnlisted,
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
      final saved = await controller.setStatus(shop.id,
          status: status, isListed: isListed);
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
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.listedForCustomers),
            subtitle: Text(l.listedForCustomersSub),
            value: shop.isListed,
            onChanged: busy
                ? null
                : (listed) => change(
                      ShopStatus.active,
                      isListed: listed,
                      done: listed ? l.shopListedDone : l.shopUnlistedDone,
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

class _OwnerPanel extends StatelessWidget {
  const _OwnerPanel({required this.details});

  final ShopPrivateVO? details;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reason = details?.suspendedReason ?? '';
    return ConsolePanel(
      title: l.ownerPrivateTitle,
      child: Column(
        children: [
          ConsoleField(label: l.ownerNameLabel, value: details?.ownerName),
          ConsoleField(
            label: l.ownerPhoneLabel,
            value: details?.ownerPhone,
            last: reason.isEmpty,
          ),
          if (reason.isNotEmpty)
            ConsoleField(
              label: l.suspensionReason,
              value: reason,
              last: true,
            ),
        ],
      ),
    );
  }
}
