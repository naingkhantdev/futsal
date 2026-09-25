import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/superadmin/bookings/:bookingId` - Phase 1 placeholder.
class SuperadminBookingDetailScreen extends StatelessWidget {
  const SuperadminBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Booking');
}
