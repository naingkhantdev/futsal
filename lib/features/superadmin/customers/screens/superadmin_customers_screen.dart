import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/staff_customer_views.dart';

/// `/superadmin/customers` — PLATFORM scope: every customer account.
/// PREVIEW: sample data.
class SuperadminCustomersScreen extends StatelessWidget {
  const SuperadminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navCustomers),
        actions: const [TourHelpButton()],
      ),
      body: StaffCustomerList(
        shopId: null,
        onOpen: (c) => context.push(AppRoutes.superadminCustomer(c.id)),
      ),
    );
  }
}
