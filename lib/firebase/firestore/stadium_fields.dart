/// Field names of `stadiums/{stadiumId}` (master notes §7 + shopId).
abstract final class StadiumFields {
  static const String shopId = 'shopId';
  static const String name = 'name';
  static const String description = 'description';
  static const String address = 'address';
  static const String township = 'township';
  static const String city = 'city';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String images = 'images';

  /// List of `Facility` wire values.
  static const String facilities = 'facilities';

  /// Opening hours as minutes from local midnight
  /// (`0 <= open < close <= 1440`).
  static const String openMinute = 'openMinute';
  static const String closeMinute = 'closeMinute';

  /// IANA zone, default `Asia/Yangon`.
  static const String timeZone = 'timeZone';
  static const String isActive = 'isActive';

  /// CLIENT-MAINTAINED invariant (no triggers on Spark):
  /// `shop.status == active && shop.isListed && stadium.isActive`.
  /// Kept in sync by the stadium write paths (Phase 4) and the superadmin
  /// shop-status change (batch-updates the shop's stadiums). Discovery only:
  /// the booking rule re-checks shop + stadium itself. Customer queries must
  /// filter on it (firestore.rules).
  static const String isPublished = 'isPublished';

  /// CLIENT-MAINTAINED by the shop admin when saving courts (Phase 5):
  /// lowest `hourlyPrice` of the stadium's active courts (int MMK), or null.
  /// Display only — bookings are priced from the court doc.
  static const String minHourlyPrice = 'minHourlyPrice';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}
