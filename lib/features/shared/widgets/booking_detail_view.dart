import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/l10n_labels.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/status_visuals.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/display_format.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/detail_row.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/vos/booking_vo.dart';

/// Booking detail sections shared by customer, shop admin and superadmin:
/// status header, when & where, optional customer / shop, and payment.
/// Callers add role-specific actions after it.
class BookingDetailSections extends StatelessWidget {
  const BookingDetailSections({
    super.key,
    required this.booking,
    this.showCustomer = false,
    this.shopName,
    this.onCustomerTap,
  });

  final BookingVO booking;
  final bool showCustomer;

  /// Shown for the platform view (bookings across shops).
  final String? shopName;
  final VoidCallback? onCustomerTap;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: time + badges.
        Text(
          DisplayFormat.dayLabel(b.bookingDate, l),
          style: styles.bodyMedium?.copyWith(color: muted),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          DisplayFormat.timeRange(b.startMinute, b.endMinute),
          style: AppTypography.tabular(styles.headlineMedium!),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusBadge.fromVisual(
              b.status.visual,
              semanticsPrefix: l.bookingStatusPrefix,
              size: StatusBadgeSize.medium,
            ),
            StatusBadge.fromVisual(
              b.paymentStatus.visual,
              semanticsPrefix: l.paymentStatusPrefix,
              size: StatusBadgeSize.medium,
            ),
          ],
        ),
        if (b.cancelReason != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l.reasonLabel(b.cancelReason!),
            style: styles.bodyMedium?.copyWith(color: muted),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              DetailRow(
                icon: Icons.event_outlined,
                label: l.dateLabel,
                value: DisplayFormat.fullDate(b.bookingDate),
              ),
              DetailRow(
                icon: Icons.stadium_outlined,
                label: l.venueLabel,
                value: b.stadiumNameSnapshot,
              ),
              DetailRow(
                icon: Icons.sports_soccer_outlined,
                label: l.courtLabel,
                value: b.courtNameSnapshot,
              ),
              if (shopName != null)
                DetailRow(
                  icon: Icons.storefront_outlined,
                  label: l.shopLabel,
                  value: shopName,
                ),
            ],
          ),
        ),
        if (showCustomer) ...[
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            padding: EdgeInsets.zero,
            onTap: onCustomerTap,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: context.colors.primaryContainer,
                foregroundColor: context.colors.onPrimaryContainer,
                child: Text(DisplayFormat.initials(b.customerNameSnapshot)),
              ),
              title: Text(b.customerNameSnapshot),
              subtitle: Text(b.customerPhoneSnapshot ?? l.noPhone),
              trailing: onCustomerTap == null
                  ? null
                  : Icon(Icons.chevron_right, color: muted),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: Column(
            children: [
              _PriceLine(
                label: l.pricePerHourLong(Money.formatMmk(b.pricePerHour)),
                value: DisplayFormat.duration(b.durationMinutes, l),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(),
              ),
              _PriceLine(
                label: l.totalLabel,
                value: Money.formatMmk(b.totalPrice),
                emphasize: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // The policy agreed at booking time, not the venue's current one.
              DetailRow(
                icon: Icons.policy_outlined,
                label: l.cancelPolicyTitle,
                value: cancelPolicySummary(l, b.freeCancelHours),
              ),
              if (b.refundState.labelIn(l) case final refund?)
                DetailRow(
                  icon: Icons.currency_exchange,
                  label: l.refundLabel,
                  value: refund,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final style = emphasize ? styles.titleMedium! : styles.bodyMedium!;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: emphasize
                ? style
                : style.copyWith(color: context.colors.onSurfaceVariant),
          ),
        ),
        Text(value, style: AppTypography.tabular(style)),
      ],
    );
  }
}
