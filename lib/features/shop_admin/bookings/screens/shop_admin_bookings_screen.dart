import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/staff_booking_views.dart';

/// `/shop-admin/bookings` — SHOP scope (own `shopId` only): bookings with
/// Pending / Upcoming / Past filters. PREVIEW: sample data until Phase 11.
class ShopAdminBookingsScreen extends StatelessWidget {
  const ShopAdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        actions: [
          IconButton(
            tooltip: 'Block time',
            icon: const Icon(Icons.block),
            onPressed: () => context.push(AppRoutes.shopAdminBlockedSlots),
          ),
        ],
      ),
      body: StaffBookingList(
        bookings: DemoData.bookingsOfShop(DemoData.myShopId),
        onOpen: (b) => context.push(AppRoutes.shopAdminBooking(b.id)),
      ),
    );
  }
}
