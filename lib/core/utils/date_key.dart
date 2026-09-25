/// `yyyy-MM-dd` date keys used for `bookings.bookingDate`,
/// `blocked_slots.date` and slot lock ids. Always a calendar date in the
/// stadium's local time zone.
///
/// MIRRORED in firestore.rules (`isDateKey` + `isRealDate`).
abstract final class DateKey {
  static final RegExp _pattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  /// Key for the calendar date of [date] (its year/month/day fields, as
  /// given — convert to the stadium's local date first).
  static String fromDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// The date as UTC midnight, or `null` if [key] is malformed or not a real
  /// calendar date (e.g. `2026-02-30`).
  static DateTime? tryParse(String? key) {
    if (key == null) return null;
    final match = _pattern.firstMatch(key);
    if (match == null) return null;
    final y = int.parse(match.group(1)!);
    final m = int.parse(match.group(2)!);
    final d = int.parse(match.group(3)!);
    final date = DateTime.utc(y, m, d);
    if (date.year != y || date.month != m || date.day != d) return null;
    return date;
  }

  static bool isValid(String? key) => tryParse(key) != null;
}
