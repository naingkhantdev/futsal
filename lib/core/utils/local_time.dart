import '../constants/booking_policy.dart';
import 'date_key.dart';

/// Stadium-local (Asia/Yangon, UTC+06:30, no DST) <-> UTC conversions.
///
/// MIRRORED in firestore.rules (`localInstant`): a booking's `startAt` must
/// equal `timestamp.date(y, m, d) + (startMinute - 390) minutes` exactly.
abstract final class LocalTime {
  /// The UTC instant of [minute] (from local midnight) on local date
  /// [dateKey], or `null` for a malformed / non-existent date.
  static DateTime? instantFor(String dateKey, int minute) {
    final day = DateKey.tryParse(dateKey); // UTC midnight of that date
    if (day == null) return null;
    return day.add(Duration(minutes: minute - BookingPolicy.utcOffsetMinutes));
  }

  /// Local calendar date key of the UTC instant [instant].
  static String dateKeyOf(DateTime instant) => DateKey.fromDate(
        instant
            .toUtc()
            .add(const Duration(minutes: BookingPolicy.utcOffsetMinutes)),
      );
}
