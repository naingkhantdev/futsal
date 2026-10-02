import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../data/repositories/announcement_repository.dart';
import '../../../../data/repositories/booking_repository.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/vos/announcement_vo.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../../data/vos/user_vo.dart';

/// PLATFORM scope: superadmin reads across every shop. firestore.rules
/// allow these queries for an active superadmin only.

/// Latest bookings of every shop, newest first (capped).
final allBookingsProvider = StreamProvider.autoDispose<List<BookingVO>>(
  (ref) => ref.watch(bookingRepositoryProvider).watchAllBookings(),
);

/// Every customer account, by name.
final allCustomersProvider = StreamProvider.autoDispose<List<UserVO>>(
  (ref) => ref.watch(userRepositoryProvider).watchCustomers(),
);

final userProvider = StreamProvider.autoDispose.family<UserVO?, String>(
  (ref, uid) => ref.watch(userRepositoryProvider).watchUser(uid),
);

/// One customer's bookings at every shop, newest first.
final customerBookingsProvider =
    StreamProvider.autoDispose.family<List<BookingVO>, String>(
  (ref, uid) => ref.watch(bookingRepositoryProvider).watchMyBookings(uid),
);

/// Enables / disables an account (`users/{uid}.isActive`). Returns `true`
/// on success; on failure the error is in `state`.
class UserActiveController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> setActive(String uid, {required bool isActive}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(userRepositoryProvider)
          .setUserActive(uid, isActive: isActive),
    );
    return !state.hasError;
  }
}

final userActiveControllerProvider =
    AsyncNotifierProvider.autoDispose<UserActiveController, void>(
  UserActiveController.new,
);

/// Sent announcements, newest first.
final announcementsProvider = StreamProvider.autoDispose<List<AnnouncementVO>>(
  (ref) => ref.watch(announcementRepositoryProvider).watchAll(),
);

/// Sends an announcement. Returns `true` on success; on failure the error
/// is in `state`.
class SendAnnouncementController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> send({
    required String title,
    required String body,
    required AnnouncementAudience audience,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(announcementRepositoryProvider)
          .send(title: title, body: body, audience: audience),
    );
    return !state.hasError;
  }
}

final sendAnnouncementControllerProvider =
    AsyncNotifierProvider.autoDispose<SendAnnouncementController, void>(
  SendAnnouncementController.new,
);
