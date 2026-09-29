import 'package:flutter/material.dart';

import 'app_radius.dart';

/// How far an element is lifted off the page. In the "Premium" look
/// [medium] and [high] cast one soft, wide navy-tinted shadow; [low] is
/// separated from the page by fill + hairline alone.
enum DepthLevel {
  /// Slot tiles, chips, icon wells, small buttons.
  low(distance: 1, blur: 2),

  /// Cards and secondary buttons.
  medium(distance: 6, blur: 24),

  /// Floating bars, dialogs, menus.
  high(distance: 12, blur: 36);

  const DepthLevel({required this.distance, required this.blur});

  final double distance;
  final double blur;
}

/// Surface tokens for the "Premium" look (design_system.md §0).
///
/// Cards are white ([base]) on a warm ivory page with a hairline [edge] and
/// one soft [shade] shadow. A "well" (search field, icon circle, booked slot)
/// is a flat [well] fill.
@immutable
class AppDepth extends ThemeExtension<AppDepth> {
  const AppDepth({
    required this.base,
    required this.edge,
    required this.shade,
    required this.well,
  });

  /// Fill for cards and other raised elements.
  final Color base;

  /// Hairline border around cards, bars and tiles.
  final Color edge;

  /// Color of the single soft shadow under floating elements.
  final Color shade;

  /// Flat recessed fill (search field, icon circles, booked slots).
  final Color well;

  static const AppDepth light = AppDepth(
    base: Color(0xFFFFFFFF),
    edge: Color(0xFFECE8DF),
    shade: Color(0x120F1B33),
    well: Color(0xFFF1EFE9),
  );

  static const AppDepth dark = AppDepth(
    base: Color(0xFF111A2E),
    edge: Color(0xFF222C44),
    shade: Color(0x66000000),
    well: Color(0xFF19233B),
  );

  /// Shadows for a raised element: none for [DepthLevel.low].
  List<BoxShadow> raised([DepthLevel level = DepthLevel.medium]) =>
      level != DepthLevel.low
          ? [
              BoxShadow(
                color: shade,
                offset: Offset(0, level.distance),
                blurRadius: level.blur,
              ),
            ]
          : const [];

  /// Filled (ink) elements are flat.
  List<BoxShadow> ink([DepthLevel level = DepthLevel.medium]) => const [];

  /// Card-like surface: [base] fill + hairline [edge].
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

  /// Flat recessed fill.
  BoxDecoration wellDecoration({
    BorderRadius borderRadius = AppRadius.mdAll,
  }) =>
      BoxDecoration(color: well, borderRadius: borderRadius);

  @override
  AppDepth copyWith({
    Color? base,
    Color? edge,
    Color? shade,
    Color? well,
  }) {
    return AppDepth(
      base: base ?? this.base,
      edge: edge ?? this.edge,
      shade: shade ?? this.shade,
      well: well ?? this.well,
    );
  }

  @override
  AppDepth lerp(ThemeExtension<AppDepth>? other, double t) {
    if (other is! AppDepth) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppDepth(
      base: l(base, other.base),
      edge: l(edge, other.edge),
      shade: l(shade, other.shade),
      well: l(well, other.well),
    );
  }
}
