/// Firestore collection names — the single place paths are built from.
/// Mirrored in firestore.rules (match paths).
abstract final class FirestoreCollections {
  static const String users = 'users';
  static const String shops = 'shops';

  /// Subcollection of `shops/{shopId}` holding admin-only fields.
  static const String shopPrivate = 'private';

  /// Subcollection of `shops/{shopId}`: customers blocked from booking at
  /// that shop, doc id = customer uid.
  static const String blacklist = 'blacklist';
  static const String stadiums = 'stadiums';

  /// Subcollection of `stadiums/{stadiumId}`.
  static const String courts = 'courts';

  /// Subcollection of `stadiums/{stadiumId}/courts/{courtId}`: slot lock
  /// docs, id = `SlotKey.of(date, startMinute)` (e.g. `2026-10-01_1080`).
  static const String slots = 'slots';
  static const String bookings = 'bookings';
  static const String blockedSlots = 'blocked_slots';

  /// In-app notifications, id = `{bookingId}_{type}` (one per event).
  static const String notifications = 'notifications';

  /// PLATFORM announcements, written by the superadmin.
  static const String announcements = 'announcements';
}

/// Document / collection paths. Build every path through here.
abstract final class FirestorePaths {
  /// Id of the single doc in `shops/{shopId}/private`.
  static const String shopPrivateDocId = 'details';

  static String shop(String shopId) => '${FirestoreCollections.shops}/$shopId';

  static String shopPrivateDetails(String shopId) =>
      '${shop(shopId)}/${FirestoreCollections.shopPrivate}/$shopPrivateDocId';

  static String shopBlacklist(String shopId) =>
      '${shop(shopId)}/${FirestoreCollections.blacklist}';

  static String shopBlacklistEntry(String shopId, String customerId) =>
      '${shopBlacklist(shopId)}/$customerId';

  static String stadium(String stadiumId) =>
      '${FirestoreCollections.stadiums}/$stadiumId';

  static String courts(String stadiumId) =>
      '${stadium(stadiumId)}/${FirestoreCollections.courts}';

  static String court(String stadiumId, String courtId) =>
      '${courts(stadiumId)}/$courtId';

  static String courtSlots(String stadiumId, String courtId) =>
      '${court(stadiumId, courtId)}/${FirestoreCollections.slots}';

  static String courtSlot(String stadiumId, String courtId, String slotId) =>
      '${courtSlots(stadiumId, courtId)}/$slotId';

  static String booking(String bookingId) =>
      '${FirestoreCollections.bookings}/$bookingId';

  static String blockedSlot(String blockedSlotId) =>
      '${FirestoreCollections.blockedSlots}/$blockedSlotId';

  static String notification(String notificationId) =>
      '${FirestoreCollections.notifications}/$notificationId';

  /// Deterministic id: the rules allow one notification per booking event.
  static String notificationId(String bookingId, String type) =>
      '${bookingId}_$type';
}
