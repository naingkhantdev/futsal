import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/venue_policy.dart';
import 'package:futsal_booking/core/utils/geo_location.dart';

void main() {
  group('GeoLocation.parse', () {
    test('plain coordinates, comma or space separated', () {
      expect(
        GeoLocation.parse('16.8409, 96.1735'),
        (latitude: 16.8409, longitude: 96.1735),
      );
      expect(
        GeoLocation.parse(' 16.8409 96.1735 '),
        (latitude: 16.8409, longitude: 96.1735),
      );
      expect(
        GeoLocation.parse('-33.8688,151.2093'),
        (latitude: -33.8688, longitude: 151.2093),
      );
    });

    test('Google Maps place link prefers the place pin over the camera', () {
      const link = 'https://www.google.com/maps/place/Kandawgyi/'
          '@16.7995,96.1610,17z/data=!3m1!4b1!4m6!3m5!1s0x0:0x0!8m2'
          '!3d16.80012!4d96.16155';
      expect(
        GeoLocation.parse(link),
        (latitude: 16.80012, longitude: 96.16155),
      );
    });

    test('camera-centre and query-parameter links', () {
      expect(
        GeoLocation.parse('https://www.google.com/maps/@16.7995,96.1610,15z'),
        (latitude: 16.7995, longitude: 96.161),
      );
      expect(
        GeoLocation.parse('https://maps.google.com/?q=16.85,96.12'),
        (latitude: 16.85, longitude: 96.12),
      );
      expect(
        GeoLocation.parse(
          'https://www.google.com/maps/search/?api=1&query=21.975%2C96.0836',
        ),
        (latitude: 21.975, longitude: 96.0836),
      );
    });

    test('rejects out-of-range, partial and non-coordinate input', () {
      expect(GeoLocation.parse(''), isNull);
      expect(GeoLocation.parse('1234'), isNull);
      expect(GeoLocation.parse('91, 10'), isNull);
      expect(GeoLocation.parse('16.8, 181'), isNull);
      expect(GeoLocation.parse('hello 16.8, 96.1'), isNull);
    });

    test('short links carry no coordinates', () {
      const short = 'https://maps.app.goo.gl/AbCdEf123';
      expect(GeoLocation.parse(short), isNull);
      expect(GeoLocation.isShortMapsLink(short), isTrue);
      expect(GeoLocation.isShortMapsLink('16.8, 96.1'), isFalse);
    });
  });

  test('directions link targets the point', () {
    expect(
      GeoLocation.directionsUri((latitude: 16.8, longitude: 96.1)).toString(),
      'https://www.google.com/maps/dir/?api=1&destination=16.8%2C96.1',
    );
  });

  group('VenuePolicy.isValidLocation (mirror of firestore.rules)', () {
    test('both or neither', () {
      expect(VenuePolicy.isValidLocation(null, null), isTrue);
      expect(VenuePolicy.isValidLocation(16.8, null), isFalse);
      expect(VenuePolicy.isValidLocation(null, 96.1), isFalse);
    });

    test('range', () {
      expect(VenuePolicy.isValidLocation(90, 180), isTrue);
      expect(VenuePolicy.isValidLocation(-90, -180), isTrue);
      expect(VenuePolicy.isValidLocation(90.1, 0), isFalse);
      expect(VenuePolicy.isValidLocation(0, -180.1), isFalse);
      expect(VenuePolicy.isValidLocation(double.nan, 0), isFalse);
    });
  });
}
