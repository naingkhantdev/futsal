import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../data/repositories/booking_repository.dart';
import '../../../../data/vos/auth_session.dart';
import '../../../../data/vos/booking_draft.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../auth/providers/auth_session_provider.dart';

/// CUSTOMER scope: the signed-in customer's own bookings, newest first.
/// The query filters `customerId == uid`, as firestore.rules require.
final myBookingsProvider = StreamProvider.autoDispose<List<BookingVO>>((ref) {
  final uid = ref.watch(
    currentAuthSessionProvider.select((s) => s is SignedIn ? s.uid : null),
  );
  if (uid == null) return Stream.error(const AuthenticationException());
  return ref.watch(bookingRepositoryProvider).watchMyBookings(uid);
});

/// Requests a booking from a draft. Returns the new booking id, or `null`
/// on failure (the error, e.g. `BookingConflictException`, is in `state`).
class CreateBookingController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> submit(BookingDraft draft) async {
    state = const AsyncLoading();
    String? id;
    state = await AsyncValue.guard(() async {
      id = await ref.read(bookingRepositoryProvider).createBooking(draft);
    });
    return state.hasError ? null : id;
  }
}

final createBookingControllerProvider =
    AsyncNotifierProvider.autoDispose<CreateBookingController, void>(
  CreateBookingController.new,
);
