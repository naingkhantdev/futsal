import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/stadium_vo.dart';

/// Stadium row in the shop admin's list: name, location, hours, price and
/// active / visible badges (never color alone).
class StadiumAdminCard extends StatelessWidget {
  const StadiumAdminCard({super.key, required this.stadium, this.onTap});

  final StadiumVO stadium;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.onSurfaceVariant;
    final location = [stadium.township, stadium.city]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(', ');
    final minPrice = stadium.minHourlyPrice;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stadium.name, style: context.textStyles.titleMedium),
          if (location.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              location,
              style: context.textStyles.bodyMedium?.copyWith(color: muted),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.schedule, size: AppSizes.iconSm, color: muted),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${formatMinuteOfDay(stadium.openMinute)}–'
                '${formatMinuteOfDay(stadium.closeMinute)}',
                style: context.textStyles.bodyMedium?.copyWith(color: muted),
              ),
              if (minPrice != null) ...[
                const SizedBox(width: AppSpacing.lg),
                Icon(Icons.payments_outlined,
                    size: AppSizes.iconSm, color: muted),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    'from ${Money.formatMmk(minPrice)}/h',
                    overflow: TextOverflow.ellipsis,
                    style:
                        context.textStyles.bodyMedium?.copyWith(color: muted),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              stadium.isActive
                  ? const StatusBadge(
                      tone: StatusTone.success,
                      icon: Icons.check_circle,
                      label: 'Active',
                      semanticsPrefix: 'Stadium',
                    )
                  : const StatusBadge(
                      tone: StatusTone.neutral,
                      icon: Icons.pause_circle_outline,
                      label: 'Inactive',
                      semanticsPrefix: 'Stadium',
                    ),
              stadium.isPublished
                  ? const StatusBadge(
                      tone: StatusTone.brand,
                      icon: Icons.visibility,
                      label: 'Visible to customers',
                      semanticsPrefix: 'Discovery',
                    )
                  : const StatusBadge(
                      tone: StatusTone.neutral,
                      icon: Icons.visibility_off,
                      label: 'Hidden',
                      semanticsPrefix: 'Discovery',
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
