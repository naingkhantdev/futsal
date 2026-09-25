import 'package:flutter/material.dart';

/// Type scale from design_system.md §3.
///
/// Font family `Inter` is bundled as an asset. Until the TTFs are added and the
/// `fonts:` block in pubspec.yaml is enabled, Flutter silently falls back to
/// the platform font (Roboto / SF). Colors are applied by the theme, not here.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w700, height: 64 / 57, letterSpacing: -0.5),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, height: 52 / 45, letterSpacing: -0.25),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, height: 44 / 36, letterSpacing: 0),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 40 / 32, letterSpacing: -0.25),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 36 / 28, letterSpacing: -0.25),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 32 / 24, letterSpacing: 0),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 28 / 22, letterSpacing: 0),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16, letterSpacing: 0.1),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14, letterSpacing: 0.1),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 24 / 16, letterSpacing: 0.15),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, letterSpacing: 0.25),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 16 / 12, letterSpacing: 0.4),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14, letterSpacing: 0.1),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 16 / 12, letterSpacing: 0.5),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 16 / 11, letterSpacing: 0.5),
  );

  /// Label size used on large (56dp) buttons.
  static const double largeButtonLabelSize = 15;

  /// Tabular figures for times, prices, KPIs and booking IDs.
  static TextStyle tabular(TextStyle style) =>
      style.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
