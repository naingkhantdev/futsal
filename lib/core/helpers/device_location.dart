import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../errors/app_exception.dart';
import '../utils/geo_location.dart';

/// The phone's approximate position, for "near me" sorting only. Never
/// stored or sent anywhere. Asks for permission only when [current] is
/// called (i.e. after the user taps "Near me").
class DeviceLocation {
  const DeviceLocation();

  /// Throws [LocationUnavailableException] when location services are off
  /// or permission is refused.
  Future<MapPoint> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const LocationUnavailableException();
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const LocationUnavailableException();
      }
      // Approximate is plenty for sorting venues, and works with the
      // coarse-only Android permission.
      final p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 15),
      );
      return (latitude: p.latitude, longitude: p.longitude);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw LocationUnavailableException(cause: e, stackTrace: st);
    }
  }
}

final deviceLocationProvider =
    Provider<DeviceLocation>((ref) => const DeviceLocation());
