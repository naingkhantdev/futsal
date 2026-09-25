import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// `/shop-admin/customers/:customerId` - Phase 1 placeholder.
class ShopAdminCustomerDetailScreen extends StatelessWidget {
  const ShopAdminCustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Customer');
}
