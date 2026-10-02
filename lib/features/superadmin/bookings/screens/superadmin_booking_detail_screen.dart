import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/providers/booking_providers.dart';
import '../../../shared/widgets/staff_booking_views.dart';
import '../../console/widgets/console_kit.dart';
import '../../shops/providers/shops_providers.dart';

/// `/superadmin/bookings/:bookingId` — PLATFORM scope: any booking as a
/// record, with the same staff actions as the shop admin.
class SuperadminBookingDetailScreen extends ConsumerWidget {
  const SuperadminBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider(bookingId));
    final l = context.l10n;
    return Scaffold(
      appBar: ConsoleAppBar(title: l.bookingTitle),
      body: AsyncValueView<BookingVO?>(
        value: booking,
        onRetry: () => ref.invalidate(bookingProvider(bookingId)),
        isEmpty: (b) => b == null,
        empty: EmptyView(
          icon: Icons.event_busy,
          title: l.bookingNotFound,
          message: l.notFoundRemoved,
        ),
        data: (b) => _Record(booking: b!),
      ),
    );
  }
}

class _Record extends ConsumerWidget {
  const _Record({required this.booking});

  final BookingVO booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = booking;
    final l = context.l10n;
    final shopName = ref.watch(shopProvider(b.shopId)).valueOrNull?.name;
    final reason = b.cancelReason?.trim() ?? '';

    return ConsoleBody(
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
                      value: shopName,
                      onTap: () =>
                          context.push(AppRoutes.superadminShop(b.shopId)),
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
    );
  }
}
