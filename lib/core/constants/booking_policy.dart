import 'domain_enums.dart';

/// Booking business rules shared by every layer.
///
/// ENFORCED by `firestore.rules` (Spark plan: no Cloud Functions). The rules
/// are authoritative; the client uses these values to pre-compute a booking
/// that the rules will accept and to render availability. Change both
/// together.
abstract final class BookingPolicy {
  /// Booking statuses that occupy a court's time. Their slot lock docs exist
  /// while the booking is in one of these statuses; cancelling or rejecting a
  /// booking deletes them in the same request. `completed` bookings keep
  /// their (past) slots.
  static const Set<BookingStatus> blockingStatuses = {
    BookingStatus.pending,
    BookingStatus.confirmed,
  };

  static bool blocksAvailability(BookingStatus status) =>
      blockingStatuses.contains(status);

  /// Status changes shop staff (admin of the booking's shop, or superadmin)
  /// may make. MIRRORED in firestore.rules (`staffConfirms`, `staffRejects`,
  /// `staffCompletes`). Rejecting deletes the slots in the same request;
  /// completing is allowed only once the booking has started.
  static const Map<BookingStatus, Set<BookingStatus>> staffStatusChanges = {
    BookingStatus.confirmed: {BookingStatus.pending},
    BookingStatus.rejected: {BookingStatus.pending, BookingStatus.confirmed},
    BookingStatus.completed: {BookingStatus.confirmed},
  };

  static bool canStaffChangeStatus(BookingStatus from, BookingStatus to) =>
      staffStatusChanges[to]?.contains(from) ?? false;

  /// Customers may cancel a blocking booking before it starts
  /// (firestore.rules `customerCancels`).
  static bool canCustomerCancel(BookingStatus status) =>
      blockingStatuses.contains(status);

  /// Payment changes (staff only; customers can never change payment).
  /// MIRRORED in firestore.rules (`staffChangesPayment`).
  static const Map<PaymentStatus, PaymentStatus> _paymentSteps = {
    PaymentStatus.unpaid: PaymentStatus.pending,
    PaymentStatus.pending: PaymentStatus.paid,
    PaymentStatus.paid: PaymentStatus.refunded,
  };

  static bool canChangePayment(PaymentStatus from, PaymentStatus to) =>
      _paymentSteps[from] == to;

  /// Most slots one booking (or one blocked_slots doc) may cover.
  /// MIRRORED in firestore.rules as four unrolled slot checks
  /// (`allSlotsHeld` / `allSlotsFreed`). Raising it means adding checks
  /// there and re-counting the document-access budget.
  static const int maxSlotsPerBooking = 4;

  /// A booking must start in the future and less than this many days ahead
  /// (firestore.rules: `startAt < request.time + duration.value(30, 'd')`).
  static const int maxAdvanceDays = 30;

  /// Default court slot length when a court doc has none (or an invalid one).
  static const int defaultSlotMinutes = 60;

  /// The only supported stadium time zone. Booking dates and minutes are
  /// always stadium-local.
  static const String defaultTimeZone = 'Asia/Yangon';

  /// Asia/Yangon = UTC+06:30 with no DST. firestore.rules hard-codes the
  /// same 390 minutes when checking `startAt` / `endAt`.
  static const int utcOffsetMinutes = 6 * 60 + 30;

  /// All amounts are whole kyat stored as integers.
  static const String currency = 'MMK';

  static const int minutesPerDay = 24 * 60;
}
