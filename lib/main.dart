import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/l10n/l10n.dart';
import 'core/l10n/locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Dates in Myanmar keep Western digits, matching prices and times.
  DateFormat.useNativeDigitsByDefaultFor('my', false);
  final prefs = await SharedPreferences.getInstance();
  await FirebaseBootstrap.initialize();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const FutsalBookingApp(),
    ),
  );
}

class FutsalBookingApp extends ConsumerWidget {
  const FutsalBookingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final myanmar = locale.languageCode == LocaleController.myanmar.languageCode;
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light(myanmar: myanmar),
      darkTheme: AppTheme.dark(myanmar: myanmar),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) {
        // DateFormat (DisplayFormat) follows the app language.
        Intl.defaultLocale = Localizations.localeOf(context).toLanguageTag();
        return child!;
      },
    );
  }
}
