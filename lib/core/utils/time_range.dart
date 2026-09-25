import 'package:flutter/foundation.dart';

import '../constants/booking_policy.dart';

/// Half-open time interval `[startMinute, endMinute)` in minutes from local
/// midnight (stadium time zone).
///
/// Ranges never cross midnight: a valid range satisfies
/// `0 <= startMinute < endMinute <= 1440`. Overnight bookings are not
/// supported yet.
///
/// MIRRORED in firestore.rules (`validWindow`), which re-validates every
/// booking; the client uses these to build requests the rules accept.
@immutable
class TimeRange {
  const TimeRange(this.startMinute, this.endMinute);

  final int startMinute;
  final int endMinute;

  int get durationMinutes => endMinute - startMinute;

  /// Non-empty and inside a single day.
  bool get isValid =>
      startMinute >= 0 &&
      endMinute > startMinute &&
      endMinute <= BookingPolicy.minutesPerDay;

  /// The platform overlap rule: `aStart < bEnd && aEnd > bStart`.
  /// Adjacent ranges (one ends exactly when the other starts) do not overlap.
  bool overlaps(TimeRange other) =>
      startMinute < other.endMinute && endMinute > other.startMinute;

  bool contains(TimeRange other) =>
      other.startMinute >= startMinute && other.endMinute <= endMinute;

  @override
  bool operator ==(Object other) =>
      other is TimeRange &&
      other.startMinute == startMinute &&
      other.endMinute == endMinute;

  @override
  int get hashCode => Object.hash(startMinute, endMinute);

  @override
  String toString() => 'TimeRange(${formatMinuteOfDay(startMinute)}-'
      '${formatMinuteOfDay(endMinute)})';
}

/// Slot generation and booking-window checks. Pure; mirrored in the rules.
abstract final class SlotRules {
  /// Opening hours are valid when `0 <= open < close <= 1440`.
  static bool isValidOpeningHours(int openMinute, int closeMinute) =>
      openMinute >= 0 &&
      closeMinute > openMinute &&
      closeMinute <= BookingPolicy.minutesPerDay;

  /// Consecutive slots of [slotMinutes] starting at [openMinute]. A trailing
  /// partial slot that would end after [closeMinute] is dropped. Returns an
  /// empty list for invalid hours or a non-positive slot length.
  static List<TimeRange> generateSlots({
    required int openMinute,
    required int closeMinute,
    required int slotMinutes,
  }) {
    if (slotMinutes <= 0 || !isValidOpeningHours(openMinute, closeMinute)) {
      return const [];
    }
    final slots = <TimeRange>[];
    for (var start = openMinute;
        start + slotMinutes <= closeMinute;
        start += slotMinutes) {
      slots.add(TimeRange(start, start + slotMinutes));
    }
    return slots;
  }

  /// Whether [range] is a bookable window: valid, inside opening hours,
  /// starting on a slot boundary (counted from [openMinute]) and lasting a
  /// whole number of slots.
  static bool isBookableWindow(
    TimeRange range, {
    required int openMinute,
    required int closeMinute,
    required int slotMinutes,
  }) {
    return slotMinutes > 0 &&
        range.isValid &&
        isValidOpeningHours(openMinute, closeMinute) &&
        range.startMinute >= openMinute &&
        range.endMinute <= closeMinute &&
        (range.startMinute - openMinute) % slotMinutes == 0 &&
        range.durationMinutes % slotMinutes == 0;
  }
}

/// `HH:mm` for a minute of the day; 1440 renders as `24:00`.
String formatMinuteOfDay(int minute) {
  final h = (minute ~/ 60).toString().padLeft(2, '0');
  final m = (minute % 60).toString().padLeft(2, '0');
  return '$h:$m';
}
