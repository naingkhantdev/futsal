import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_labels.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../../data/vos/blocked_slot_vo.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/shop-admin/blocked-slots` — SHOP scope: upcoming blocked court times.
/// PREVIEW: sample data; removing saves nothing.
class BlockedSlotsScreen extends StatelessWidget {
  const BlockedSlotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = DemoData.blockedSlots
        .where((k) => k.shopId == DemoData.myShopId)
        .toList()
      ..sort((a, b) => a.startAt!.compareTo(b.startAt!));
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.blockedTimesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.shopAdminBlockedSlotNew),
        icon: const Icon(Icons.add),
        label: Text(l.blockTimeTitle),
      ),
      body: PreviewBody(
        bottomPadding: 96,
        children: [
          Text(
            l.blockedTimesNote,
            style: context.textStyles.bodyMedium
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final k in items) ...[
            _BlockedTile(item: k),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _BlockedTile extends StatelessWidget {
  const _BlockedTile({required this.item});

  final BlockedSlotVO item;

  @override
  Widget build(BuildContext context) {
    final court = DemoData.court(item.courtId);
    final stadium = DemoData.stadium(item.stadiumId);
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
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
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${court.name} · ${stadium.name}',
                  style: styles.bodySmall?.copyWith(color: muted),
                ),
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
            onPressed: () => showPreviewOnly(context, l.removeBlock),
          ),
        ],
      ),
    );
  }
}
