import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Loaded once in `main()` and injected with `overrideWithValue`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('Override sharedPreferencesProvider in main'),
);

/// The app language, remembered on this device. Myanmar by default (the
/// app's market); the user can switch to English from Profile / Settings or
/// the auth screens.
class LocaleController extends Notifier<Locale> {
  static const String _prefsKey = 'app_locale';

  static const Locale myanmar = Locale('my');
  static const Locale english = Locale('en');
  static const List<Locale> choices = [myanmar, english];

  @override
  Locale build() {
    final code = ref.watch(sharedPreferencesProvider).getString(_prefsKey);
    return choices.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => myanmar,
    );
  }

  Future<void> select(Locale locale) async {
    if (locale == state) return;
    state = locale;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_prefsKey, locale.languageCode);
  }
}

final localeProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);
