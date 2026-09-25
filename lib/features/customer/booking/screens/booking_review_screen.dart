import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/customer/stadiums/:stadiumId/book/review` - Phase 1 placeholder.
class BookingReviewScreen extends StatelessWidget {
  const BookingReviewScreen({super.key, required this.stadiumId});

  final String stadiumId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Review booking');
}
