import 'package:flutter/animation.dart';

/// Motion tokens (design_system.md §4.5). Calm and quick: nothing bounces
/// or overshoots, everything decelerates into place.
abstract final class AppMotion {
  /// Color / fill changes (slot select, chip toggle).
  static const Duration state = Duration(milliseconds: 180);
  static const Duration enterExit = Duration(milliseconds: 280);

  /// Content entering the screen (fade + rise).
  static const Duration entrance = Duration(milliseconds: 460);

  /// Delay between consecutive items of a staggered entrance.
  static const Duration stagger = Duration(milliseconds: 45);

  /// Items after this index enter together (no ever-growing delay).
  static const int maxStaggerIndex = 8;

  /// How long after a list appears its items may still animate in.
  static const Duration entranceWindow = Duration(milliseconds: 700);

  /// Distance content rises while fading in.
  static const double entranceOffset = 16;

  /// Press feedback on cards.
  static const Duration press = Duration(milliseconds: 120);
  static const double pressScale = 0.975;

  static const Duration skeletonPulse = Duration(seconds: 1);
  static const Curve curve = Curves.easeOutCubic;

  /// Long, soft deceleration for entrances.
  static const Curve entranceCurve = Curves.easeOutQuart;

  /// Lower bound of the skeleton opacity pulse (upper bound is 1.0).
  static const double skeletonMinOpacity = 0.55;
}
