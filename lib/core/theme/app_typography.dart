import 'package:flutter/material.dart';

/// "Soft Swiss" type scale (design_system.md §3).
///
/// Manrope, bundled from `assets/fonts/` (static 400–800 weights). Swiss rules:
/// heavy, tightly-tracked headings; neutral, un-tracked body; small labels in
/// medium weight. Colors are applied by the theme, not here.
abstract final class AppTypography {
  static const String fontFamily = 'Manrope';

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, height: 60 / 56, letterSpacing: -2.0),
    displayMedium: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 48 / 44, letterSpacing: -1.5),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, height: 40 / 36, letterSpacing: -1.2),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 38 / 32, letterSpacing: -1.0),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 34 / 28, letterSpacing: -0.8),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 30 / 24, letterSpacing: -0.6),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 26 / 20, letterSpacing: -0.4),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 22 / 16, letterSpacing: -0.2),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 20 / 14, letterSpacing: -0.1),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 24 / 16, letterSpacing: 0),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14, letterSpacing: 0),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12, letterSpacing: 0.1),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 20 / 14, letterSpacing: 0),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 16 / 12, letterSpacing: 0.2),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 14 / 11, letterSpacing: 0.3),
  );

  /// Label size used on large (56dp) buttons.
  static const double largeButtonLabelSize = 15;

  /// Tabular figures for times, prices, KPIs and booking IDs.
  static TextStyle tabular(TextStyle style) =>
      style.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  /// Swiss "overline": small, uppercase, widely tracked. Uppercase the text
  /// itself (Flutter has no text-transform); keep the original for semantics.
  static TextStyle overline(TextStyle style) => style.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 14 / 11,
        letterSpacing: 1.4,
      );
}
