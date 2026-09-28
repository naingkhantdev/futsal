import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
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
    final styles = context.textStyles;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: PreviewBody(
        width: ContentWidth.dashboard,
        children: [
          Text(shop.name, style: styles.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${DemoData.stadiumsOf(shop.id).length} stadiums · '
            '${DemoData.courts.where((c) => c.shopId == shop.id).length} courts',
            style: styles.bodyMedium
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xl),
          StatGrid(
            children: [
              StatCard(
                icon: Icons.today_outlined,
                label: 'Today',
                value: '${todays.length}',
                footer: 'bookings',
                onTap: () => context.go(AppRoutes.shopAdminBookings),
              ),
              StatCard(
                icon: Icons.hourglass_top,
                label: 'Pending',
                value: '${pending.length}',
                footer: 'need a reply',
                tone: pending.isEmpty ? StatusTone.brand : StatusTone.warning,
                onTap: () => context.go(AppRoutes.shopAdminBookings),
              ),
              StatCard(
                icon: Icons.payments_outlined,
                label: 'Collected',
                // Compact so it fits a half-width card.
                value: '${revenue ~/ 1000}K',
                footer: 'MMK from paid bookings',
              ),
              StatCard(
                icon: Icons.people_outline,
                label: 'Customers',
                value: '${DemoData.customersOf(shop.id).length}',
                footer: 'booked with you',
                onTap: () => context.go(AppRoutes.shopAdminCustomers),
              ),
            ],
          ),
          PreviewSectionTitle(
            'Needs your reply',
            action: TextButton(
              onPressed: () => context.go(AppRoutes.shopAdminBookings),
              child: const Text('All bookings'),
            ),
          ),
          if (pending.isEmpty)
            const EmptyView.inline(
              icon: Icons.inbox_outlined,
              title: 'All caught up',
              message: 'New booking requests show up here.',
            )
          else
            for (final b in pending) ...[
              BookingListTile(
                booking: b,
                showCustomer: true,
                onTap: () => context.push(AppRoutes.shopAdminBooking(b.id)),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          const PreviewSectionTitle("Today's schedule"),
          if (todays.isEmpty)
            const EmptyView.inline(
              icon: Icons.event_available_outlined,
              title: 'No games today',
            )
          else
            for (final b in todays) ...[
              BookingListTile(
                booking: b,
                showCustomer: true,
                onTap: () => context.push(AppRoutes.shopAdminBooking(b.id)),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}
