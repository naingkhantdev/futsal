import 'package:intl/intl.dart';

import '../l10n/l10n.dart';
import 'date_key.dart';
import 'time_range.dart';

/// Human-readable dates and times for lists and detail screens.
///
/// Date names follow `Intl.defaultLocale` (set from the app language in
/// `main.dart`), so formats are created per call. Pass [AppLocalizations]
/// to get "Today", "2 hours", "5 min ago" in the app language.
///
/// English keeps fixed day-first patterns ("Tue, 29 Sep"); Myanmar uses the
/// CLDR skeletons so order and separators are native
/// ("စက် 29၊ အင်္ဂါ", "2026၊ စက်တင်ဘာ 29၊ အင်္ဂါ").
abstract final class DisplayFormat {
  static bool get _myanmar => Intl.getCurrentLocale().startsWith('my');

  static DateFormat get _weekdayDate =>
      _myanmar ? DateFormat.MMMEd() : DateFormat('EEE, d MMM');
  static DateFormat get _fullDate =>
      _myanmar ? DateFormat.yMMMMEEEEd() : DateFormat('EEEE, d MMMM y');
  static DateFormat get _shortDate =>
      _myanmar ? DateFormat.yMMMd() : DateFormat('d MMM y');
  static DateFormat get _weekdayShort => DateFormat('EEE');
  static DateFormat get _monthShort => DateFormat('MMM');

  static DateTime? _date(String dateKey) => DateKey.tryParse(dateKey);

  /// "Today", "Tomorrow", "Yesterday" or "Mon, 29 Sep" / "စက် 29၊ တနင်္လာ".
  static String dayLabel(String dateKey, [AppLocalizations? l]) {
    final date = _date(dateKey);
    if (date == null) return dateKey;
    final today = DateKey.tryParse(DateKey.fromDate(DateTime.now()))!;
    final diff = date.difference(today).inDays;
    return switch (diff) {
      0 => l?.dayToday ?? 'Today',
      1 => l?.dayTomorrow ?? 'Tomorrow',
      -1 => l?.dayYesterday ?? 'Yesterday',
      _ => _weekdayDate.format(date),
    };
  }

  /// "Monday, 29 September 2026" / "2026၊ စက်တင်ဘာ 29၊ တနင်္လာ".
  static String fullDate(String dateKey) {
    final date = _date(dateKey);
    return date == null ? dateKey : _fullDate.format(date);
  }

  /// "Mon".
  static String weekday(String dateKey) {
    final date = _date(dateKey);
    return date == null ? '' : _weekdayShort.format(date);
  }

  /// "29".
  static String dayOfMonth(String dateKey) {
    final date = _date(dateKey);
    return date == null ? '' : '${date.day}';
  }

  /// "Sep".
  static String month(String dateKey) {
    final date = _date(dateKey);
    return date == null ? '' : _monthShort.format(date);
  }

  /// "18:00 – 20:00".
  static String timeRange(int startMinute, int endMinute) =>
      '${formatMinuteOfDay(startMinute)} – ${formatMinuteOfDay(endMinute)}';

  /// "2 hours", "1 hour", "30 min", "1.5 hours".
  static String duration(int minutes, [AppLocalizations? l]) {
    if (minutes < 60) return l?.durationMinutes(minutes) ?? '$minutes min';
    final hours = minutes / 60;
    if (hours == 1) return l?.durationOneHour ?? '1 hour';
    final text =
        hours == hours.roundToDouble() ? '${hours.round()}' : '$hours';
    return l?.durationHours(text) ?? '$text hours';
  }

  /// "Just now", "5 min ago", "3 h ago", "2 d ago", then "29 Sep".
  static String timeAgo(DateTime at, [AppLocalizations? l]) {
    final diff = DateTime.now().difference(at);
    if (diff.inMinutes < 1) return l?.agoJustNow ?? 'Just now';
    if (diff.inMinutes < 60) {
      return l?.agoMinutes(diff.inMinutes) ?? '${diff.inMinutes} min ago';
    }
    if (diff.inHours < 24) {
      return l?.agoHours(diff.inHours) ?? '${diff.inHours} h ago';
    }
    if (diff.inDays < 7) return l?.agoDays(diff.inDays) ?? '${diff.inDays} d ago';
    return DateFormat('d MMM').format(at);
  }

  /// "29 Sep 2026" / "2026၊ စက် 29".
  static String shortDate(DateTime at) => _shortDate.format(at);

  /// Kilometres for a distance label: one decimal under 10 km ("2.4"),
  /// whole numbers above ("15").
  static String km(double km) =>
      km < 10 ? km.toStringAsFixed(1) : km.round().toString();

  /// Initials for avatars: "Aung Kyaw" → "AK".
  static String initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }
}
