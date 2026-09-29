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
import '../../../core/widgets/motion.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/vos/booking_vo.dart';

/// A booking shown as a match ticket: the one navy surface on a customer
/// screen. Day + status on top, the time range large, then venue / court,
/// a perforation, and the total in gold. Used for "Your next game" on
/// home and on the booking confirmation. Tappable when [onTap] is set.
class BookingTicket extends StatelessWidget {
  const BookingTicket({super.key, required this.booking, this.onTap});

  final BookingVO booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final g = context.gradients;
    final styles = context.textStyles;
    final l = context.l10n;
    final day = DisplayFormat.dayLabel(b.bookingDate, l);
    final time = DisplayFormat.timeRange(b.startMinute, b.endMinute);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  day,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styles.labelLarge?.copyWith(color: g.gold),
                ),
              ),
              StatusBadge.fromVisual(
                b.status.visual,
                semanticsPrefix: l.bookingStatusPrefix,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  time,
                  maxLines: 1,
                  style: AppTypography.tabular(styles.headlineLarge!)
                      .copyWith(color: g.onHero),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                b.stadiumNameSnapshot,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styles.titleMedium?.copyWith(color: g.onHero),
              ),
              Text(
                b.courtNameSnapshot,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styles.bodyMedium?.copyWith(color: g.onHeroMuted),
              ),
            ],
          ),
        ),
        _Perforation(color: g.onHero.withOpacity(0.18)),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l.totalPayAtVenue,
                  style: styles.bodySmall?.copyWith(color: g.onHeroMuted),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                Money.formatMmk(b.totalPrice),
                style: AppTypography.tabular(styles.titleMedium!)
                    .copyWith(color: g.gold, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );

    final ticket = DecoratedBox(
      decoration: BoxDecoration(gradient: g.hero, borderRadius: AppRadius.lgAll),
      child: ClipRRect(
        borderRadius: AppRadius.lgAll,
        child: Material(
          type: MaterialType.transparency,
          child: onTap == null ? body : InkWell(onTap: onTap, child: body),
        ),
      ),
    );

    return Semantics(
      button: onTap != null,
      label: '${b.stadiumNameSnapshot}, ${b.courtNameSnapshot}, $day, $time, '
          '${b.status.labelIn(l)}, ${l.totalPayAtVenue} '
          '${Money.formatMmk(b.totalPrice)}',
      onTap: onTap,
      excludeSemantics: true,
      child: Pressable(enabled: onTap != null, child: ticket),
    );
  }
}

/// Dashed tear line across the ticket.
class _Perforation extends StatelessWidget {
  const _Perforation({required this.color});

  final Color color;

  static const double _dash = 6;
  static const double _gap = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count =
              (constraints.maxWidth / (_dash + _gap)).floor().clamp(1, 200);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < count; i++)
                SizedBox(
                  width: _dash,
                  height: 1,
                  child: ColoredBox(color: color),
                ),
            ],
          );
        },
      ),
    );
  }
}
