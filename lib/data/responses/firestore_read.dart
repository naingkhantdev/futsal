import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

/// Tolerant readers for server-written Firestore data.
///
/// A malformed or partially written doc must degrade safely, never throw:
/// wrong types become `null` (or an empty list), and callers pick a
/// fail-closed default.
abstract final class FirestoreRead {
  static String? string(Object? v) => v is String && v.isNotEmpty ? v : null;

  /// Whole numbers only. A whole-valued double (e.g. `60.0`) is accepted;
  /// a fractional one (e.g. a float price) is rejected as `null`.
  static int? integer(Object? v) => switch (v) {
        final int i => i,
        final double d when d.isFinite && d == d.roundToDouble() => d.toInt(),
        _ => null,
      };

  static double? decimal(Object? v) =>
      v is num && v.isFinite ? v.toDouble() : null;

  /// `true` only for a real boolean `true` (missing → `false`).
  static bool flag(Object? v) => v == true;

  static DateTime? date(Object? v) => switch (v) {
        final Timestamp t => t.toDate(),
        final DateTime d => d,
        _ => null,
      };

  /// Non-empty strings from a list; anything else is skipped.
  static List<String> strings(Object? v) => v is List
      ? v.whereType<String>().where((s) => s.isNotEmpty).toList()
      : const [];

  /// Map entries of a list; non-map entries are skipped.
  static List<Map<String, dynamic>> maps(Object? v) => v is List
      ? [
          for (final e in v)
            if (e is Map) e.map((k, val) => MapEntry(k.toString(), val)),
        ]
      : const [];
}
