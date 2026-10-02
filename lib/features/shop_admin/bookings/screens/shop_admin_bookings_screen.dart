import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/staff_booking_views.dart';
import '../providers/shop_bookings_providers.dart';

/// `/shop-admin/bookings` — SHOP scope (own `shopId` only): bookings with
/// Pending / Upcoming / Past filters.
class ShopAdminBookingsScreen extends ConsumerWidget {
  const ShopAdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(shopBookingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navBookings),
        actions: [
          const TourHelpButton(),
          TourAnchor(
            id: TourIds.block,
            child: IconButton(
              tooltip: context.l10n.blockTimeTitle,
              icon: const Icon(Icons.block),
              onPressed: () => context.push(AppRoutes.shopAdminBlockedSlots),
            ),
          ),
        ],
      ),
      body: AsyncValueView<List<BookingVO>>(
        value: bookings,
        onRetry: () => ref.invalidate(shopBookingsProvider),
        data: (list) => StaffBookingList(
          bookings: list,
          onOpen: (b) => context.push(AppRoutes.shopAdminBooking(b.id)),
        ),
      ),
    );
  }
}
