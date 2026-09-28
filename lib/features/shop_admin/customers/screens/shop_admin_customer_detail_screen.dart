import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/staff_customer_views.dart';
import '../../blacklist/widgets/blacklist_action.dart';

/// `/shop-admin/customers/:customerId` — SHOP scope: contact, stats and
/// history at this shop only. PREVIEW: sample data.
class ShopAdminCustomerDetailScreen extends StatelessWidget {
  const ShopAdminCustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    final customer = DemoData.customer(customerId);
    return Scaffold(
      appBar: AppBar(title: const Text('Customer')),
      body: StaffCustomerDetail(
        customer: customer,
        shopId: DemoData.myShopId,
        onOpenBooking: (b) => context.push(AppRoutes.shopAdminBooking(b.id)),
        actions: [
          BlacklistCustomerAction(
            customerId: customer.id,
            customerName: customer.name,
            customerPhone: customer.phone,
          ),
        ],
      ),
    );
  }
}
