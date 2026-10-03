import 'domain_enums.dart';

/// Venue cancellation / refund policy. Set per stadium by its shop admin
/// (`stadiums.freeCancelHours` + `cancellationNote`) and copied onto every
/// new booking (`bookings.freeCancelHours`), so a later policy change never
/// rewrites what a customer agreed to. MIRRORED in firestore.rules
/// (`validStadiumShape`, `newBookingVenueOk`); change both together.
///
/// Payment happens outside the app, so the policy only decides whether a
/// paid booking is owed a refund. Customers may still cancel late (the
/// court is freed for others); staff record the refund (`paid -> refunded`).
abstract final class CancellationPolicy {
  /// Allowed `freeCancelHours` values. `0` = free cancellation until the
  /// booking starts. A stadium without the field has no stated policy.
  static const List<int> freeCancelHourOptions = [0, 2, 6, 12, 24, 48];

  static const int noteMaxLength = 300;

  static bool isValidFreeCancelHours(int? hours) =>
      hours == null || freeCancelHourOptions.contains(hours);

  /// Last moment a customer can cancel for a full refund.
  static DateTime freeCancelDeadline(DateTime startAt, int freeCancelHours) =>
      startAt.subtract(Duration(hours: freeCancelHours));

  /// Refund state of a booking, derived from its status, payment and the
  /// policy snapshot. [cancelledAt] is when the customer cancelled.
  static RefundState refundStateOf({
    required BookingStatus status,
    required PaymentStatus paymentStatus,
    required DateTime? startAt,
    required DateTime? cancelledAt,
    required int? freeCancelHours,
  }) {
    if (paymentStatus == PaymentStatus.refunded) return RefundState.refunded;
    final ended = status == BookingStatus.cancelled ||
        status == BookingStatus.rejected;
    if (!ended) return RefundState.none;
    if (paymentStatus != PaymentStatus.paid) return RefundState.nothingPaid;
    // The venue turned it down: always owed.
    if (status == BookingStatus.rejected) return RefundState.due;
    if (freeCancelHours == null || startAt == null || cancelledAt == null) {
      return RefundState.askVenue;
    }
    return cancelledAt.isAfter(freeCancelDeadline(startAt, freeCancelHours))
        ? RefundState.notEligible
        : RefundState.due;
  }
}

/// Where a booking stands on refunds (UI only, never persisted).
enum RefundState {
  /// Still active / completed: refunds don't apply.
  none,

  /// Cancelled or rejected before anything was paid.
  nothingPaid,

  /// Paid and owed a refund the venue hasn't recorded yet.
  due,

  /// Paid, cancelled after the free-cancellation deadline.
  notEligible,

  /// Paid, cancelled, and the venue has no stated policy.
  askVenue,

  /// The venue recorded the refund.
  refunded,
}
