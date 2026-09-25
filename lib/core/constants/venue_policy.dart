import 'domain_enums.dart';

/// Shop / stadium / court write rules shared by every layer.
///
/// ENFORCED by `firestore.rules` (`validShopShape`, `validStadiumShape`,
/// `validCourtShape`). The rules are authoritative; the client validates
/// with the same values so a save is not refused after the round trip.
/// Change both together.
abstract final class VenuePolicy {
  /// Court slot lengths a shop admin may choose.
  ///
  /// BOOKING INTEGRITY: slot lock doc ids are `{date}_{startMinute}` on a
  /// grid counted from the stadium's `openMinute`. Every allowed length
  /// divides 60 and stadiums open on the hour ([openingHourStep]), so the
  /// grid is the same whatever the opening hours are: editing hours never
  /// moves it. A court's `slotMinutes` can't change after creation (rules),
  /// because a 30 → 60 change would let a 60-minute booking at 09:00 skip
  /// the lock doc of an existing 09:30 booking.
  static const List<int> allowedSlotMinutes = [30, 60];

  /// `openMinute` must be a multiple of this (see [allowedSlotMinutes]).
  static const int openingHourStep = 60;

  static const int descriptionMaxLength = 1000;
  static const int addressMaxLength = 200;

  /// City / township.
  static const int placeMaxLength = 80;
  static const int surfaceMaxLength = 40;
  static const int emailMaxLength = 254;
  static const int maxImages = 10;
  static const int maxCapacity = 100;

  /// Int MMK per hour.
  static const int maxHourlyPrice = 10000000;

  /// The `stadiums.isPublished` invariant (Spark: client-maintained):
  /// visible in discovery only while the shop is active and listed and the
  /// stadium itself is active. MIRRORED in firestore.rules
  /// (`stadiumPublished`).
  static bool isPublished({
    required ShopStatus shopStatus,
    required bool shopIsListed,
    required bool stadiumIsActive,
  }) =>
      shopStatus == ShopStatus.active && shopIsListed && stadiumIsActive;

  /// `stadiums.minHourlyPrice`: lowest price among active, priced courts,
  /// or `null` when there is none. Display only.
  static int? minHourlyPrice(
    Iterable<({bool isActive, int? hourlyPrice})> courts,
  ) {
    int? min;
    for (final court in courts) {
      final price = court.hourlyPrice;
      if (!court.isActive || price == null) continue;
      if (min == null || price < min) min = price;
    }
    return min;
  }
}
