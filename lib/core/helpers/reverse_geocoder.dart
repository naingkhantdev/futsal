import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../constants/maps_config.dart';
import '../constants/venue_policy.dart';
import '../utils/geo_location.dart';

/// Street / township / city found for a map pin. Any part may be `null`.
typedef PlaceAddress = ({String? address, String? township, String? city});

/// Turns a map pin into a written address. First the phone's own geocoder
/// (Android / iOS platform service; no API key, no billing); when that finds
/// nothing or misses parts — no Play-services geocoder on the device, sparse
/// Myanmar data — the gaps are filled from OpenStreetMap Nominatim (free,
/// no key). Display only: the pin is what directions use, and
/// firestore.rules validate the text like any typed address.
///
/// Results are cached per pin + language, so the map picker's live lookup
/// and the form's lookup after "Use this location" agree and the second
/// one is instant.
class ReverseGeocoder {
  ReverseGeocoder({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // Open Location Codes ("7MXF+2X") are not useful as a street line.
  static final _plusCode = RegExp(r'^[23456789CFGHJMPQRVWX]{2,8}\+');

  static const _osmTimeout = Duration(seconds: 8);

  /// Nominatim's usage policy: at most one request per second.
  static const _osmMinGap = Duration(milliseconds: 1100);
  DateTime? _lastOsmCall;

  final Map<String, PlaceAddress?> _cache = {};

  /// `null` when nothing useful was found or every lookup failed (offline).
  /// [languageCode] is the app language (`my` / `en`). Burmese results that
  /// miss the city / township are completed from an English lookup.
  Future<PlaceAddress?> lookup(MapPoint point, String languageCode) async {
    final key = '${point.latitude.toStringAsFixed(5)},'
        '${point.longitude.toStringAsFixed(5)},$languageCode';
    if (_cache.containsKey(key)) return _cache[key];

    var found = await _query(point, languageCode == 'my' ? 'my_MM' : 'en_US');
    if (languageCode == 'my' &&
        (found?.city == null || found?.township == null)) {
      found = _merge(found, await _query(point, 'en_US'));
    }
    if (found == null ||
        found.address == null ||
        found.township == null ||
        found.city == null) {
      found = _merge(found, await _queryOsm(point, languageCode));
    }
    // Failures (offline) are not cached, so moving back retries.
    if (found != null) _cache[key] = found;
    return found;
  }

  /// [a]'s parts, with the missing ones taken from [b].
  static PlaceAddress? _merge(PlaceAddress? a, PlaceAddress? b) {
    if (a == null) return b;
    if (b == null) return a;
    return (
      address: a.address ?? b.address,
      township: a.township ?? b.township,
      city: a.city ?? b.city,
    );
  }

  Future<PlaceAddress?> _query(MapPoint point, String locale) async {
    try {
      await setLocaleIdentifier(locale);
      final marks =
          await placemarkFromCoordinates(point.latitude, point.longitude);
      // Several candidates: take each part from the first one that has it.
      String? pick(String? Function(Placemark m) part) {
        for (final m in marks) {
          final v = _clean(part(m));
          if (v != null) return v;
        }
        return null;
      }

      return _place(
        address: pick((m) => m.street) ??
            pick((m) => [m.subThoroughfare, m.thoroughfare]
                .whereType<String>()
                .join(' ')) ??
            pick((m) => m.name),
        township:
            pick((m) => m.subLocality) ?? pick((m) => m.subAdministrativeArea),
        city: pick((m) => m.locality) ?? pick((m) => m.administrativeArea),
      );
    } catch (_) {
      return null;
    }
  }

  /// OpenStreetMap Nominatim reverse lookup. Burmese names where OSM has
  /// them, English otherwise.
  Future<PlaceAddress?> _queryOsm(MapPoint point, String languageCode) async {
    try {
      final last = _lastOsmCall;
      if (last != null) {
        final wait = _osmMinGap - DateTime.now().difference(last);
        if (wait > Duration.zero) await Future<void>.delayed(wait);
      }
      _lastOsmCall = DateTime.now();

      final uri = Uri.parse(MapsConfig.nominatimReverseUrl).replace(
        queryParameters: {
          'format': 'jsonv2',
          'lat': point.latitude.toString(),
          'lon': point.longitude.toString(),
          'zoom': '18',
          'addressdetails': '1',
          'accept-language': languageCode == 'my' ? 'my,en' : 'en',
        },
      );
      final res = await _client.get(
        uri,
        headers: {'User-Agent': MapsConfig.userAgentPackage},
      ).timeout(_osmTimeout);
      if (res.statusCode != 200) return null;

      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (body is! Map<String, dynamic>) return null;
      final a = body['address'];
      if (a is! Map<String, dynamic>) return null;

      String? first(List<String> keys) {
        for (final k in keys) {
          final v = a[k];
          final t = v is String ? _clean(v) : null;
          if (t != null) return t;
        }
        return null;
      }

      final road = first(['road', 'pedestrian', 'footway', 'path']);
      final house = first(['house_number']);
      final name = body['name'];
      return _place(
        address: road == null
            ? (name is String ? _clean(name) : null)
            : [house, road].whereType<String>().join(' '),
        township: first([
          'suburb',
          'city_district',
          'township',
          'county',
          'quarter',
          'neighbourhood',
        ]),
        city: first(['city', 'town', 'village', 'municipality', 'state']),
      );
    } catch (_) {
      return null;
    }
  }

  static PlaceAddress? _place({
    required String? address,
    required String? township,
    required String? city,
  }) {
    if (address == null && township == null && city == null) return null;
    return (
      address: _fit(address, VenuePolicy.addressMaxLength),
      township: _fit(township, VenuePolicy.placeMaxLength),
      city: _fit(city, VenuePolicy.placeMaxLength),
    );
  }

  static String? _clean(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty || _plusCode.hasMatch(t)) return null;
    return t;
  }

  static String? _fit(String? v, int max) =>
      v == null || v.length <= max ? v : v.substring(0, max).trim();
}

final reverseGeocoderProvider =
    Provider<ReverseGeocoder>((ref) => ReverseGeocoder());
