/// Asset paths (declared in pubspec.yaml `flutter: assets:`).
abstract final class AppAssets {
  /// Square emblem with a soft transparent edge (splash, brand spots).
  static const String logoMark = 'assets/images/logo/logo_mark.png';

  /// [logoMark] split into layers for the splash animation: the emblem
  /// without ball, light arcs and swoosh; one light arc at the right edge
  /// (the artwork's inner, second arc is removed); the swoosh (ball's light
  /// ray) on its own; and the ball on its own. Stacked, they recreate
  /// [logoMark] minus that second arc.
  static const String logoEmblem = 'assets/images/logo/logo_emblem.png';
  static const String logoArcs = 'assets/images/logo/logo_arcs.png';
  static const String logoSwoosh = 'assets/images/logo/logo_swoosh.png';
  static const String logoBall = 'assets/images/logo/logo_ball.png';

  /// Original wide logo artwork (emblem on the navy network background).
  static const String logoBanner = 'assets/images/logo/logo_banner.jpg';

  /// 1024×1024 app icon source (launcher icons are generated from it).
  static const String appIcon = 'assets/icons/app_icon.png';
}
