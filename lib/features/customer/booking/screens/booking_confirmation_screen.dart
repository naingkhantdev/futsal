import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/customer/bookings/:bookingId/confirmation` - Phase 1 placeholder.
class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Booking confirmed');
}
