import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/staff_customer_views.dart';
import '../../bookings/providers/shop_bookings_providers.dart';

/// `/shop-admin/customers` — SHOP scope: customers who booked at this shop,
/// built from the shop's booking snapshots.
class ShopAdminCustomersScreen extends ConsumerWidget {
  const ShopAdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(shopCustomersProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navCustomers),
        actions: const [TourHelpButton()],
      ),
      body: AsyncValueView<List<ShopCustomer>>(
        value: customers,
        onRetry: () => ref.invalidate(shopBookingsProvider),
        data: (list) => StaffCustomerList(
          customers: list,
          onOpen: (id) => context.push(AppRoutes.shopAdminCustomer(id)),
        ),
      ),
    );
  }
}
