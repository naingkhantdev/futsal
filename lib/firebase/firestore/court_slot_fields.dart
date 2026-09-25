/// Field names of `stadiums/{stadiumId}/courts/{courtId}/slots/{slotId}`:
/// one slot lock doc per occupied slot (booking or blocked time).
///
/// `slotId = SlotKey.of(date, startMinute)`. firestore.rules allow creating a
/// slot doc only if it does not exist yet, never allow updating it, and
/// require it to be written in the same request as the booking / blocked
/// slot it references — this is what makes double booking impossible.
/// No customer data: any signed-in user may read slots (availability).
abstract final class CourtSlotFields {
  static const String shopId = 'shopId';
  static const String stadiumId = 'stadiumId';
  static const String courtId = 'courtId';

  /// `yyyy-MM-dd`, stadium local.
  static const String date = 'date';
  static const String startMinute = 'startMinute';

  /// `startMinute + court.slotMinutes`.
  static const String endMinute = 'endMinute';

  /// `BusyKind` wire value: `booked` | `blocked`.
  static const String kind = 'kind';

  /// Booking id (kind booked) or blocked-slot id (kind blocked).
  static const String refId = 'refId';

  /// Uid of the writer (customer or admin).
  static const String createdBy = 'createdBy';
  static const String createdAt = 'createdAt';
}
