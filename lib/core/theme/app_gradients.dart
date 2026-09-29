import 'package:flutter/material.dart';

/// Gradient tokens for the "Premium" look (design_system.md §0): deep navy
/// surfaces with a thin gold accent. Tonal only; no multi-color gradients.
/// Widgets read these via `context.gradients`; never build gradients inline.
///
/// [hero] is the one navy fill (brand mark, booking ticket); [scrim] makes
/// text readable over venue photos. Nothing else is a gradient.
@immutable
class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({
    required this.hero,
    required this.onHero,
    required this.onHeroMuted,
    required this.gold,
    required this.primary,
    required this.primaryGlow,
    required this.pitch,
    required this.scrim,
  });

  /// Deep navy: headers on home / dashboards, the brand mark.
  final LinearGradient hero;

  /// Text and icons on [hero].
  final Color onHero;
  final Color onHeroMuted;

  /// The single accent: eyebrow text on [hero], rule lines, section bars,
  /// the selected-slot ring. Never a large fill.
  final Color gold;

  /// Filled primary buttons and the selected slot (subtle tonal sheen).
  final LinearGradient primary;

  /// Soft shadow under [primary] elements.
  final Color primaryGlow;

  /// Stadium image placeholder.
  final LinearGradient pitch;

  /// Navy veil over a venue photo: clear at the top, near-opaque at the
  /// bottom so [onHero] / [onHeroMuted] / [gold] text on it passes AA.
  final LinearGradient scrim;

  static const AppGradients light = AppGradients(
    hero: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1B2C50), Color(0xFF0F1B33), Color(0xFF081226)],
      stops: [0, 0.6, 1],
    ),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFB9C2D3),
    gold: Color(0xFFC9A355),
    primary: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A2A4A), Color(0xFF0F1B33)],
    ),
    primaryGlow: Color(0x330F1B33),
    pitch: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF22365F), Color(0xFF0F1B33)],
    ),
    scrim: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x330A1020),
        Color(0x000A1020),
        Color(0x990A1020),
        Color(0xE60A1020),
      ],
      stops: [0, 0.25, 0.6, 1],
    ),
  );

  static const AppGradients dark = AppGradients(
    hero: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1A2745), Color(0xFF111A2E), Color(0xFF0A1020)],
      stops: [0, 0.6, 1],
    ),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFA3ABBD),
    gold: Color(0xFFD9B46A),
    primary: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE6C47F), Color(0xFFCFA85C)],
    ),
    primaryGlow: Color(0x33D9B46A),
    pitch: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1A2745), Color(0xFF0A1020)],
    ),
    scrim: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x4D060A16),
        Color(0x00060A16),
        Color(0xA6060A16),
        Color(0xF0060A16),
      ],
      stops: [0, 0.25, 0.6, 1],
    ),
  );

  @override
  AppGradients copyWith({
    LinearGradient? hero,
    Color? onHero,
    Color? onHeroMuted,
    Color? gold,
    LinearGradient? primary,
    Color? primaryGlow,
    LinearGradient? pitch,
    LinearGradient? scrim,
  }) {
    return AppGradients(
      hero: hero ?? this.hero,
      onHero: onHero ?? this.onHero,
      onHeroMuted: onHeroMuted ?? this.onHeroMuted,
      gold: gold ?? this.gold,
      primary: primary ?? this.primary,
      primaryGlow: primaryGlow ?? this.primaryGlow,
      pitch: pitch ?? this.pitch,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) return this;
    return AppGradients(
      hero: LinearGradient.lerp(hero, other.hero, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
      onHeroMuted: Color.lerp(onHeroMuted, other.onHeroMuted, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      primary: LinearGradient.lerp(primary, other.primary, t)!,
      primaryGlow: Color.lerp(primaryGlow, other.primaryGlow, t)!,
      pitch: LinearGradient.lerp(pitch, other.pitch, t)!,
      scrim: LinearGradient.lerp(scrim, other.scrim, t)!,
    );
  }
}
