import '../constants/booking_policy.dart';

/// Integer money helpers. Amounts are whole kyat (MMK) — never doubles.
///
/// MIRRORED in firestore.rules (`newBookingPriceOk`), which rejects any
/// booking whose `totalPrice` differs from this formula. The client computes
/// the price it writes with [totalPrice]; the rules are authoritative.
abstract final class Money {
  /// `hourlyPrice * minutes / 60` in integer arithmetic.
  ///
  /// Rejects (returns `null`) rather than rounding a duration: [minutes] must
  /// be a positive multiple of [slotMinutes], [slotMinutes] positive and
  /// [hourlyPrice] non-negative.
  ///
  /// Rounding: when `hourlyPrice * minutes` is not divisible by 60 (e.g. a
  /// 45-minute slot) the result is rounded half up to the nearest whole kyat:
  /// `(hourlyPrice * minutes + 30) ~/ 60`.
  static int? totalPrice({
    required int hourlyPrice,
    required int minutes,
    required int slotMinutes,
  }) {
    if (hourlyPrice < 0 || minutes <= 0 || slotMinutes <= 0) return null;
    if (minutes % slotMinutes != 0) return null;
    return (hourlyPrice * minutes + 30) ~/ 60;
  }

  /// `MMK 30,000` (comma thousands separators, no decimals).
  static String formatMmk(int amount) {
    final digits = amount.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    final sign = amount < 0 ? '-' : '';
    return '$sign${BookingPolicy.currency} $buffer';
  }
}
