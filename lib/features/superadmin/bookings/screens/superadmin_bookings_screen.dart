import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/widgets/staff_booking_views.dart';
import '../../console/widgets/console_booking_table.dart';
import '../../console/widgets/console_kit.dart';

/// `/superadmin/bookings` — PLATFORM scope: bookings across all shops, with
/// status / shop filters and a customer / stadium search.
/// PREVIEW: sample data until Phase 11.
class SuperadminBookingsScreen extends StatefulWidget {
  const SuperadminBookingsScreen({super.key});

  @override
  State<SuperadminBookingsScreen> createState() =>
      _SuperadminBookingsScreenState();
}

class _SuperadminBookingsScreenState extends State<SuperadminBookingsScreen> {
  StaffBookingFilter _filter = StaffBookingFilter.all;

  /// `null` = every shop.
  String? _shopId;
  String _query = '';

  List<BookingVO> _apply(List<BookingVO> all, StaffBookingFilter f) {
    final now = DateTime.now();
    final q = _query.trim().toLowerCase();
    final list = all.where((b) {
      if (_shopId != null && b.shopId != _shopId) return false;
      if (q.isEmpty) return true;
      return b.customerNameSnapshot.toLowerCase().contains(q) ||
          b.stadiumNameSnapshot.toLowerCase().contains(q);
    });
    return switch (f) {
      StaffBookingFilter.pending =>
        list.where((b) => b.status == BookingStatus.pending).toList(),
      StaffBookingFilter.upcoming =>
        list.where((b) => b.isUpcoming(now)).toList()
          ..sort((a, b) => a.startAt!.compareTo(b.startAt!)),
      StaffBookingFilter.past => list.where((b) => !b.isUpcoming(now)).toList(),
      StaffBookingFilter.all => list.toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final all = DemoData.allBookings();
    final now = DateTime.now();
    final pending = all.where((b) => b.status == BookingStatus.pending).length;
    final upcoming = all.where((b) => b.isUpcoming(now)).length;
    final shopIds = {for (final b in all) b.shopId}.toList();
    final shown = _apply(all, _filter);

    return Scaffold(
      appBar: ConsoleAppBar(title: l.navBookings),
      body: ConsoleBody(
        demo: true,
        header: Column(
          children: [
            ConsoleBand(
              overline: '${l.consolePlatform} · ${l.navBookings}',
              metrics: [
                ConsoleMetric(value: '${all.length}', label: l.totalLabel),
                ConsoleMetric(
                  value: '$pending',
                  label: l.bookingPending,
                  attention: pending > 0,
                  onTap: () =>
                      setState(() => _filter = StaffBookingFilter.pending),
                ),
                ConsoleMetric(
                  value: '$upcoming',
                  label: l.consoleUpcoming,
                  onTap: () =>
                      setState(() => _filter = StaffBookingFilter.upcoming),
                ),
              ],
            ),
            ConsoleToolbar(
              search: SearchField(
                hintText: l.consoleSearchBookings,
                onChanged: (v) => setState(() => _query = v),
              ),
              filters: [
                for (final f in StaffBookingFilter.values)
                  ConsoleFilterChip(
                    label: f.labelIn(l),
                    count: _apply(all, f).length,
                    selected: f == _filter,
                    onSelected: () => setState(() => _filter = f),
                  ),
                const SizedBox(width: AppSpacing.md),
                _ShopFilter(
                  shopIds: shopIds,
                  selected: _shopId,
                  onChanged: (id) => setState(() => _shopId = id),
                ),
              ],
            ),
          ],
        ),
        children: [
          if (shown.isEmpty)
            EmptyView.inline(
              icon: Icons.inbox_outlined,
              title: l.staffNoBookingsTitle,
              message: l.staffTryAnotherFilter,
            )
          else ...[
            ConsoleHeading(_filter.labelIn(l), count: shown.length),
            ConsoleBookingTable(
              bookings: shown,
              shopNameOf: (b) => DemoData.shop(b.shopId).name,
              onOpen: (b) => context.push(AppRoutes.superadminBooking(b.id)),
            ),
          ],
        ],
      ),
    );
  }
}

/// "All shops ▾" menu for narrowing the table to one shop.
class _ShopFilter extends StatelessWidget {
  const _ShopFilter({
    required this.shopIds,
    required this.selected,
    required this.onChanged,
  });

  final List<String> shopIds;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final label =
        selected == null ? l.consoleAllShops : DemoData.shop(selected!).name;
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () => onChanged(null),
          leadingIcon: selected == null ? const Icon(Icons.check) : null,
          child: Text(l.consoleAllShops),
        ),
        for (final id in shopIds)
          MenuItemButton(
            onPressed: () => onChanged(id),
            leadingIcon: selected == id ? const Icon(Icons.check) : null,
            child: Text(DemoData.shop(id).name),
          ),
      ],
      builder: (context, controller, _) => ConsoleFilterChip(
        label: '$label ▾',
        selected: selected != null,
        onSelected: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}
