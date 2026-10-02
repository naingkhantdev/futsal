import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/providers/booking_providers.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/booking_list_tile.dart';
import '../../../shared/widgets/page_body.dart';
import '../../../shared/widgets/stadium_filter_bar.dart';
import '../providers/customer_bookings_providers.dart';

/// `/customer/bookings` — CUSTOMER scope: own bookings, Upcoming / Past.
class CustomerBookingsScreen extends ConsumerWidget {
  const CustomerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myBookingsProvider);
    final mine = value.valueOrNull ?? const <BookingVO>[];
    final upcoming = upcomingOf(mine);
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
        body: AsyncValueView<List<BookingVO>>(
          value: value,
          onRetry: () => ref.invalidate(myBookingsProvider),
          data: (_) => TabBarView(
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
    return PageBody(
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
