import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/staff_booking_views.dart';

/// `/superadmin/bookings/:bookingId` — PLATFORM scope: any booking, with the
/// same staff actions as the shop admin. PREVIEW: actions save nothing.
class SuperadminBookingDetailScreen extends StatelessWidget {
  const SuperadminBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final b = DemoData.booking(bookingId);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.bookingTitle)),
      body: StaffBookingDetail(
        booking: b,
        shopName: DemoData.shop(b.shopId).name,
        onCustomerTap: () =>
            context.push(AppRoutes.superadminCustomer(b.customerId)),
      ),
    );
  }
}
