import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../data_agents/auth_data_agent_impl.dart';
import '../data_agents/blacklist_data_agent_impl.dart';
import '../data_agents/booking_data_agent_impl.dart';
import '../data_agents/user_data_agent_impl.dart';
import '../vos/booking_draft.dart';
import '../vos/booking_vo.dart';
import '../vos/court_vo.dart';
import '../vos/stadium_vo.dart';
import 'booking_repository_impl.dart';

/// Bookings and blocked slots. Every method throws / emits only
/// `AppException`.
///
/// Spark plan: writes go straight to Firestore and firestore.rules are the
/// only enforcement. Each booking / block is written in ONE transaction with
/// its slot lock docs; a slot that is already taken makes the whole write
/// fail, so double booking is impossible. The client pre-computes price and
/// times (core/utils) so honest requests pass; the rules re-check all of it.
abstract interface class BookingRepository {
  /// CUSTOMER scope: [uid] must be the signed-in user (rules deny others).
  /// Newest first, capped until Phase 10 adds pagination.
  Stream<List<BookingVO>> watchMyBookings(String uid);

  /// SHOP scope (or PLATFORM): bookings of [shopId] starting in
  /// `[from, to)`, earliest first. `InvalidDateException` when `to` is not
  /// after `from`.
  Stream<List<BookingVO>> watchShopBookings(
    String shopId, {
    required DateTime from,
    required DateTime to,
  });

  /// CUSTOMER scope: creates a pending, unpaid booking for the signed-in
  /// user and returns its id.
  ///
  /// Errors: `BookingConflictException` when a slot is taken (detected in
  /// the transaction, or surfacing as permission-denied when another booking
  /// commits first: the rules refuse the slot create and that code is
  /// ambiguous, see firestore_schema.md); `InvalidBookingTimeException`,
  /// `InvalidDateException`, `BookingTooLongException`,
  /// `CourtUnavailableException`, `StadiumUnavailableException`,
  /// `ShopUnavailableException`, `ProfileIncompleteException` from the
  /// client-side pre-checks.
  Future<String> createBooking(BookingDraft draft);

  /// CUSTOMER scope: cancels own pending/confirmed booking before it starts
  /// and frees its slots (same transaction).
  Future<void> cancelBooking(String bookingId, {String? reason});

  /// SHOP / PLATFORM scope: pending -> confirmed; pending|confirmed ->
  /// rejected (frees the slots; [reason] is shown to the customer);
  /// confirmed -> completed (only after it started).
  /// Anything else -> `InvalidBookingChangeException`.
  Future<void> setBookingStatus(
    String bookingId,
    BookingStatus status, {
    String? reason,
  });

  /// SHOP / PLATFORM scope: unpaid -> pending -> paid, paid -> refunded.
  Future<void> setPaymentStatus(String bookingId, PaymentStatus status);

  /// SHOP / PLATFORM scope: blocks up to 4 slots of [court] on [date] and
  /// returns the blocked-slot id. A booked slot in the range ->
  /// `BookingConflictException` (reject the booking first). Longer closures
  /// are several calls.
  Future<String> blockSlots({
    required StadiumVO stadium,
    required CourtVO court,
    required String date,
    required int startMinute,
    required int endMinute,
    required BlockedSlotReason reason,
    String? note,
  });

  /// SHOP / PLATFORM scope: deletes the block and frees its slots.
  Future<void> unblockSlots(String blockedSlotId);
}

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepositoryImpl(
    bookingDataAgent: ref.watch(bookingDataAgentProvider),
    authDataAgent: ref.watch(authDataAgentProvider),
    userDataAgent: ref.watch(userDataAgentProvider),
    blacklistDataAgent: ref.watch(blacklistDataAgentProvider),
  ),
);
