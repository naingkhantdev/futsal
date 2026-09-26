import 'package:flutter/material.dart';

/// Brand colors taken from the logo (assets/images/logo/). Used by the
/// splash, which always renders on the dark brand background regardless of
/// the app theme. Keep [navy] in sync with
/// android/app/src/main/res/values/colors.xml (native launch screen).
abstract final class AppBrand {
  static const Color navy = Color(0xFF081226);
  static const Color navyDeep = Color(0xFF040913);
  static const Color navyLight = Color(0xFF13264A);
  static const Color gold = Color(0xFFD9B46A);
  static const Color goldLight = Color(0xFFF7E7B4);
  static const Color goldDark = Color(0xFF9C7632);
  static const Color blue = Color(0xFF3D6FB6);
  static const Color blueLight = Color(0xFF8EB6EE);
  static const Color onNavy = Color(0xFFF3F5F8);
  static const Color onNavyMuted = Color(0xFF9AA6BA);

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navyLight, navy, navyDeep],
    stops: [0, 0.55, 1],
  );

  static const LinearGradient goldText = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold, goldDark],
  );
}
