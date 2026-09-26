import 'package:flutter/material.dart';

import 'app_radius.dart';

/// How far a neumorphic element is lifted off the surface.
enum DepthLevel {
  /// Slot tiles, chips, icon wells, small buttons.
  low(distance: 3, blur: 7),

  /// Cards and secondary buttons.
  medium(distance: 6, blur: 16),

  /// Hero panels, floating bars.
  high(distance: 10, blur: 26);

  const DepthLevel({required this.distance, required this.blur});

  final double distance;
  final double blur;
}

/// Neumorphic depth tokens (design_system.md §4.6).
///
/// A raised element has the same fill as the surface behind it and is lifted
/// by a pair of soft shadows: [highlight] from the top-left light source and
/// [shade] to the bottom-right. A recessed "well" (inputs, pressed states) is a
/// top-left-dark → bottom-right-light gradient, since Flutter 3.22 has no
/// inset [BoxShadow].
///
/// Use sparingly and only on the page surface: stacking raised elements on
/// raised elements muddies the effect. Every raised element keeps a faint
/// [edge] so its boundary never relies on shadow alone (contrast).
@immutable
class AppDepth extends ThemeExtension<AppDepth> {
  const AppDepth({
    required this.base,
    required this.highlight,
    required this.shade,
    required this.wellDark,
    required this.wellLight,
    required this.edge,
    required this.accentShadow,
  });

  /// Fill for raised elements; equals `ColorScheme.surface`.
  final Color base;
  final Color highlight;
  final Color shade;
  final Color wellDark;
  final Color wellLight;

  /// Hairline border that keeps raised edges legible at low contrast.
  final Color edge;

  /// Soft drop shadow under ink (primary) buttons and selected tiles.
  final Color accentShadow;

  static const AppDepth light = AppDepth(
    base: Color(0xFFE9EDF2),
    highlight: Color(0xE6FFFFFF),
    shade: Color(0x8CA3B1C6),
    wellDark: Color(0xFFD6DCE4),
    wellLight: Color(0xFFEEF1F5),
    edge: Color(0x80FFFFFF),
    accentShadow: Color(0x4015181E),
  );

  static const AppDepth dark = AppDepth(
    base: Color(0xFF1B1E23),
    highlight: Color(0x14FFFFFF),
    shade: Color(0xB3000000),
    wellDark: Color(0xFF131519),
    wellLight: Color(0xFF1F2227),
    edge: Color(0x0FFFFFFF),
    accentShadow: Color(0x66000000),
  );

  /// Light/shade shadow pair for a raised element.
  List<BoxShadow> raised([DepthLevel level = DepthLevel.medium]) => [
        BoxShadow(
          color: highlight,
          offset: Offset(-level.distance, -level.distance),
          blurRadius: level.blur,
        ),
        BoxShadow(
          color: shade,
          offset: Offset(level.distance, level.distance),
          blurRadius: level.blur,
        ),
      ];

  /// Single soft drop shadow for ink (filled) elements.
  List<BoxShadow> ink([DepthLevel level = DepthLevel.medium]) => [
        BoxShadow(
          color: accentShadow,
          offset: Offset(0, level.distance),
          blurRadius: level.blur,
          spreadRadius: -level.distance / 2,
        ),
      ];

  /// Raised surface decoration.
  BoxDecoration raisedDecoration({
    DepthLevel level = DepthLevel.medium,
    BorderRadius borderRadius = AppRadius.lgAll,
    Color? color,
  }) =>
      BoxDecoration(
        color: color ?? base,
        borderRadius: borderRadius,
        border: Border.all(color: edge),
        boxShadow: raised(level),
      );

  /// Recessed "well" decoration (inputs, pressed/selected-neutral states).
  BoxDecoration wellDecoration({
    BorderRadius borderRadius = AppRadius.mdAll,
  }) =>
      BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [wellDark, wellLight],
        ),
      );

  @override
  AppDepth copyWith({
    Color? base,
    Color? highlight,
    Color? shade,
    Color? wellDark,
    Color? wellLight,
    Color? edge,
    Color? accentShadow,
  }) {
    return AppDepth(
      base: base ?? this.base,
      highlight: highlight ?? this.highlight,
      shade: shade ?? this.shade,
      wellDark: wellDark ?? this.wellDark,
      wellLight: wellLight ?? this.wellLight,
      edge: edge ?? this.edge,
      accentShadow: accentShadow ?? this.accentShadow,
    );
  }

  @override
  AppDepth lerp(ThemeExtension<AppDepth>? other, double t) {
    if (other is! AppDepth) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppDepth(
      base: l(base, other.base),
      highlight: l(highlight, other.highlight),
      shade: l(shade, other.shade),
      wellDark: l(wellDark, other.wellDark),
      wellLight: l(wellLight, other.wellLight),
      edge: l(edge, other.edge),
      accentShadow: l(accentShadow, other.accentShadow),
    );
  }
}
