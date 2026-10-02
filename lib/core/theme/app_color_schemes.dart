import 'package:flutter/material.dart';

/// "Sand + Terracotta" color schemes (user's call, 2026-10-02; replaces navy
/// + gold for the app screens — the splash keeps the logo colors, see
/// `AppBrand`).
///
/// Light: clay-red `primary` for buttons, selection and key actions; a
/// cinnamon `secondary` for small accents (rings, icons, highlights); a warm
/// sand page with white cards. Dark: lighter clay on a warm espresso page.
/// No green anywhere. Every solid role passes WCAG AA (4.5:1) against its
/// `on*` color.
///
/// Built with the explicit [ColorScheme] constructor (not `fromSeed`) so every
/// value is exact. Unlisted optional roles fall back to Flutter defaults.
abstract final class AppColorSchemes {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFC2532F),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFBE6DD),
    onPrimaryContainer: Color(0xFF4A1A0A),
    secondary: Color(0xFF8A5A3C),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF3E7DC),
    onSecondaryContainer: Color(0xFF3A2416),
    tertiary: Color(0xFF5E5650),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFEFEBE6),
    onTertiaryContainer: Color(0xFF2A2420),
    error: Color(0xFFA8201A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9E1DE),
    onErrorContainer: Color(0xFF5A0E07),
    surface: Color(0xFFFAF7F2),
    onSurface: Color(0xFF1F1A16),
    surfaceDim: Color(0xFFE8E1D6),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFCFAF6),
    surfaceContainer: Color(0xFFF4EFE7),
    surfaceContainerHigh: Color(0xFFEFE9DF),
    surfaceContainerHighest: Color(0xFFE8E1D6),
    onSurfaceVariant: Color(0xFF6B625A),
    outline: Color(0xFF968C82),
    outlineVariant: Color(0xFFEAE3D8),
    inverseSurface: Color(0xFF2A231E),
    onInverseSurface: Color(0xFFF5EFE8),
    inversePrimary: Color(0xFFE9805C),
    surfaceTint: Colors.transparent,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFE9805C),
    onPrimary: Color(0xFF2A1208),
    primaryContainer: Color(0xFF4A2416),
    onPrimaryContainer: Color(0xFFFBE6DD),
    secondary: Color(0xFFD9A98A),
    onSecondary: Color(0xFF2E1A0E),
    secondaryContainer: Color(0xFF3E2C20),
    onSecondaryContainer: Color(0xFFF3E7DC),
    tertiary: Color(0xFFB8AEA5),
    onTertiary: Color(0xFF241E1A),
    tertiaryContainer: Color(0xFF3A332D),
    onTertiaryContainer: Color(0xFFEFEBE6),
    error: Color(0xFFFFB4A9),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF5C1A14),
    onErrorContainer: Color(0xFFFFDAD4),
    surface: Color(0xFF15110E),
    onSurface: Color(0xFFF5EFE8),
    surfaceDim: Color(0xFF0F0C0A),
    surfaceBright: Color(0xFF3A322B),
    surfaceContainerLowest: Color(0xFF211B17),
    surfaceContainerLow: Color(0xFF1A1512),
    surfaceContainer: Color(0xFF241E19),
    surfaceContainerHigh: Color(0xFF2B241F),
    surfaceContainerHighest: Color(0xFF352D27),
    onSurfaceVariant: Color(0xFFB5AAA0),
    outline: Color(0xFF7D7268),
    outlineVariant: Color(0xFF3A312A),
    inverseSurface: Color(0xFFF5EFE8),
    onInverseSurface: Color(0xFF15110E),
    inversePrimary: Color(0xFFC2532F),
    surfaceTint: Colors.transparent,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );
}
