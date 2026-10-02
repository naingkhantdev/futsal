import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/booking_policy.dart';
import '../../core/constants/domain_enums.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../data_agents/auth_data_agent.dart';
import '../data_agents/blacklist_data_agent.dart';
import '../data_agents/booking_data_agent.dart';
import '../data_agents/notification_data_agent.dart';
import '../data_agents/user_data_agent.dart';
import '../requests/booking_request_builder.dart';
import '../requests/booking_write_requests.dart';
import '../requests/notification_requests.dart';
import '../vos/blocked_slot_vo.dart';
import '../vos/booking_draft.dart';
import '../vos/booking_vo.dart';
import '../vos/court_vo.dart';
import '../vos/stadium_vo.dart';
import 'booking_repository.dart';
import 'mappers/blocked_slot_mapper.dart';
import 'mappers/booking_mapper.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required BookingDataAgent bookingDataAgent,
    required AuthDataAgent authDataAgent,
    required UserDataAgent userDataAgent,
    required BlacklistDataAgent blacklistDataAgent,
    required NotificationDataAgent notificationDataAgent,
    DateTime Function()? clock,
  })  : _bookings = bookingDataAgent,
        _auth = authDataAgent,
        _users = userDataAgent,
        _blacklist = blacklistDataAgent,
        _notifications = notificationDataAgent,
        _clock = clock ?? DateTime.now;

  final BookingDataAgent _bookings;
  final AuthDataAgent _auth;
  final UserDataAgent _users;
  final BlacklistDataAgent _blacklist;
  final NotificationDataAgent _notifications;
  final DateTime Function() _clock;

  @override
  Stream<List<BookingVO>> watchMyBookings(String uid) {
    return mapStreamErrors(
      _bookings
          .watchCustomerBookings(uid)
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Stream<List<BookingVO>> watchShopBookings(
    String shopId, {
    required DateTime from,
    required DateTime to,
  }) {
    if (!to.isAfter(from)) {
      return Stream.error(const InvalidDateException());
    }
    return mapStreamErrors(
      _bookings
          .watchShopBookings(shopId, from: from, to: to)
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Stream<List<BookingVO>> watchAllBookings() {
    return mapStreamErrors(
      _bookings
          .watchAllBookings()
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Stream<BookingVO?> watchBooking(String bookingId) {
    return mapStreamErrors(
      _bookings.watchBooking(bookingId).map((r) => r?.toVO()),
    );
  }

  @override
  Stream<List<BlockedSlotVO>> watchUpcomingBlockedSlots(String shopId) {
    return mapStreamErrors(
      _bookings
          .watchShopBlockedSlots(shopId, from: _clock().toUtc())
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Future<String> createBooking(BookingDraft draft) {
    return guardAppException(() async {
      final uid = _requireUid();
      // Fresh read: the rules compare the snapshots with users/{uid} exactly.
      final profile = await _users.getUser(uid);
      if (profile == null) throw const ProfileIncompleteException();
      if (!profile.isActive) throw const AccountDisabledException();
      // Friendly message up front; firestore.rules refuse it regardless.
      if (await _blacklist.isBlacklisted(draft.stadium.shopId, uid)) {
        throw const CustomerBlacklistedException();
      }

      final bookingId = _bookings.newBookingId();
      final request = BookingRequestBuilder.booking(
        draft: draft,
        bookingId: bookingId,
        customerId: uid,
        customerName: profile.name,
        customerPhone: profile.phone,
        now: _clock(),
      );
      await _createWithSlots(() => _bookings.createBooking(request));
      await _notify(
        NotificationCreateRequest(
          type: NotificationType.bookingRequested,
          recipientId: request.shopId,
          shopId: request.shopId,
          bookingId: bookingId,
          actorId: uid,
          customerNameSnapshot: request.customerNameSnapshot,
          stadiumNameSnapshot: request.stadiumNameSnapshot,
          courtNameSnapshot: request.courtNameSnapshot,
          bookingDate: request.bookingDate,
          startMinute: request.startMinute,
          endMinute: request.endMinute,
        ),
      );
      return bookingId;
    });
  }

  @override
  Future<void> cancelBooking(String bookingId, {String? reason}) {
    return guardAppException(() async {
      final uid = _requireUid();
      final booking = await _requireBooking(bookingId);
      if (booking.customerId != uid) throw const PermissionDeniedException();
      final start = booking.startAt;
      if (!BookingPolicy.canCustomerCancel(booking.status) ||
          start == null ||
          !start.isAfter(_clock())) {
        throw const InvalidBookingChangeException();
      }
      final cancelReason = BookingRequestBuilder.cleanReason(reason);
      await _bookings.updateBooking(
        BookingUpdateRequest(
          bookingId: bookingId,
          status: BookingStatus.cancelled,
          cancelReason: cancelReason,
          stampCancelledAt: true,
          slotPathsToDelete: BookingRequestBuilder.bookingSlotPaths(booking),
        ),
      );
      await _notify(
        NotificationCreateRequest.forBooking(
          type: NotificationType.bookingCancelled,
          booking: booking,
          actorId: uid,
          reason: cancelReason,
        ),
      );
    });
  }

  @override
  Future<void> setBookingStatus(
    String bookingId,
    BookingStatus status, {
    String? reason,
  }) {
    return guardAppException(() async {
      final uid = _requireUid();
      final booking = await _requireBooking(bookingId);
      if (!BookingPolicy.canStaffChangeStatus(booking.status, status)) {
        throw const InvalidBookingChangeException();
      }
      if (status == BookingStatus.completed) {
        final start = booking.startAt;
        if (start == null || _clock().isBefore(start)) {
          throw const InvalidBookingChangeException();
        }
      }
      final rejecting = status == BookingStatus.rejected;
      final cancelReason =
          rejecting ? BookingRequestBuilder.cleanReason(reason) : null;
      await _bookings.updateBooking(
        BookingUpdateRequest(
          bookingId: bookingId,
          status: status,
          cancelReason: cancelReason,
          slotPathsToDelete: rejecting
              ? BookingRequestBuilder.bookingSlotPaths(booking)
              : const [],
        ),
      );
      final type = switch (status) {
        BookingStatus.confirmed => NotificationType.bookingConfirmed,
        BookingStatus.rejected => NotificationType.bookingRejected,
        _ => null,
      };
      if (type != null) {
        await _notify(
          NotificationCreateRequest.forBooking(
            type: type,
            booking: booking,
            actorId: uid,
            reason: cancelReason,
          ),
        );
      }
    });
  }

  @override
  Future<void> setPaymentStatus(String bookingId, PaymentStatus status) {
    return guardAppException(() async {
      _requireUid();
      final booking = await _requireBooking(bookingId);
      if (!BookingPolicy.canChangePayment(booking.paymentStatus, status)) {
        throw const InvalidBookingChangeException();
      }
      await _bookings.updateBooking(
        BookingUpdateRequest(bookingId: bookingId, paymentStatus: status),
      );
    });
  }

  @override
  Future<String> blockSlots({
    required StadiumVO stadium,
    required CourtVO court,
    required String date,
    required int startMinute,
    required int endMinute,
    required BlockedSlotReason reason,
    String? note,
  }) {
    return guardAppException(() async {
      final uid = _requireUid();
      final blockedSlotId = _bookings.newBlockedSlotId();
      final request = BookingRequestBuilder.block(
        stadium: stadium,
        court: court,
        date: date,
        startMinute: startMinute,
        endMinute: endMinute,
        reason: reason,
        note: note,
        blockedSlotId: blockedSlotId,
        adminUid: uid,
      );
      await _createWithSlots(() => _bookings.createBlockedSlot(request));
      return blockedSlotId;
    });
  }

  @override
  Future<void> unblockSlots(String blockedSlotId) {
    return guardAppException(() async {
      _requireUid();
      final block = await _bookings.getBlockedSlot(blockedSlotId);
      if (block == null) throw const NotFoundException();
      await _bookings.deleteBlockedSlot(
        blockedSlotId: blockedSlotId,
        slotPaths: BookingRequestBuilder.blockSlotPaths(block.toVO()),
      );
    });
  }

  // --- internals ------------------------------------------------------------

  /// Writes the in-app notification for a booking event that already
  /// committed. Best effort: the booking change stands even if this fails
  /// (offline, rules), so errors are logged, never thrown. Its own request,
  /// not part of the booking transaction, to keep that transaction inside
  /// the rules' document-access budget.
  Future<void> _notify(NotificationCreateRequest request) async {
    try {
      await _notifications.create(request);
    } catch (error) {
      debugPrint('Notification ${request.id} not written: $error');
    }
  }

  String _requireUid() {
    final user = _auth.currentUser;
    if (user == null) throw const AuthenticationException();
    return user.uid;
  }

  Future<BookingVO> _requireBooking(String bookingId) async {
    final response = await _bookings.getBooking(bookingId);
    if (response == null) throw const NotFoundException();
    return response.toVO();
  }

  /// Runs a "parent + slot docs" create and maps the outcomes:
  /// - a slot seen as taken inside the transaction -> conflict;
  /// - permission-denied -> conflict. When another request commits a slot
  ///   between our read and our commit, the rules refuse our slot create and
  ///   Firestore reports only "permission-denied". The same code would also
  ///   cover a rule failure for another reason (e.g. the court price changed
  ///   a moment ago). We accept that ambiguity: the pre-checks catch the
  ///   common causes, and "pick another time" is a safe next step either way.
  Future<void> _createWithSlots(
    Future<SlotWriteResult> Function() write,
  ) async {
    final SlotWriteResult result;
    try {
      result = await write();
    } on FirebaseException catch (e, st) {
      final code = e.code.toLowerCase().replaceAll('_', '-');
      if (code == 'permission-denied') {
        throw BookingConflictException(cause: e, stackTrace: st);
      }
      rethrow;
    }
    if (result == SlotWriteResult.slotTaken) {
      throw const BookingConflictException();
    }
  }
}
