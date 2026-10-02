import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/domain_enums.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/vos/booking_vo.dart';

/// One booking, for whoever may read it: its customer (CUSTOMER), the
/// shop's admins (SHOP) or the superadmin (PLATFORM). firestore.rules
/// refuse anyone else; `null` while it does not exist.
final bookingProvider = StreamProvider.autoDispose.family<BookingVO?, String>(
  (ref, bookingId) =>
      ref.watch(bookingRepositoryProvider).watchBooking(bookingId),
);

/// Status / payment changes on a booking. Each returns `true` on success;
/// on failure the error is in `state`. Which changes are allowed is decided
/// by `BookingPolicy` (UX) and firestore.rules (enforcement).
class BookingActionsController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// CUSTOMER scope: own pending / confirmed booking before it starts.
  Future<bool> cancel(String bookingId, {String? reason}) => _run(
        () => ref
            .read(bookingRepositoryProvider)
            .cancelBooking(bookingId, reason: reason),
      );

  /// SHOP / PLATFORM scope: confirm, reject (frees the slots), complete.
  Future<bool> setStatus(
    String bookingId,
    BookingStatus status, {
    String? reason,
  }) =>
      _run(
        () => ref
            .read(bookingRepositoryProvider)
            .setBookingStatus(bookingId, status, reason: reason),
      );

  /// SHOP / PLATFORM scope.
  Future<bool> setPayment(String bookingId, PaymentStatus status) => _run(
        () => ref
            .read(bookingRepositoryProvider)
            .setPaymentStatus(bookingId, status),
      );

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}

final bookingActionsControllerProvider =
    AsyncNotifierProvider.autoDispose<BookingActionsController, void>(
  BookingActionsController.new,
);

/// Booking count, money paid and last game of one customer, from their
/// bookings (already limited to one shop for shop admins).
typedef CustomerStats = ({int bookings, int spent, DateTime? lastPlayed});

CustomerStats customerStatsOf(Iterable<BookingVO> bookings) {
  var count = 0;
  var spent = 0;
  DateTime? last;
  for (final b in bookings) {
    count++;
    if (b.paymentStatus == PaymentStatus.paid) spent += b.totalPrice;
    final start = b.startAt;
    if (b.status == BookingStatus.completed &&
        start != null &&
        (last == null || start.isAfter(last))) {
      last = start;
    }
  }
  return (bookings: count, spent: spent, lastPlayed: last);
}

/// Pending / confirmed bookings that haven't started, soonest first.
List<BookingVO> upcomingOf(Iterable<BookingVO> bookings, {DateTime? now}) {
  final at = now ?? DateTime.now();
  return bookings.where((b) => b.isUpcoming(at)).toList()
    ..sort((a, b) => a.startAt!.compareTo(b.startAt!));
}
