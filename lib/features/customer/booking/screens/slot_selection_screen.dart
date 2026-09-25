import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/customer/stadiums/:stadiumId/book?courtId=&date=` - Phase 1 placeholder.
class SlotSelectionScreen extends StatelessWidget {
  const SlotSelectionScreen({
    super.key,
    required this.stadiumId,
    this.courtId,
    this.date,
  });

  final String stadiumId;
  final String? courtId;
  final String? date;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Book a court');
}
