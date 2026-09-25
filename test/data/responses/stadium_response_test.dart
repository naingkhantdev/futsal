import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/booking_policy.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/data/responses/stadium_response.dart';

void main() {
  test('parses a full doc', () {
    final r = StadiumResponse.fromFirestore('st1', const {
      'shopId': 's1',
      'name': 'Arena One',
      'city': 'Yangon',
      'images': ['a.jpg', 'b.jpg'],
      'facilities': ['parking', 'shower', 'floodLights'],
      'openMinute': 480,
      'closeMinute': 1320,
      'timeZone': 'Asia/Yangon',
      'isActive': true,
      'isPublished': true,
      'minHourlyPrice': 25000,
    });
    expect(r.shopId, 's1');
    expect(r.images, ['a.jpg', 'b.jpg']);
    expect(r.facilities,
        [Facility.parking, Facility.shower, Facility.floodLights]);
    expect(r.openMinute, 480);
    expect(r.closeMinute, 1320);
    expect(r.isActive, isTrue);
    expect(r.isPublished, isTrue);
    expect(r.minHourlyPrice, 25000);
  });

  test('empty doc: fail-closed defaults', () {
    final r = StadiumResponse.fromFirestore('st1', const {});
    expect(r.shopId, '');
    expect(r.name, '');
    expect(r.images, isEmpty);
    expect(r.facilities, isEmpty);
    expect(r.openMinute, 0);
    expect(r.closeMinute, 0);
    expect(r.timeZone, BookingPolicy.defaultTimeZone);
    expect(r.isActive, isFalse);
    expect(r.isPublished, isFalse);
    expect(r.minHourlyPrice, isNull);
  });

  test('unknown facility keys are dropped', () {
    final r = StadiumResponse.fromFirestore('st1', const {
      'facilities': ['parking', 'helipad', 3, 'cafe'],
    });
    expect(r.facilities, [Facility.parking, Facility.cafe]);
  });

  test('fractional or negative money reads as null; whole doubles accepted',
      () {
    expect(
      StadiumResponse.fromFirestore('st1', const {'minHourlyPrice': 250.5})
          .minHourlyPrice,
      isNull,
    );
    expect(
      StadiumResponse.fromFirestore('st1', const {'minHourlyPrice': -1})
          .minHourlyPrice,
      isNull,
    );
    expect(
      StadiumResponse.fromFirestore('st1', const {'minHourlyPrice': 30000.0})
          .minHourlyPrice,
      30000,
    );
  });

  test('isPublished must be a real true', () {
    final r = StadiumResponse.fromFirestore('st1', const {'isPublished': 1});
    expect(r.isPublished, isFalse);
  });
}
