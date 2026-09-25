import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/superadmin/customers/:customerId` - Phase 1 placeholder.
class SuperadminCustomerDetailScreen extends StatelessWidget {
  const SuperadminCustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Customer');
}
