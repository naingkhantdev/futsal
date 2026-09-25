import '../constants/booking_policy.dart';

/// Ids of slot lock docs (`stadiums/{sid}/courts/{cid}/slots/{slotId}`).
///
/// `slotId = '{yyyy-MM-dd}_{startMinute zero-padded to 4 digits}'`, e.g.
/// `2026-10-01_1080` for 18:00. MIRRORED in firestore.rules (`slotKey`,
/// `pad4`) — the rules rebuild these ids to find a booking's slots, so the
/// format must never change.
abstract final class SlotKey {
  static String of(String dateKey, int startMinute) {
    assert(
      startMinute >= 0 && startMinute < BookingPolicy.minutesPerDay,
      'startMinute out of range: $startMinute',
    );
    return '${dateKey}_${startMinute.toString().padLeft(4, '0')}';
  }

  /// Start minutes of the slots covering `[startMinute, endMinute)` on a
  /// grid of [slotMinutes]. Empty for an empty/invalid range.
  static List<int> startMinutes({
    required int startMinute,
    required int endMinute,
    required int slotMinutes,
  }) {
    if (slotMinutes <= 0 || endMinute <= startMinute) return const [];
    return [
      for (var m = startMinute; m < endMinute; m += slotMinutes) m,
    ];
  }

  /// Slot ids covering `[startMinute, endMinute)` on [dateKey].
  static List<String> idsFor({
    required String dateKey,
    required int startMinute,
    required int endMinute,
    required int slotMinutes,
  }) =>
      [
        for (final m in startMinutes(
          startMinute: startMinute,
          endMinute: endMinute,
          slotMinutes: slotMinutes,
        ))
          of(dateKey, m),
      ];
}
