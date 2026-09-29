import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/l10n_labels.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/status_visuals.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/display_format.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/grouped_list.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/vos/booking_vo.dart';

/// One booking row: date block, time + venue (and customer for staff),
/// status badge and total. Flat (no card of its own): place rows in a
/// [BookingGroup] / `GroupedList`. Same row for all three roles.
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
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              _DateBlock(dateKey: b.bookingDate),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      time,
                      style: AppTypography.tabular(styles.bodyMedium!)
                          .copyWith(color: context.colors.onSurface),
                    ),
                    Text(
                      venue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.bodySmall?.copyWith(color: muted),
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
                    style: AppTypography.tabular(styles.labelMedium!).copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [BookingListTile]s for [bookings] on one grouped surface.
class BookingGroup extends StatelessWidget {
  const BookingGroup({
    super.key,
    required this.bookings,
    required this.onOpen,
    this.showCustomer = false,
  });

  final List<BookingVO> bookings;
  final ValueChanged<BookingVO> onOpen;
  final bool showCustomer;

  /// Row padding + date block + gap: dividers start under the text.
  static const double _textInset =
      AppSpacing.lg + _DateBlock.width + AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    return GroupedList(
      dividerIndent: _textInset,
      children: [
        for (final b in bookings)
          BookingListTile(
            booking: b,
            showCustomer: showCustomer,
            onTap: () => onOpen(b),
          ),
      ],
    );
  }
}

/// "Sep / 29 / Mon" calendar block.
class _DateBlock extends StatelessWidget {
  const _DateBlock({required this.dateKey});

  static const double width = 52;

  final String dateKey;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final c = context.colors;
    // Tinted calendar block: month + weekday muted, day large.
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.primaryContainer,
        borderRadius: AppRadius.smAll,
      ),
      child: Column(
        children: [
          Text(
            DisplayFormat.month(dateKey),
            maxLines: 1,
            style: styles.labelSmall?.copyWith(color: c.onSurfaceVariant),
          ),
          Text(
            DisplayFormat.dayOfMonth(dateKey),
            style: AppTypography.tabular(styles.titleLarge!)
                .copyWith(color: c.onPrimaryContainer),
          ),
          Text(
            DisplayFormat.weekday(dateKey),
            maxLines: 1,
            style: styles.labelSmall?.copyWith(color: c.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
