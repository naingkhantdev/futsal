import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/staff_booking_views.dart';
import '../../console/widgets/console_kit.dart';

/// `/superadmin/bookings/:bookingId` — PLATFORM scope: any booking as a
/// record, with the same staff actions as the shop admin.
/// PREVIEW: actions save nothing.
class SuperadminBookingDetailScreen extends StatelessWidget {
  const SuperadminBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final b = DemoData.booking(bookingId);
    final l = context.l10n;
    final shop = DemoData.shop(b.shopId);
    final reason = b.cancelReason?.trim() ?? '';

    return Scaffold(
      appBar: ConsoleAppBar(title: l.bookingTitle),
      body: ConsoleBody(
        demo: true,
        header: ConsoleBand(
          overline: '${l.consolePlatform} · ${l.bookingTitle}',
          title: b.customerNameSnapshot,
          subtitle: '${DisplayFormat.dayLabel(b.bookingDate, l)} · '
              '${DisplayFormat.timeRange(b.startMinute, b.endMinute)}',
          badges: [
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
        children: [
          ConsoleColumns(
            children: [
              ConsolePanel(
                title: l.venueLabel,
                child: Column(
                  children: [
                    ConsoleField(
                      label: l.shopLabel,
                      value: shop.name,
                      onTap: () =>
                          context.push(AppRoutes.superadminShop(shop.id)),
                    ),
                    ConsoleField(
                      label: l.stadiumLabel,
                      value: b.stadiumNameSnapshot,
                    ),
                    ConsoleField(
                        label: l.courtLabel, value: b.courtNameSnapshot),
                    ConsoleField(
                      label: l.dateLabel,
                      value: DisplayFormat.fullDate(b.bookingDate),
                    ),
                    ConsoleField(
                      label: l.timeLabel,
                      value:
                          '${DisplayFormat.timeRange(b.startMinute, b.endMinute)}'
                          ' · ${DisplayFormat.duration(b.durationMinutes, l)}',
                      last: true,
                    ),
                  ],
                ),
              ),
              ConsolePanel(
                title: l.roleCustomer,
                child: Column(
                  children: [
                    ConsoleField(
                      label: l.fullNameLabel,
                      value: b.customerNameSnapshot,
                      onTap: () => context
                          .push(AppRoutes.superadminCustomer(b.customerId)),
                    ),
                    ConsoleField(
                      label: l.profilePhone,
                      value: b.customerPhoneSnapshot,
                      last: true,
                    ),
                  ],
                ),
              ),
              ConsolePanel(
                title: l.consolePayment,
                child: Column(
                  children: [
                    ConsoleField(
                      label: l.pricePerHourTitle,
                      value: Money.formatMmk(b.pricePerHour),
                    ),
                    ConsoleField(
                      label: l.totalLabel,
                      value: Money.formatMmk(b.totalPrice),
                    ),
                    ConsoleField(
                      label: l.paymentStatusPrefix,
                      last: reason.isEmpty,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: StatusBadge.fromVisual(
                          b.paymentStatus.visual,
                          semanticsPrefix: l.paymentStatusPrefix,
                          plain: true,
                        ),
                      ),
                    ),
                    if (reason.isNotEmpty)
                      ConsoleField(
                        label: l.reasonFieldLabel,
                        value: reason,
                        last: true,
                      ),
                  ],
                ),
              ),
              if (StaffBookingActions.hasAny(b))
                ConsolePanel(
                  title: l.consoleActions,
                  padded: true,
                  child: StaffBookingActions(booking: b),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
