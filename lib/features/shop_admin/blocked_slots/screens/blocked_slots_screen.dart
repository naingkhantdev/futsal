import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_labels.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/vos/blocked_slot_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/page_body.dart';
import '../../bookings/providers/shop_bookings_providers.dart';
import '../../stadiums/providers/shop_venue_providers.dart';

/// `/shop-admin/blocked-slots` — SHOP scope: blocked court times that have
/// not ended yet. Removing one frees its slots in the same transaction.
class BlockedSlotsScreen extends ConsumerWidget {
  const BlockedSlotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shopBlockedSlotsProvider);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.blockedTimesTitle),
        actions: const [TourHelpButton()],
      ),
      floatingActionButton: TourAnchor(
        id: TourIds.fab,
        child: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.shopAdminBlockedSlotNew),
          icon: const Icon(Icons.add),
          label: Text(l.blockTimeTitle),
        ),
      ),
      body: AsyncValueView<List<BlockedSlotVO>>(
        value: items,
        onRetry: () => ref.invalidate(shopBlockedSlotsProvider),
        data: (list) => PageBody(
          bottomPadding: 96,
          children: [
            Text(
              l.blockedTimesNote,
              style: context.textStyles.bodyMedium
                  ?.copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (list.isEmpty)
              EmptyView.inline(
                icon: Icons.event_available_outlined,
                title: l.noBlockedTimesTitle,
              )
            else
              for (final k in list) ...[
                _BlockedTile(item: k),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        ),
      ),
    );
  }
}

class _BlockedTile extends ConsumerWidget {
  const _BlockedTile({required this.item});

  final BlockedSlotVO item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stadium = ref
        .watch(myStadiumsProvider)
        .valueOrNull
        ?.where((s) => s.id == item.stadiumId)
        .firstOrNull;
    final court = ref
        .watch(adminCourtsProvider(item.stadiumId))
        .valueOrNull
        ?.where((c) => c.id == item.courtId)
        .firstOrNull;
    final busy = ref.watch(blockedSlotsControllerProvider).isLoading;
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
    final where =
        [court?.name, stadium?.name].whereType<String>().join(' · ');
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.colors.surfaceContainerHighest,
            foregroundColor: muted,
            child: Icon(item.reason.icon, size: AppSizes.iconMd),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DisplayFormat.dayLabel(item.date, l)} · '
                  '${DisplayFormat.timeRange(item.startMinute, item.endMinute)}',
                  style: styles.titleSmall,
                ),
                if (where.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(where, style: styles.bodySmall?.copyWith(color: muted)),
                ],
                Text(
                  [item.reason.labelIn(l), if (item.note != null) item.note!]
                      .join(' — '),
                  style: styles.bodySmall?.copyWith(color: muted),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l.removeBlock,
            icon: const Icon(Icons.delete_outline),
            onPressed: busy ? null : () => _remove(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l.removeBlock,
      message: l.removeBlockMessage,
      confirmLabel: l.commonRemove,
      dismissLabel: l.commonCancel,
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    final done = await ref
        .read(blockedSlotsControllerProvider.notifier)
        .unblock(item.id);
    if (!context.mounted) return;
    if (done) {
      showAppSnackBar(context, l.changesSaved, tone: SnackTone.success);
      return;
    }
    final error = ref.read(blockedSlotsControllerProvider).error;
    final failure =
        error is AppException ? error : UnknownException(cause: error);
    showAppSnackBar(context, failure.messageIn(l), tone: SnackTone.error);
  }
}
