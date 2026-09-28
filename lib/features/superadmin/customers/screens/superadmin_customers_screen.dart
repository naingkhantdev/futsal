import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../shared/widgets/staff_customer_views.dart';

/// `/superadmin/customers` — PLATFORM scope: every customer account.
/// PREVIEW: sample data.
class SuperadminCustomersScreen extends StatelessWidget {
  const SuperadminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: StaffCustomerList(
        shopId: null,
        onOpen: (c) => context.push(AppRoutes.superadminCustomer(c.id)),
      ),
    );
  }
}
