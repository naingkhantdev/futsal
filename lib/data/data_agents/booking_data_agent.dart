import '../requests/booking_write_requests.dart';
import '../responses/blocked_slot_response.dart';
import '../responses/booking_response.dart';

/// Result of an atomic "parent doc + slot lock docs" create.
enum SlotWriteResult {
  committed,

  /// A slot doc already existed (seen inside the transaction); nothing was
  /// written.
  slotTaken,
}

/// `bookings` + `blocked_slots` access as typed Responses / Requests.
///
/// Every write is validated by firestore.rules (the only enforcement on the
/// Spark plan). Throws raw Firebase errors; repositories map them.
abstract interface class BookingDataAgent {
  /// CUSTOMER scope, newest first.
  Stream<List<BookingResponse>> watchCustomerBookings(String customerId);

  /// SHOP scope: bookings starting in `[from, to)`, earliest first.
  Stream<List<BookingResponse>> watchShopBookings(
    String shopId, {
    required DateTime from,
    required DateTime to,
  });

  /// `null` when the doc does not exist.
  Future<BookingResponse?> getBooking(String bookingId);

  /// Client-generated id for a new booking (no network call).
  String newBookingId();

  /// Creates the booking and its slot docs in one transaction.
  Future<SlotWriteResult> createBooking(BookingCreateRequest request);

  /// Status / payment change, deleting [BookingUpdateRequest.slotPathsToDelete]
  /// in the same transaction.
  Future<void> updateBooking(BookingUpdateRequest request);

  /// `null` when the doc does not exist.
  Future<BlockedSlotResponse?> getBlockedSlot(String blockedSlotId);

  String newBlockedSlotId();

  /// Creates the block and its slot docs in one transaction.
  Future<SlotWriteResult> createBlockedSlot(BlockedSlotCreateRequest request);

  /// Deletes the block and its slot docs in one transaction.
  Future<void> deleteBlockedSlot({
    required String blockedSlotId,
    required List<String> slotPaths,
  });
}
