import '../constants/venue_policy.dart';

/// A map point in WGS84 degrees.
typedef MapPoint = ({double latitude, double longitude});

/// Parsing and Google Maps links for venue locations. Pure Dart, no SDK.
abstract final class GeoLocation {
  static final RegExp _number = RegExp(r'-?\d+(?:\.\d+)?');

  /// Place pin inside a Google Maps URL (`!3d<lat>!4d<lng>`): the venue
  /// itself, more precise than the camera centre.
  static final RegExp _placePin =
      RegExp(r'!3d(-?\d+(?:\.\d+)?)!4d(-?\d+(?:\.\d+)?)');

  /// Camera centre in a Google Maps URL (`/@<lat>,<lng>,17z`).
  static final RegExp _atCenter =
      RegExp(r'@(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)');

  /// Query parameters Google Maps uses for a point.
  static const List<String> _pointParams = [
    'q',
    'query',
    'll',
    'destination',
    'center',
  ];

  /// Reads a point from what a shop admin pastes: `16.8409, 96.1735`,
  /// `16.8409 96.1735`, or a full Google Maps link. Returns `null` when no
  /// valid point is found. Short `maps.app.goo.gl` links can't be read
  /// offline (see [isShortMapsLink]).
  static MapPoint? parse(String input) {
    final text = input.trim();
    if (text.isEmpty) return null;

    final pin = _placePin.firstMatch(text);
    if (pin != null) return _point(pin.group(1)!, pin.group(2)!);

    final uri = Uri.tryParse(text);
    if (uri != null && uri.hasScheme) {
      for (final key in _pointParams) {
        final value = uri.queryParameters[key];
        if (value == null) continue;
        final point = _pair(value);
        if (point != null) return point;
      }
      final at = _atCenter.firstMatch(text);
      if (at != null) return _point(at.group(1)!, at.group(2)!);
      return null;
    }
    return _pair(text);
  }

  /// `maps.app.goo.gl/…` / `goo.gl/maps/…`: a redirect with no coordinates
  /// in it.
  static bool isShortMapsLink(String input) {
    final host = Uri.tryParse(input.trim())?.host ?? '';
    return host == 'maps.app.goo.gl' || host == 'goo.gl';
  }

  /// "16.84090, 96.17350" (5 decimals ≈ 1 m).
  static String format(MapPoint p) =>
      '${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}';

  /// Opens Google Maps (app or web) with turn-by-turn directions to [p].
  static Uri directionsUri(MapPoint p) =>
      Uri.https('www.google.com', '/maps/dir/', {
        'api': '1',
        'destination': '${p.latitude},${p.longitude}',
      });

  /// Opens Google Maps (app or web) showing a pin at [p].
  static Uri viewUri(MapPoint p) =>
      Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': '${p.latitude},${p.longitude}',
      });

  /// Opens Google Maps searching for a text address (venues without a pin).
  static Uri searchUri(String address) =>
      Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': address,
      });

  /// Exactly two numbers ("lat, lng" or "lat lng").
  static MapPoint? _pair(String value) {
    final numbers =
        _number.allMatches(value).map((m) => m.group(0)!).toList();
    if (numbers.length != 2) return null;
    final rest =
        value.replaceAll(_number, '').replaceAll(RegExp(r'[\s,;]'), '');
    if (rest.isNotEmpty) return null;
    return _point(numbers[0], numbers[1]);
  }

  static MapPoint? _point(String lat, String lng) {
    final latitude = double.tryParse(lat);
    final longitude = double.tryParse(lng);
    if (latitude == null || longitude == null) return null;
    if (!VenuePolicy.isValidLocation(latitude, longitude)) return null;
    return (latitude: latitude, longitude: longitude);
  }
}
