import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/shop-admin/blocked-slots/new?stadiumId=&courtId=&date=` - Phase 1 placeholder.
class BlockedSlotFormScreen extends StatelessWidget {
  const BlockedSlotFormScreen({
    super.key,
    this.stadiumId,
    this.courtId,
    this.date,
  });

  final String? stadiumId;
  final String? courtId;
  final String? date;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Block time');
}
