import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/customer/bookings/:bookingId` - Phase 1 placeholder.
class CustomerBookingDetailScreen extends StatelessWidget {
  const CustomerBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Booking');
}
