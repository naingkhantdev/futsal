import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/staff_booking_views.dart';
import '../../blacklist/widgets/blacklist_action.dart';

/// `/shop-admin/bookings/:bookingId` — SHOP scope (booking.shopId must be the
/// admin's shop; enforced by firestore.rules): details and confirm / reject /
/// complete / payment actions. PREVIEW: sample data, actions save nothing.
class ShopAdminBookingDetailScreen extends StatelessWidget {
  const ShopAdminBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final b = DemoData.booking(bookingId);
    // A started booking that wasn't cancelled/rejected may be a no-show.
    final mayBeNoShow = !b.isUpcoming(DateTime.now()) &&
        b.status != BookingStatus.cancelled &&
        b.status != BookingStatus.rejected;
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: StaffBookingDetail(
        booking: b,
        onCustomerTap: () =>
            context.push(AppRoutes.shopAdminCustomer(b.customerId)),
        extraActions: [
          if (mayBeNoShow)
            BlacklistCustomerAction(
              customerId: b.customerId,
              customerName: b.customerNameSnapshot,
              customerPhone: b.customerPhoneSnapshot,
              noShow: true,
            ),
        ],
      ),
    );
  }
}
