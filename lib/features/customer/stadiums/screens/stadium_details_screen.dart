import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/customer/stadiums/:stadiumId` - Phase 1 placeholder.
class StadiumDetailsScreen extends StatelessWidget {
  const StadiumDetailsScreen({super.key, required this.stadiumId});

  final String stadiumId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Stadium');
}
