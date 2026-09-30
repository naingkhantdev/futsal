import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/user_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../shops/providers/shops_providers.dart';
import '../providers/shop_admins_providers.dart';

/// `/superadmin/shops/:shopId/admins` — PLATFORM scope: who manages the
/// shop. Removing an admin turns the account back into a customer; access
/// ends at once because firestore.rules read `users/{uid}` on every request.
class ShopAdminsScreen extends ConsumerWidget {
  const ShopAdminsScreen({super.key, required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admins = ref.watch(shopAdminsProvider(shopId));
    final shopName = ref.watch(shopProvider(shopId)).valueOrNull?.name;
    ref.listen(shopAdminAssignmentControllerProvider, (_, next) {
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
    void addAdmin() =>
        context.push(AppRoutes.superadminShopAdminInvite(shopId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          shopName == null ? l.audienceShopAdmins : l.shopAdminsOf(shopName),
        ),
        actions: const [TourHelpButton()],
      ),
      floatingActionButton: TourAnchor(
        id: TourIds.fab,
        child: FloatingActionButton.extended(
          onPressed: addAdmin,
          icon: const Icon(Icons.person_add_alt_outlined),
          label: Text(l.addAdmin),
        ),
      ),
      body: AsyncValueView<List<UserVO>>(
        value: admins,
        onRetry: () => ref.invalidate(shopAdminsProvider(shopId)),
        isEmpty: (list) => list.isEmpty,
        empty: EmptyView(
          icon: Icons.admin_panel_settings_outlined,
          title: l.noAdminsYet,
          message: l.noAdminsMessage,
          actionLabel: l.addAdmin,
          onAction: addAdmin,
        ),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSpacing.lg,
            0,
            AppSpacing.xxxl + AppSpacing.xxl,
          ),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, i) => FadeSlideIn(
            index: i,
            child: ContentConstraint(child: _AdminCard(admin: list[i])),
          ),
        ),
      ),
    );
  }
}

class _AdminCard extends ConsumerWidget {
  const _AdminCard({required this.admin});

  final UserVO admin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(shopAdminAssignmentControllerProvider).isLoading;
    final l = context.l10n;
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        title: Text(admin.hasName ? admin.name : admin.email),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (admin.hasName) Text(admin.email),
            if (!admin.isActive) ...[
              const SizedBox(height: AppSpacing.xs),
              StatusBadge(
                tone: StatusTone.danger,
                icon: Icons.block,
                label: l.accountDisabledBadge,
                semanticsPrefix: l.accountPrefix,
              ),
            ],
          ],
        ),
        trailing: IconButton(
          tooltip: l.removeAdmin,
          icon: const Icon(Icons.person_remove_outlined),
          onPressed: busy
              ? null
              : () async {
                  final ok = await showConfirmDialog(
                    context,
                    title: l.removeAdminTitle,
                    message: l.removeAdminMessage(
                      admin.hasName ? admin.name : admin.email,
                    ),
                    confirmLabel: l.commonRemove,
                    dismissLabel: l.commonCancel,
                    destructive: true,
                  );
                  if (!ok) return;
                  final removed = await ref
                      .read(shopAdminAssignmentControllerProvider.notifier)
                      .remove(admin.id);
                  if (removed && context.mounted) {
                    showAppSnackBar(context, l.adminRemoved,
                        tone: SnackTone.success);
                  }
                },
        ),
      ),
    );
  }
}
