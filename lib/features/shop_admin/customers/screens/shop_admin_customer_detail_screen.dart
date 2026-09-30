import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
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
      appBar: AppBar(
        title: Text(context.l10n.roleCustomer),
        actions: const [TourHelpButton()],
      ),
      body: StaffCustomerDetail(
        customer: customer,
        shopId: DemoData.myShopId,
        onOpenBooking: (b) => context.push(AppRoutes.shopAdminBooking(b.id)),
        actions: [
          TourAnchor(
            id: TourIds.blacklist,
            child: BlacklistCustomerAction(
              customerId: customer.id,
              customerName: customer.name,
              customerPhone: customer.phone,
            ),
          ),
        ],
      ),
    );
  }
}
