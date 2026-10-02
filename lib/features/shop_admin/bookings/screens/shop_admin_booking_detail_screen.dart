import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/providers/booking_providers.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/staff_booking_views.dart';
import '../../blacklist/widgets/blacklist_action.dart';

/// `/shop-admin/bookings/:bookingId` — SHOP scope (booking.shopId must be the
/// admin's shop; enforced by firestore.rules): details and confirm / reject /
/// complete / payment actions.
class ShopAdminBookingDetailScreen extends ConsumerWidget {
  const ShopAdminBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider(bookingId));
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.bookingTitle),
        actions: const [TourHelpButton()],
      ),
      body: AsyncValueView<BookingVO?>(
        value: booking,
        onRetry: () => ref.invalidate(bookingProvider(bookingId)),
        isEmpty: (b) => b == null,
        empty: EmptyView(
          icon: Icons.event_busy,
          title: l.bookingNotFound,
          message: l.notFoundRemoved,
        ),
        data: (b) {
          // A started booking that wasn't cancelled/rejected may be a no-show.
          final mayBeNoShow = !b!.isUpcoming(DateTime.now()) &&
              b.status != BookingStatus.cancelled &&
              b.status != BookingStatus.rejected;
          return StaffBookingDetail(
            booking: b,
            onCustomerTap: () =>
                context.push(AppRoutes.shopAdminCustomer(b.customerId)),
            extraActions: [
              if (mayBeNoShow)
                TourAnchor(
                  id: TourIds.blacklist,
                  child: BlacklistCustomerAction(
                    customerId: b.customerId,
                    customerName: b.customerNameSnapshot,
                    customerPhone: b.customerPhoneSnapshot,
                    noShow: true,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
