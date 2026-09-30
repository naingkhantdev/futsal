import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/booking_list_tile.dart';
import '../../../shared/widgets/preview_body.dart';
import '../../../shared/widgets/stadium_filter_bar.dart';

/// `/customer/bookings` — CUSTOMER scope: own bookings, Upcoming / Past.
/// PREVIEW: sample data (`DemoData`) until Phase 10.
class CustomerBookingsScreen extends StatelessWidget {
  const CustomerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mine = DemoData.bookingsOfCustomer(DemoData.meId);
    final upcoming = DemoData.upcoming(mine);
    final past = mine.where((b) => !upcoming.contains(b)).toList();
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.navBookings),
          // PreferredSize so the tab bar can be a tour anchor.
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight),
            child: TourAnchor(
              id: TourIds.tabs,
              child: TabBar(
                tabs: [
                  Tab(text: l.tabUpcoming(upcoming.length)),
                  Tab(text: l.tabPast(past.length)),
                ],
              ),
            ),
          ),
          actions: const [TourHelpButton()],
        ),
        body: TabBarView(
          children: [
            _BookingList(
              bookings: upcoming,
              emptyTitle: l.emptyUpcomingTitle,
              emptyMessage: l.emptyUpcomingMessage,
            ),
            _BookingList(
              bookings: past,
              emptyTitle: l.emptyPastTitle,
              emptyMessage: l.emptyPastMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatefulWidget {
  const _BookingList({
    required this.bookings,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  final List<BookingVO> bookings;
  final String emptyTitle;
  final String emptyMessage;

  @override
  State<_BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<_BookingList> {
  /// `null` = all stadiums.
  String? _stadiumId;

  @override
  Widget build(BuildContext context) {
    final bookings = _stadiumId == null
        ? widget.bookings
        : widget.bookings.where((b) => b.stadiumId == _stadiumId).toList();
    return PreviewBody(
      children: [
        StadiumFilterBar(
          bookings: widget.bookings,
          selected: _stadiumId,
          onSelected: (id) => setState(() => _stadiumId = id),
        ),
        if (bookings.isEmpty)
          EmptyView.inline(
            icon: Icons.event_available_outlined,
            title: widget.emptyTitle,
            message: widget.emptyMessage,
          )
        else
          BookingGroup(
            bookings: bookings,
            onOpen: (b) => context.push(AppRoutes.customerBooking(b.id)),
          ),
      ],
    );
  }
}
