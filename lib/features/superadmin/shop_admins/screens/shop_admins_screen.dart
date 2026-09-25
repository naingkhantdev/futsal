import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/user_vo.dart';
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
        showAppSnackBar(context, error.message, tone: SnackTone.error);
      }
    });
    void addAdmin() =>
        context.push(AppRoutes.superadminShopAdminInvite(shopId));

    return Scaffold(
      appBar: AppBar(
        title: Text(shopName == null ? 'Shop admins' : '$shopName admins'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addAdmin,
        icon: const Icon(Icons.person_add_alt_outlined),
        label: const Text('Add admin'),
      ),
      body: AsyncValueView<List<UserVO>>(
        value: admins,
        onRetry: () => ref.invalidate(shopAdminsProvider(shopId)),
        isEmpty: (list) => list.isEmpty,
        empty: EmptyView(
          icon: Icons.admin_panel_settings_outlined,
          title: 'No admins yet',
          message: 'Add the person who runs this shop. They need a customer '
              'account first.',
          actionLabel: 'Add admin',
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
          itemBuilder: (context, i) => ContentConstraint(
            child: _AdminCard(admin: list[i]),
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
              const StatusBadge(
                tone: StatusTone.danger,
                icon: Icons.block,
                label: 'Account disabled',
                semanticsPrefix: 'Account',
              ),
            ],
          ],
        ),
        trailing: IconButton(
          tooltip: 'Remove admin',
          icon: const Icon(Icons.person_remove_outlined),
          onPressed: busy
              ? null
              : () async {
                  final ok = await showConfirmDialog(
                    context,
                    title: 'Remove this admin?',
                    message: '${admin.hasName ? admin.name : admin.email} '
                        'loses access to the shop right away and becomes a '
                        'customer.',
                    confirmLabel: 'Remove',
                    dismissLabel: 'Cancel',
                    destructive: true,
                  );
                  if (!ok) return;
                  final removed = await ref
                      .read(shopAdminAssignmentControllerProvider.notifier)
                      .remove(admin.id);
                  if (removed && context.mounted) {
                    showAppSnackBar(context, 'Admin removed',
                        tone: SnackTone.success);
                  }
                },
        ),
      ),
    );
  }
}
