import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../data/repositories/booking_repository.dart';
import '../../../../data/vos/blocked_slot_vo.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../../../auth/providers/auth_session_provider.dart';
import '../../../shared/providers/booking_providers.dart';

/// SHOP scope. The shop is always the signed-in admin's
/// `users/{uid}.shopId` ([currentShopIdProvider]); every query filters on
/// it, as firestore.rules require.

/// How far back the admin's booking list reaches (history, customers).
const int shopHistoryDays = 365;

/// Bookings of the admin's shop from [shopHistoryDays] ago until the end of
/// the booking window, newest first.
final shopBookingsProvider = StreamProvider.autoDispose<List<BookingVO>>((ref) {
  final shopId = ref.watch(currentShopIdProvider);
  if (shopId == null) return Stream.error(const PermissionDeniedException());
  final now = DateTime.now().toUtc();
  return ref
      .watch(bookingRepositoryProvider)
      .watchShopBookings(
        shopId,
        from: now.subtract(const Duration(days: shopHistoryDays)),
        to: now.add(const Duration(days: BookingPolicy.maxAdvanceDays + 1)),
      )
      .map((list) => list.reversed.toList());
});

/// A customer as the shop sees them: only the booking snapshots (shop
/// admins can't read `users/{uid}`; firestore.rules).
typedef ShopCustomer = ({
  String id,
  String name,
  String? phone,
  CustomerStats stats,
});

/// Customers who booked at the admin's shop, by name.
final shopCustomersProvider =
    Provider.autoDispose<AsyncValue<List<ShopCustomer>>>((ref) {
  return ref.watch(shopBookingsProvider).whenData((bookings) {
    final byCustomer = <String, List<BookingVO>>{};
    for (final b in bookings) {
      byCustomer.putIfAbsent(b.customerId, () => []).add(b);
    }
    final list = [
      for (final MapEntry(key: id, value: own) in byCustomer.entries)
        // Newest booking first: its snapshot has the latest name / phone.
        (
          id: id,
          name: own.first.customerNameSnapshot,
          phone: own.first.customerPhoneSnapshot,
          stats: customerStatsOf(own),
        ),
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  });
});

/// Blocks of the admin's shop that have not ended yet, earliest first.
final shopBlockedSlotsProvider =
    StreamProvider.autoDispose<List<BlockedSlotVO>>((ref) {
  final shopId = ref.watch(currentShopIdProvider);
  if (shopId == null) return Stream.error(const PermissionDeniedException());
  return ref.watch(bookingRepositoryProvider).watchUpcomingBlockedSlots(shopId);
});

/// Blocks / unblocks court time. Returns `true` on success; on failure the
/// error (e.g. `BookingConflictException` when a slot is booked) is in
/// `state`.
class BlockedSlotsController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> block({
    required StadiumVO stadium,
    required CourtVO court,
    required String date,
    required int startMinute,
    required int endMinute,
    required BlockedSlotReason reason,
    String? note,
  }) =>
      _run(
        () => ref.read(bookingRepositoryProvider).blockSlots(
              stadium: stadium,
              court: court,
              date: date,
              startMinute: startMinute,
              endMinute: endMinute,
              reason: reason,
              note: note,
            ),
      );

  Future<bool> unblock(String blockedSlotId) => _run(
        () => ref.read(bookingRepositoryProvider).unblockSlots(blockedSlotId),
      );

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}

final blockedSlotsControllerProvider =
    AsyncNotifierProvider.autoDispose<BlockedSlotsController, void>(
  BlockedSlotsController.new,
);
