import 'package:flutter/material.dart';

/// "Clean" color schemes (design_system.md §0).
///
/// Minimal and calm: brand navy `primary` for CTAs and selection, an
/// off-white page `surface`, white cards (`surfaceContainerLowest`, same as
/// [AppDepth.base]) separated by hairline `outlineVariant` borders instead of
/// shadows. `surfaceContainerHigh` is the flat input fill.
///
/// Built with the explicit [ColorScheme] constructor (not `fromSeed`) so every
/// value is exact. Unlisted optional roles fall back to Flutter defaults.
abstract final class AppColorSchemes {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0E1A33),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE7ECF5),
    onPrimaryContainer: Color(0xFF0E1A33),
    secondary: Color(0xFF5B6475),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE9EDF4),
    onSecondaryContainer: Color(0xFF0E1A33),
    tertiary: Color(0xFF5B6475),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE9EDF4),
    onTertiaryContainer: Color(0xFF0E1A33),
    error: Color(0xFFB42318),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFBE3E0),
    onErrorContainer: Color(0xFF5A0E07),
    surface: Color(0xFFF6F7F9),
    onSurface: Color(0xFF111827),
    surfaceDim: Color(0xFFE4E7EC),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF9FAFB),
    surfaceContainer: Color(0xFFF2F4F7),
    surfaceContainerHigh: Color(0xFFEFF1F5),
    surfaceContainerHighest: Color(0xFFE6E9EE),
    onSurfaceVariant: Color(0xFF5B6475),
    outline: Color(0xFF8A93A3),
    outlineVariant: Color(0xFFE5E8EE),
    inverseSurface: Color(0xFF111827),
    onInverseSurface: Color(0xFFF3F4F6),
    inversePrimary: Color(0xFFB9C6E0),
    surfaceTint: Colors.transparent,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFE6EBF5),
    onPrimary: Color(0xFF0B1020),
    primaryContainer: Color(0xFF1E2A44),
    onPrimaryContainer: Color(0xFFE6EBF5),
    secondary: Color(0xFFA3ACBD),
    onSecondary: Color(0xFF0B1020),
    secondaryContainer: Color(0xFF1E2638),
    onSecondaryContainer: Color(0xFFE6EBF5),
    tertiary: Color(0xFFA3ACBD),
    onTertiary: Color(0xFF0B1020),
    tertiaryContainer: Color(0xFF1E2638),
    onTertiaryContainer: Color(0xFFE6EBF5),
    error: Color(0xFFFFB4A9),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF5C1A14),
    onErrorContainer: Color(0xFFFFDAD4),
    surface: Color(0xFF0B1020),
    onSurface: Color(0xFFE8ECF3),
    surfaceDim: Color(0xFF080C18),
    surfaceBright: Color(0xFF222B3D),
    surfaceContainerLowest: Color(0xFF131A2A),
    surfaceContainerLow: Color(0xFF10162A),
    surfaceContainer: Color(0xFF161D2E),
    surfaceContainerHigh: Color(0xFF1A2234),
    surfaceContainerHighest: Color(0xFF232C40),
    onSurfaceVariant: Color(0xFFA3ACBD),
    outline: Color(0xFF6B7488),
    outlineVariant: Color(0xFF222B3D),
    inverseSurface: Color(0xFFE8ECF3),
    onInverseSurface: Color(0xFF0B1020),
    inversePrimary: Color(0xFF0E1A33),
    surfaceTint: Colors.transparent,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );
}
