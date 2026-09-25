import 'package:flutter/animation.dart';

/// Motion tokens (design_system.md §4.5).
abstract final class AppMotion {
  static const Duration state = Duration(milliseconds: 150);
  static const Duration enterExit = Duration(milliseconds: 250);
  static const Duration skeletonPulse = Duration(seconds: 1);
  static const Curve curve = Curves.easeOutCubic;

  /// Lower bound of the skeleton opacity pulse (upper bound is 1.0).
  static const double skeletonMinOpacity = 0.55;
}
