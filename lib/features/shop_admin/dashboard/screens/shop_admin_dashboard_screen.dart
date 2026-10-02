import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/hero_header.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/booking_list_tile.dart';
import '../../../shared/widgets/notification_bell_button.dart';
import '../../../shared/widgets/page_body.dart';
import '../../../shared/widgets/stat_grid.dart';
import '../../bookings/providers/shop_bookings_providers.dart';
import '../../stadiums/providers/shop_venue_providers.dart';

/// `/shop-admin/dashboard` — SHOP scope (own `shopId` only): today's
/// numbers, requests to answer and today's schedule.
class ShopAdminDashboardScreen extends ConsumerWidget {
  const ShopAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.navDashboard),
        actions: const [
          TourHelpButton(),
          TourAnchor(
            id: TourIds.bell,
            child: NotificationBellButton(
              route: AppRoutes.shopAdminNotifications,
            ),
          ),
          SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: AsyncValueView<List<BookingVO>>(
        value: ref.watch(shopBookingsProvider),
        onRetry: () => ref.invalidate(shopBookingsProvider),
        data: (all) => _Dashboard(bookings: all),
      ),
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard({required this.bookings});

  final List<BookingVO> bookings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = bookings;
    final shopName = ref.watch(myShopProvider).valueOrNull?.name ?? '';
    final stadiums = ref.watch(myStadiumsProvider).valueOrNull ?? const [];
    var courtCount = 0;
    for (final s in stadiums) {
      courtCount += ref.watch(adminCourtsProvider(s.id)).valueOrNull?.length ?? 0;
    }
    final customerCount =
        ref.watch(shopCustomersProvider).valueOrNull?.length ?? 0;
    final today = DateKey.fromDate(DateTime.now());
    final todays = all.where((b) => b.bookingDate == today).toList()
      ..sort((a, b) => a.startMinute.compareTo(b.startMinute));
    final pending =
        all.where((b) => b.status == BookingStatus.pending).toList();
    final revenue = all
        .where((b) => b.paymentStatus == PaymentStatus.paid)
        .fold<int>(0, (sum, b) => sum + b.totalPrice);
    final l = context.l10n;

    return PageBody(
        width: ContentWidth.dashboard,
        children: [
          HeroHeader(
            eyebrow: DisplayFormat.fullDate(today),
            title: shopName,
            subtitle: l.venueCounts(stadiums.length, courtCount),
          ),
          const SizedBox(height: AppSpacing.xl),
          TourAnchor(
            id: TourIds.stats,
            child: StatGrid(
              children: [
                StatCard(
                  icon: Icons.today_outlined,
                  label: l.dayToday,
                  value: '${todays.length}',
                  footer: l.statBookingsFooter,
                  onTap: () => context.go(AppRoutes.shopAdminBookings),
                ),
                StatCard(
                  icon: Icons.hourglass_top,
                  label: l.bookingPending,
                  value: '${pending.length}',
                  footer: l.statNeedReply,
                  highlight: pending.isNotEmpty,
                  onTap: () => context.go(AppRoutes.shopAdminBookings),
                ),
                StatCard(
                  icon: Icons.payments_outlined,
                  label: l.statCollected,
                  // Compact so it fits a half-width card.
                  value: '${revenue ~/ 1000}K',
                  footer: l.statMmkFromPaid,
                ),
                StatCard(
                  icon: Icons.people_outline,
                  label: l.navCustomers,
                  value: '$customerCount',
                  footer: l.statBookedWithYou,
                  onTap: () => context.go(AppRoutes.shopAdminCustomers),
                ),
              ],
            ),
          ),
          PageSectionTitle(
            l.needsYourReply,
            action: TextButton(
              onPressed: () => context.go(AppRoutes.shopAdminBookings),
              child: Text(l.homeAllBookings),
            ),
          ),
          if (pending.isEmpty)
            EmptyView.inline(
              icon: Icons.inbox_outlined,
              title: l.allCaughtUp,
              message: l.allCaughtUpMessage,
            )
          else
            BookingGroup(
              bookings: pending,
              showCustomer: true,
              onOpen: (b) => context.push(AppRoutes.shopAdminBooking(b.id)),
            ),
          PageSectionTitle(l.todaysSchedule),
          if (todays.isEmpty)
            EmptyView.inline(
              icon: Icons.event_available_outlined,
              title: l.noGamesToday,
            )
          else
            BookingGroup(
              bookings: todays,
              showCustomer: true,
              onOpen: (b) => context.push(AppRoutes.shopAdminBooking(b.id)),
            ),
        ],
    );
  }
}
