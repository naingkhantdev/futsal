/// In-app maps use OpenStreetMap tiles through `flutter_map`: no API key
/// and no billing account (Google Maps requires one). "Directions" still
/// hands off to the Google Maps app / website, which needs neither.
///
/// OSM's tile servers are free under a fair-use policy: the app must send
/// its package name and show the "© OpenStreetMap contributors" credit
/// (see `VenueMap`). Fine for admins pinning venues and venue previews; if
/// traffic grows, point [tileUrl] at a hosted provider with a free tier.
abstract final class MapsConfig {
  static const String tileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// Sent as the tiles' User-Agent (OSM tile policy).
  static const String userAgentPackage = 'com.futsalbooking.futsal_booking';

  /// Reverse geocoding fallback (OSM Nominatim, free, max 1 request/s,
  /// identified by [userAgentPackage]). Used only when the phone's own
  /// geocoder finds nothing for a pin.
  static const String nominatimReverseUrl =
      'https://nominatim.openstreetmap.org/reverse';

  static const String copyrightUrl =
      'https://www.openstreetmap.org/copyright';

  /// Camera when nothing is pinned yet: central Yangon.
  static const double defaultLatitude = 16.8409;
  static const double defaultLongitude = 96.1735;
  static const double defaultZoom = 12;

  /// Close enough to see the streets around one venue.
  static const double venueZoom = 16;

  /// OSM tiles stop at 19.
  static const double maxZoom = 19;
}
