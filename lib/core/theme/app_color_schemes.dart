import 'package:flutter/material.dart';

/// "Premium" color schemes (design_system.md §0): the logo's navy and gold.
///
/// Light: deep navy `primary` for buttons, selection and key text; gold
/// `secondary` as the only accent (rings, icons, highlights, never large
/// fills); a warm ivory page with white cards. Dark: gold becomes `primary`
/// on a deep navy page, like a floodlit pitch at night.
/// Every solid role passes WCAG AA (4.5:1) against its `on*` color.
///
/// Built with the explicit [ColorScheme] constructor (not `fromSeed`) so every
/// value is exact. Unlisted optional roles fall back to Flutter defaults.
abstract final class AppColorSchemes {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0F1B33),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE7EAF1),
    onPrimaryContainer: Color(0xFF0F1B33),
    secondary: Color(0xFF8C6A2A),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF6EEDC),
    onSecondaryContainer: Color(0xFF3D2C0A),
    tertiary: Color(0xFF4A5568),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFEDEFF3),
    onTertiaryContainer: Color(0xFF1F2633),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9E3E1),
    onErrorContainer: Color(0xFF5A0E07),
    surface: Color(0xFFF7F6F2),
    onSurface: Color(0xFF111827),
    surfaceDim: Color(0xFFE4E1D9),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFAF9F6),
    surfaceContainer: Color(0xFFF1EFEA),
    surfaceContainerHigh: Color(0xFFEDEAE3),
    surfaceContainerHighest: Color(0xFFE5E2DA),
    onSurfaceVariant: Color(0xFF5E6472),
    outline: Color(0xFF8C909A),
    outlineVariant: Color(0xFFE7E3DA),
    inverseSurface: Color(0xFF0F1B33),
    onInverseSurface: Color(0xFFF3F1EC),
    inversePrimary: Color(0xFFD9B46A),
    surfaceTint: Colors.transparent,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD9B46A),
    onPrimary: Color(0xFF221906),
    primaryContainer: Color(0xFF2E2717),
    onPrimaryContainer: Color(0xFFF6EEDC),
    secondary: Color(0xFFE6CB8C),
    onSecondary: Color(0xFF2A1E05),
    secondaryContainer: Color(0xFF3A2F17),
    onSecondaryContainer: Color(0xFFF6EEDC),
    tertiary: Color(0xFFA9B4C8),
    onTertiary: Color(0xFF16202F),
    tertiaryContainer: Color(0xFF243049),
    onTertiaryContainer: Color(0xFFDDE3EE),
    error: Color(0xFFFFB4A9),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF5C1A14),
    onErrorContainer: Color(0xFFFFDAD4),
    surface: Color(0xFF0A1020),
    onSurface: Color(0xFFEEF0F5),
    surfaceDim: Color(0xFF070B17),
    surfaceBright: Color(0xFF242E48),
    surfaceContainerLowest: Color(0xFF111A2E),
    surfaceContainerLow: Color(0xFF0E1628),
    surfaceContainer: Color(0xFF141D33),
    surfaceContainerHigh: Color(0xFF19233B),
    surfaceContainerHighest: Color(0xFF212C47),
    onSurfaceVariant: Color(0xFFA3ABBD),
    outline: Color(0xFF6B7488),
    outlineVariant: Color(0xFF222C44),
    inverseSurface: Color(0xFFEEF0F5),
    onInverseSurface: Color(0xFF0A1020),
    inversePrimary: Color(0xFF0F1B33),
    surfaceTint: Colors.transparent,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );
}
