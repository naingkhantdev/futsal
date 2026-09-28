import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/staff_customer_views.dart';

/// `/shop-admin/customers` — SHOP scope: customers who booked at this shop.
/// PREVIEW: sample data until the customers phase.
class ShopAdminCustomersScreen extends StatelessWidget {
  const ShopAdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: StaffCustomerList(
        shopId: DemoData.myShopId,
        onOpen: (c) => context.push(AppRoutes.shopAdminCustomer(c.id)),
      ),
    );
  }
}
