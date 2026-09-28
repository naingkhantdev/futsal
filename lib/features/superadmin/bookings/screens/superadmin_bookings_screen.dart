import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/staff_booking_views.dart';

/// `/superadmin/bookings` — PLATFORM scope: bookings across all shops.
/// PREVIEW: sample data until Phase 11.
class SuperadminBookingsScreen extends StatelessWidget {
  const SuperadminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: StaffBookingList(
        bookings: DemoData.allBookings(),
        onOpen: (b) => context.push(AppRoutes.superadminBooking(b.id)),
      ),
    );
  }
}
