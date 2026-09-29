import 'package:flutter/material.dart';

/// "Premium" type scale (design_system.md §3).
///
/// Plus Jakarta Sans, bundled from `assets/fonts/` (static 400–800).
/// Headings are Bold with tight negative tracking; body is Regular with
/// airy line height (1.5+) and slight positive tracking for easy reading;
/// labels are SemiBold and gently tracked. Myanmar glyphs come from the
/// bundled [myanmarFallback] font, so both scripts look the same on every
/// phone. Colors are applied by the theme, not here.
abstract final class AppTypography {
  static const String fontFamily = 'PlusJakartaSans';

  /// Per-glyph fallback for Myanmar script (Noto Sans Myanmar, bundled).
  static const String myanmarFallback = 'NotoSansMyanmar';
  static const List<String> fontFamilyFallback = [myanmarFallback];

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 52, fontWeight: FontWeight.w700, height: 1.1, letterSpacing: -1.4),
    displayMedium: TextStyle(fontSize: 42, fontWeight: FontWeight.w700, height: 1.12, letterSpacing: -1.1),
    displaySmall: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, height: 1.16, letterSpacing: -0.9),
    headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.7),
    headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1.23, letterSpacing: -0.5),
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.27, letterSpacing: -0.35),
    titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, height: 1.32, letterSpacing: -0.2),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: -0.1),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.43, letterSpacing: 0),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.55, letterSpacing: 0.1),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0.1),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.45, letterSpacing: 0.2),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: 0.2),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.35, letterSpacing: 0.3),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.35, letterSpacing: 0.5),
  );

  /// Myanmar script needs room: stacked vowel signs and medials sit above
  /// and below the line, and the Latin scale's tight heights and negative
  /// tracking would clip or crowd them. Glyphs come from the bundled
  /// [myanmarFallback] (Noto Sans Myanmar), not the phone's system font.
  static TextTheme forMyanmar(TextTheme theme) {
    TextStyle? adjust(TextStyle? style, double height) => style?.copyWith(
          height: height,
          letterSpacing: 0,
        );
    return theme.copyWith(
      displayLarge: adjust(theme.displayLarge, 1.35),
      displayMedium: adjust(theme.displayMedium, 1.35),
      displaySmall: adjust(theme.displaySmall, 1.4),
      headlineLarge: adjust(theme.headlineLarge, 1.45),
      headlineMedium: adjust(theme.headlineMedium, 1.45),
      headlineSmall: adjust(theme.headlineSmall, 1.5),
      titleLarge: adjust(theme.titleLarge, 1.55),
      titleMedium: adjust(theme.titleMedium, 1.6),
      titleSmall: adjust(theme.titleSmall, 1.6),
      bodyLarge: adjust(theme.bodyLarge, 1.7),
      bodyMedium: adjust(theme.bodyMedium, 1.7),
      bodySmall: adjust(theme.bodySmall, 1.7),
      labelLarge: adjust(theme.labelLarge, 1.6),
      labelMedium: adjust(theme.labelMedium, 1.6),
      labelSmall: adjust(theme.labelSmall, 1.6),
    );
  }

  /// Label size used on large (56dp) buttons.
  static const double largeButtonLabelSize = 15;

  /// Tabular figures for times, prices, KPIs and booking IDs.
  static TextStyle tabular(TextStyle style) =>
      style.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  /// Overline: small, uppercase, widely tracked (KPI labels, wordmark). Uppercase the text
  /// itself (Flutter has no text-transform); keep the original for semantics.
  static TextStyle overline(TextStyle style) => style.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 1.6,
      );
}
