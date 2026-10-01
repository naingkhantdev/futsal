import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/booking_vo.dart';
import 'console_kit.dart';

/// PLATFORM scope: bookings as a console table — customer / venue, shop,
/// when, amount, status. Below 600dp only the first and last columns stay;
/// the first then carries the date and time.
class ConsoleBookingTable extends StatelessWidget {
  const ConsoleBookingTable({
    super.key,
    required this.bookings,
    required this.onOpen,
    this.shopNameOf,
  });

  final List<BookingVO> bookings;
  final ValueChanged<BookingVO> onOpen;

  /// Shop column; omitted when `null` (e.g. inside one customer's history
  /// it is still useful, inside one shop it is not).
  final String Function(BookingVO)? shopNameOf;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final compact = context.isCompact;
    String when(BookingVO b) => '${DisplayFormat.dayLabel(b.bookingDate, l)} · '
        '${DisplayFormat.timeRange(b.startMinute, b.endMinute)}';

    return ConsoleTable(
      columns: [
        ConsoleColumn(l.roleCustomer, flex: 4),
        if (shopNameOf != null)
          ConsoleColumn(l.shopLabel, flex: 3, compact: false),
        ConsoleColumn(l.consoleWhen, flex: 3, compact: false),
        ConsoleColumn(l.totalLabel, flex: 2, compact: false, alignEnd: true),
        ConsoleColumn(l.consoleStatus, flex: 3),
      ],
      rows: [
        for (final b in bookings)
          ConsoleRow(
            onTap: () => onOpen(b),
            cells: [
              ConsoleCellText(
                b.customerNameSnapshot,
                strong: true,
                secondary: compact
                    ? when(b)
                    : '${b.stadiumNameSnapshot} · ${b.courtNameSnapshot}',
              ),
              if (shopNameOf != null) ConsoleCellText(shopNameOf!(b)),
              ConsoleCellText(
                DisplayFormat.dayLabel(b.bookingDate, l),
                secondary: DisplayFormat.timeRange(b.startMinute, b.endMinute),
              ),
              Text(
                Money.formatMmk(b.totalPrice),
                style: const TextStyle(
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              StatusBadge.fromVisual(
                b.status.visual,
                semanticsPrefix: l.bookingStatusPrefix,
                plain: true,
              ),
            ],
          ),
      ],
    );
  }
}
