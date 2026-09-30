import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/l10n/locale_controller.dart';

/// Remembers on this device which page tours (coach marks) were seen.
/// Device-local on purpose: a tip is UX only, nothing to sync or secure.
class AppTourStore {
  AppTourStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _prefix = 'tour_seen_';

  bool isSeen(String tourId) {
    try {
      return _prefs.getBool('$_prefix$tourId') ?? false;
    } catch (_) {
      return true; // Unreadable storage: don't nag on every visit.
    }
  }

  Future<void> markSeen(String tourId) async {
    try {
      await _prefs.setBool('$_prefix$tourId', true);
    } catch (_) {
      // Worst case the tour shows once more.
    }
  }

  /// Every page shows its tour again on the next visit.
  Future<void> resetAll() async {
    try {
      for (final key in _prefs.getKeys().where((k) => k.startsWith(_prefix))) {
        await _prefs.remove(key);
      }
    } catch (_) {
      // Nothing to reset.
    }
  }
}

final appTourStoreProvider = Provider<AppTourStore>(
  (ref) => AppTourStore(ref.watch(sharedPreferencesProvider)),
);

/// Id of a tour to start now, set by "App tour" in Profile / Settings before
/// it navigates to that page; the page's launcher starts it and clears this.
final appTourRequestProvider = StateProvider<String?>((ref) => null);
