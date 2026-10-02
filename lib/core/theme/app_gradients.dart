import 'package:flutter/material.dart';

/// Gradient tokens for the "Sand + Terracotta" look (2026-10-02): warm
/// espresso surfaces with a thin clay accent. Tonal only; no multi-color
/// gradients. Widgets read these via `context.gradients`; never build
/// gradients inline.
///
/// [hero] is the one espresso fill (brand mark, booking ticket); [scrim] makes
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

  /// Deep espresso: headers on home / dashboards, the brand mark.
  final LinearGradient hero;

  /// Text and icons on [hero].
  final Color onHero;
  final Color onHeroMuted;

  /// The single accent: eyebrow text on [hero], rule lines, section bars,
  /// the selected-slot ring. Never a large fill. (Named `gold` from the old
  /// palette; it is now a light clay.)
  final Color gold;

  /// Filled primary buttons and the selected slot (subtle tonal sheen).
  final LinearGradient primary;

  /// Soft shadow under [primary] elements.
  final Color primaryGlow;

  /// Stadium image placeholder.
  final LinearGradient pitch;

  /// Espresso veil over a venue photo: clear at the top, near-opaque at the
  /// bottom so [onHero] / [onHeroMuted] / [gold] text on it passes AA.
  final LinearGradient scrim;

  static const AppGradients light = AppGradients(
    hero: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3A2A20), Color(0xFF2A1E17), Color(0xFF1C140F)],
      stops: [0, 0.6, 1],
    ),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFD8C9BC),
    gold: Color(0xFFE9A27E),
    primary: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFC85A35), Color(0xFFB84A27)],
    ),
    primaryGlow: Color(0x33C2532F),
    pitch: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4A362A), Color(0xFF2A1E17)],
    ),
    scrim: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x33140E0B),
        Color(0x00140E0B),
        Color(0x99140E0B),
        Color(0xE6140E0B),
      ],
      stops: [0, 0.25, 0.6, 1],
    ),
  );

  static const AppGradients dark = AppGradients(
    hero: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF33261E), Color(0xFF241C17), Color(0xFF15110E)],
      stops: [0, 0.6, 1],
    ),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFB5AAA0),
    gold: Color(0xFFF0A483),
    primary: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF08F6C), Color(0xFFE07550)],
    ),
    primaryGlow: Color(0x33E9805C),
    pitch: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF33261E), Color(0xFF15110E)],
    ),
    scrim: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x4D0D0907),
        Color(0x000D0907),
        Color(0xA60D0907),
        Color(0xF00D0907),
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
