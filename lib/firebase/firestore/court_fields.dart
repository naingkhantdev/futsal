/// Field names of `stadiums/{stadiumId}/courts/{courtId}` (master notes §8).
abstract final class CourtFields {
  static const String shopId = 'shopId';
  static const String stadiumId = 'stadiumId';
  static const String name = 'name';
  static const String description = 'description';
  static const String surfaceType = 'surfaceType';
  static const String capacity = 'capacity';

  /// Integer MMK per hour. Never a double.
  static const String hourlyPrice = 'hourlyPrice';
  static const String currency = 'currency';

  /// Bookable slot length in minutes (default 60).
  static const String slotMinutes = 'slotMinutes';
  static const String images = 'images';
  static const String isActive = 'isActive';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}
