import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/cancellation_policy.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../../data/vos/shop_vo.dart';
import '../../../shared/widgets/staff_booking_views.dart';
import '../../console/widgets/console_booking_table.dart';
import '../../console/widgets/console_kit.dart';
import '../../shared/providers/platform_providers.dart';
import '../../shops/providers/shops_providers.dart';

/// `/superadmin/bookings` — PLATFORM scope: bookings across all shops, with
/// status / shop filters and a customer / stadium search.
class SuperadminBookingsScreen extends ConsumerWidget {
  const SuperadminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ConsoleAppBar(title: context.l10n.navBookings),
      body: AsyncValueView<List<BookingVO>>(
        value: ref.watch(allBookingsProvider),
        onRetry: () => ref.invalidate(allBookingsProvider),
        data: (all) => _Bookings(all: all),
      ),
    );
  }
}

class _Bookings extends ConsumerStatefulWidget {
  const _Bookings({required this.all});

  /// Newest first.
  final List<BookingVO> all;

  @override
  ConsumerState<_Bookings> createState() => _BookingsState();
}

class _BookingsState extends ConsumerState<_Bookings> {
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
      StaffBookingFilter.refundsDue =>
        list.where((b) => b.refundState == RefundState.due).toList(),
      StaffBookingFilter.all => list.toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final all = widget.all;
    final shopNames = <String, String>{
      for (final s in ref.watch(allShopsProvider).valueOrNull ?? const <ShopVO>[])
        s.id: s.name,
    };
    final now = DateTime.now();
    final pending = all.where((b) => b.status == BookingStatus.pending).length;
    final upcoming = all.where((b) => b.isUpcoming(now)).length;
    final shopIds = {for (final b in all) b.shopId}.toList();
    final shown = _apply(all, _filter);

    return ConsoleBody(
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
                  shopNames: shopNames,
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
              shopNameOf: (b) => shopNames[b.shopId] ?? '',
              onOpen: (b) => context.push(AppRoutes.superadminBooking(b.id)),
            ),
          ],
        ],
    );
  }
}

/// "All shops ▾" menu for narrowing the table to one shop.
class _ShopFilter extends StatelessWidget {
  const _ShopFilter({
    required this.shopIds,
    required this.shopNames,
    required this.selected,
    required this.onChanged,
  });

  final List<String> shopIds;
  final Map<String, String> shopNames;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final label =
        selected == null ? l.consoleAllShops : shopNames[selected!] ?? '';
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
            child: Text(shopNames[id] ?? id),
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
