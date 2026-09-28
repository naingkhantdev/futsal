import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_labels.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Blocked times')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.shopAdminBlockedSlotNew),
        icon: const Icon(Icons.add),
        label: const Text('Block time'),
      ),
      body: PreviewBody(
        bottomPadding: 96,
        children: [
          Text(
            'Blocked times cannot be booked by customers.',
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
                  '${DisplayFormat.dayLabel(item.date)} · '
                  '${DisplayFormat.timeRange(item.startMinute, item.endMinute)}',
                  style: styles.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${court.name} · ${stadium.name}',
                  style: styles.bodySmall?.copyWith(color: muted),
                ),
                Text(
                  [item.reason.label, if (item.note != null) item.note!]
                      .join(' — '),
                  style: styles.bodySmall?.copyWith(color: muted),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove block',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => showPreviewOnly(context, 'Remove block'),
          ),
        ],
      ),
    );
  }
}
