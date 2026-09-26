import 'package:flutter/material.dart';

/// "Soft Swiss" color schemes (design_system.md §2.1–2.2).
///
/// Near-monochrome: ink `primary` for CTAs and selection on a cool mist
/// `surface` that doubles as the neumorphic base (raised elements share the
/// surface color and are lifted by [AppDepth] shadows, not by tone).
/// `surfaceContainerHigh` is the recessed "well" tone for inputs.
///
/// Built with the explicit [ColorScheme] constructor (not `fromSeed`) so every
/// value is exact. Unlisted optional roles fall back to Flutter defaults.
abstract final class AppColorSchemes {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF15181E),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDDE3EC),
    onPrimaryContainer: Color(0xFF15181E),
    secondary: Color(0xFF596271),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD6DCE5),
    onSecondaryContainer: Color(0xFF15181E),
    tertiary: Color(0xFF596271),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFD6DCE5),
    onTertiaryContainer: Color(0xFF15181E),
    error: Color(0xFFB42318),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFBE3E0),
    onErrorContainer: Color(0xFF5A0E07),
    surface: Color(0xFFE9EDF2),
    onSurface: Color(0xFF14171C),
    surfaceDim: Color(0xFFD5DBE3),
    surfaceBright: Color(0xFFF3F5F8),
    surfaceContainerLowest: Color(0xFFF3F5F8),
    surfaceContainerLow: Color(0xFFEEF1F5),
    surfaceContainer: Color(0xFFE6EAEF),
    surfaceContainerHigh: Color(0xFFDFE4EA),
    surfaceContainerHighest: Color(0xFFD8DEE6),
    onSurfaceVariant: Color(0xFF596271),
    outline: Color(0xFF7B8492),
    outlineVariant: Color(0xFFCFD6DF),
    inverseSurface: Color(0xFF15181E),
    onInverseSurface: Color(0xFFEEF1F5),
    inversePrimary: Color(0xFFC9D1DD),
    surfaceTint: Colors.transparent,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFEEF1F5),
    onPrimary: Color(0xFF15181E),
    primaryContainer: Color(0xFF2F353E),
    onPrimaryContainer: Color(0xFFE9ECF0),
    secondary: Color(0xFFA2AAB6),
    onSecondary: Color(0xFF15181E),
    secondaryContainer: Color(0xFF2F353E),
    onSecondaryContainer: Color(0xFFE9ECF0),
    tertiary: Color(0xFFA2AAB6),
    onTertiary: Color(0xFF15181E),
    tertiaryContainer: Color(0xFF2F353E),
    onTertiaryContainer: Color(0xFFE9ECF0),
    error: Color(0xFFFFB4A9),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF5C1A14),
    onErrorContainer: Color(0xFFFFDAD4),
    surface: Color(0xFF1B1E23),
    onSurface: Color(0xFFE9ECF0),
    surfaceDim: Color(0xFF16181C),
    surfaceBright: Color(0xFF30353C),
    surfaceContainerLowest: Color(0xFF16181C),
    surfaceContainerLow: Color(0xFF1F2227),
    surfaceContainer: Color(0xFF22262B),
    surfaceContainerHigh: Color(0xFF16181C),
    surfaceContainerHighest: Color(0xFF2D3238),
    onSurfaceVariant: Color(0xFFA2AAB6),
    outline: Color(0xFF6F7784),
    outlineVariant: Color(0xFF363B43),
    inverseSurface: Color(0xFFE9ECF0),
    onInverseSurface: Color(0xFF1B1E23),
    inversePrimary: Color(0xFF15181E),
    surfaceTint: Colors.transparent,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );
}
