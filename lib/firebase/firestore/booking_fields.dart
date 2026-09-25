/// Field names of `bookings/{bookingId}` (master notes §9 + shopId).
///
/// Written by clients, validated field-by-field by firestore.rules:
/// customers create (with one slot lock doc per slot, same request) and
/// cancel; shop staff confirm / reject / complete and change payment.
abstract final class BookingFields {
  static const String shopId = 'shopId';
  static const String customerId = 'customerId';
  static const String stadiumId = 'stadiumId';
  static const String courtId = 'courtId';

  /// `yyyy-MM-dd` in the stadium's local time zone.
  static const String bookingDate = 'bookingDate';

  /// Minutes from local midnight; `startMinute < endMinute <= 1440`.
  /// Bookings never cross midnight (not supported yet).
  static const String startMinute = 'startMinute';
  static const String endMinute = 'endMinute';

  /// The court's `slotMinutes` at booking time. The rules use it to rebuild
  /// the booking's slot ids when it is cancelled / rejected.
  static const String slotMinutes = 'slotMinutes';

  /// UTC instants of the same range, for range queries and ordering.
  static const String startAt = 'startAt';
  static const String endAt = 'endAt';

  /// Integer MMK.
  static const String pricePerHour = 'pricePerHour';
  static const String totalPrice = 'totalPrice';
  static const String currency = 'currency';
  static const String status = 'status';
  static const String paymentStatus = 'paymentStatus';
  static const String customerNameSnapshot = 'customerNameSnapshot';
  static const String customerPhoneSnapshot = 'customerPhoneSnapshot';
  static const String stadiumNameSnapshot = 'stadiumNameSnapshot';
  static const String courtNameSnapshot = 'courtNameSnapshot';

  /// Set (to the server time) when the customer cancels.
  static const String cancelledAt = 'cancelledAt';

  /// Optional reason for a customer cancel or a staff reject (<= 500 chars).
  static const String cancelReason = 'cancelReason';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}
