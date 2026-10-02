import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/staff_customer_views.dart';
import '../../blacklist/widgets/blacklist_action.dart';
import '../../bookings/providers/shop_bookings_providers.dart';

/// `/shop-admin/customers/:customerId` — SHOP scope: contact, stats and
/// history at this shop only (from the shop's bookings; shop admins can't
/// read `users/{uid}`).
class ShopAdminCustomerDetailScreen extends ConsumerWidget {
  const ShopAdminCustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(shopBookingsProvider);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.roleCustomer),
        actions: const [TourHelpButton()],
      ),
      body: AsyncValueView<List<BookingVO>>(
        value: bookings.whenData(
          (all) => all.where((b) => b.customerId == customerId).toList(),
        ),
        onRetry: () => ref.invalidate(shopBookingsProvider),
        isEmpty: (history) => history.isEmpty,
        empty: EmptyView(
          icon: Icons.person_search_outlined,
          title: l.customerNotFound,
          message: l.notFoundRemoved,
        ),
        data: (history) {
          // Newest booking first: its snapshot has the latest name / phone.
          final latest = history.first;
          return StaffCustomerDetail(
            name: latest.customerNameSnapshot,
            phone: latest.customerPhoneSnapshot,
            history: history,
            onOpenBooking: (b) =>
                context.push(AppRoutes.shopAdminBooking(b.id)),
            actions: [
              TourAnchor(
                id: TourIds.blacklist,
                child: BlacklistCustomerAction(
                  customerId: customerId,
                  customerName: latest.customerNameSnapshot,
                  customerPhone: latest.customerPhoneSnapshot,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
