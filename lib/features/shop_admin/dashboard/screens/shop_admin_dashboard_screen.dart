import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/hero_header.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/booking_list_tile.dart';
import '../../../shared/widgets/preview_body.dart';
import '../../../shared/widgets/stat_grid.dart';

/// `/shop-admin/dashboard` — SHOP scope (own `shopId` only): today's
/// numbers, requests to answer and today's schedule.
/// PREVIEW: sample data (`DemoData`) until Phase 14.
class ShopAdminDashboardScreen extends StatelessWidget {
  const ShopAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = DemoData.shop(DemoData.myShopId);
    final all = DemoData.bookingsOfShop(shop.id);
    final today = DateKey.fromDate(DateTime.now());
    final todays = all.where((b) => b.bookingDate == today).toList()
      ..sort((a, b) => a.startMinute.compareTo(b.startMinute));
    final pending =
        all.where((b) => b.status == BookingStatus.pending).toList();
    final revenue = all
        .where((b) => b.paymentStatus == PaymentStatus.paid)
        .fold<int>(0, (sum, b) => sum + b.totalPrice);
    final courtCount =
        DemoData.courts.where((c) => c.shopId == shop.id).length;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.navDashboard)),
      body: PreviewBody(
        width: ContentWidth.dashboard,
        children: [
          HeroHeader(
            eyebrow: DisplayFormat.fullDate(today),
            title: shop.name,
            subtitle: l.venueCounts(
              DemoData.stadiumsOf(shop.id).length,
              courtCount,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          StatGrid(
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
                value: '${DemoData.customersOf(shop.id).length}',
                footer: l.statBookedWithYou,
                onTap: () => context.go(AppRoutes.shopAdminCustomers),
              ),
            ],
          ),
          PreviewSectionTitle(
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
          PreviewSectionTitle(l.todaysSchedule),
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
      ),
    );
  }
}
