import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/shop-admin/bookings/:bookingId` - Phase 1 placeholder.
class ShopAdminBookingDetailScreen extends StatelessWidget {
  const ShopAdminBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Booking');
}
