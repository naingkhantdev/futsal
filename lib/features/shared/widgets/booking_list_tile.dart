import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/l10n_labels.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/status_visuals.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/display_format.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/vos/booking_vo.dart';

/// One booking in a list: date block, time + venue (and customer for staff),
/// status badge and total. Same card for all three roles.
class BookingListTile extends StatelessWidget {
  const BookingListTile({
    super.key,
    required this.booking,
    required this.onTap,
    this.showCustomer = false,
  });

  final BookingVO booking;
  final VoidCallback onTap;

  /// Staff lists lead with the customer's name instead of the venue.
  final bool showCustomer;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
    final time = DisplayFormat.timeRange(b.startMinute, b.endMinute);
    // Staff lead with the customer; everyone sees the stadium + court line.
    final title = showCustomer ? b.customerNameSnapshot : b.stadiumNameSnapshot;
    final venue = showCustomer
        ? '${b.stadiumNameSnapshot} · ${b.courtNameSnapshot}'
        : b.courtNameSnapshot;

    return Semantics(
      button: true,
      label: '$title, $venue, ${DisplayFormat.dayLabel(b.bookingDate, l)}, '
          '$time, ${b.status.labelIn(l)}',
      onTap: onTap,
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            _DateBlock(dateKey: b.bookingDate),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: AppTypography.tabular(styles.titleSmall!),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styles.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Row(
                    children: [
                      Icon(
                        showCustomer
                            ? Icons.stadium_outlined
                            : Icons.sports_soccer_outlined,
                        size: AppSizes.iconXs,
                        color: muted,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          venue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styles.bodySmall?.copyWith(color: muted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge.fromVisual(
                  b.status.visual,
                  semanticsPrefix: l.bookingStatusPrefix,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  Money.formatMmk(b.totalPrice),
                  style: AppTypography.tabular(styles.labelMedium!)
                      .copyWith(color: muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "SEP / 29 / Mon" block.
class _DateBlock extends StatelessWidget {
  const _DateBlock({required this.dateKey});

  final String dateKey;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: context.depth.wellDecoration(borderRadius: AppRadius.smAll),
      child: Column(
        children: [
          Text(
            DisplayFormat.month(dateKey).toUpperCase(),
            style: AppTypography.overline(styles.labelSmall!)
                .copyWith(color: muted),
          ),
          Text(
            DisplayFormat.dayOfMonth(dateKey),
            style: AppTypography.tabular(styles.titleLarge!),
          ),
          Text(
            DisplayFormat.weekday(dateKey),
            style: styles.labelSmall?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}
