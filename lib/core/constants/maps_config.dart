/// Google Maps SDK switch.
///
/// The SDK needs an API key (Android: `MAPS_API_KEY` in
/// `android/local.properties`, injected into the manifest by
/// `app/build.gradle`). Without a key the map renders grey tiles, so the
/// live map is opt-in at build time:
///
/// ```
/// flutter run --dart-define=MAPS_ENABLED=true
/// ```
///
/// When off, venues show a map-free location card; "Directions" still
/// hands off to the Google Maps app / website (no key needed for that).
abstract final class MapsConfig {
  static const bool enabled = bool.fromEnvironment('MAPS_ENABLED');

  /// Camera when nothing is pinned yet: central Yangon.
  static const double defaultLatitude = 16.8409;
  static const double defaultLongitude = 96.1735;
  static const double defaultZoom = 12;

  /// Close enough to see the streets around one venue.
  static const double venueZoom = 16;

  /// Marker hue (0–360) close to the brand gold.
  static const double markerHue = 42;
}
