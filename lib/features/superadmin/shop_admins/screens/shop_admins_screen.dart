import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/user_vo.dart';
import '../../console/widgets/console_kit.dart';
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
      appBar: ConsoleAppBar(
        title: l.audienceShopAdmins,
        actions: [
          ConsoleBarAction(
            icon: Icons.person_add_alt_outlined,
            label: l.addAdmin,
            onPressed: addAdmin,
          ),
        ],
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
        data: (list) => ConsoleBody(
          header: ConsoleBand(
            overline: '${l.consolePlatform} · ${shopName ?? l.shopLabel}',
            title: shopName == null
                ? l.audienceShopAdmins
                : l.shopAdminsOf(shopName),
            subtitle: l.shopAdminsSub,
            metrics: [
              ConsoleMetric(value: '${list.length}', label: l.totalLabel),
              ConsoleMetric(
                value: '${list.where((a) => !a.isActive).length}',
                label: l.statusDisabled,
              ),
            ],
          ),
          children: [
            ConsoleTable(
              columns: [
                ConsoleColumn(l.audienceShopAdmins, flex: 5),
                ConsoleColumn(l.consoleStatus, flex: 3),
              ],
              rows: [
                for (final a in list)
                  ConsoleRow(
                    trailing: _RemoveAdminButton(admin: a),
                    cells: [
                      ConsoleCellText(
                        a.hasName ? a.name : a.email,
                        strong: true,
                        secondary: a.hasName ? a.email : null,
                      ),
                      a.isActive
                          ? StatusBadge(
                              tone: StatusTone.success,
                              icon: Icons.check_circle,
                              label: l.consoleActive,
                              semanticsPrefix: l.accountPrefix,
                              plain: true,
                            )
                          : StatusBadge(
                              tone: StatusTone.danger,
                              icon: Icons.block,
                              label: l.accountDisabledBadge,
                              semanticsPrefix: l.accountPrefix,
                              plain: true,
                            ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveAdminButton extends ConsumerWidget {
  const _RemoveAdminButton({required this.admin});

  final UserVO admin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(shopAdminAssignmentControllerProvider).isLoading;
    final l = context.l10n;
    return IconButton(
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
    );
  }
}
