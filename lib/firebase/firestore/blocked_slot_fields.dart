/// Field names of `blocked_slots/{blockedSlotId}` (master notes §15 + shopId).
/// Same date/minute representation as bookings. Written by the shop's admins
/// (or the superadmin) together with one `blocked` slot lock doc per slot,
/// at most `BookingPolicy.maxSlotsPerBooking` slots per doc. Immutable:
/// delete (with its slot docs) and re-create to change.
abstract final class BlockedSlotFields {
  static const String shopId = 'shopId';
  static const String stadiumId = 'stadiumId';
  static const String courtId = 'courtId';

  /// `yyyy-MM-dd` in the stadium's local time zone.
  static const String date = 'date';
  static const String startMinute = 'startMinute';
  static const String endMinute = 'endMinute';

  /// The court's `slotMinutes` when the block was created.
  static const String slotMinutes = 'slotMinutes';
  static const String startAt = 'startAt';
  static const String endAt = 'endAt';

  /// `BlockedSlotReason` wire value.
  static const String reason = 'reason';
  static const String note = 'note';
  static const String createdBy = 'createdBy';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}
