import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/booking_policy.dart';
import 'package:futsal_booking/data/responses/court_response.dart';

void main() {
  CourtResponse parse(Map<String, dynamic> data) =>
      CourtResponse.fromFirestore('c1', data, parentStadiumId: 'st1');

  test('parses a full doc', () {
    final r = parse(const {
      'shopId': 's1',
      'stadiumId': 'st1',
      'name': 'Court 1',
      'surfaceType': 'turf',
      'capacity': 10,
      'hourlyPrice': 30000,
      'currency': 'MMK',
      'slotMinutes': 30,
      'isActive': true,
    });
    expect(r.name, 'Court 1');
    expect(r.capacity, 10);
    expect(r.hourlyPrice, 30000);
    expect(r.slotMinutes, 30);
    expect(r.isActive, isTrue);
  });

  test('empty doc: defaults, inactive, unpriced', () {
    final r = parse(const {});
    expect(r.stadiumId, 'st1');
    expect(r.shopId, '');
    expect(r.hourlyPrice, isNull);
    expect(r.currency, BookingPolicy.currency);
    expect(r.slotMinutes, BookingPolicy.defaultSlotMinutes);
    expect(r.isActive, isFalse);
    expect(r.capacity, isNull);
  });

  test('float or negative price is rejected', () {
    expect(parse(const {'hourlyPrice': 29999.5}).hourlyPrice, isNull);
    expect(parse(const {'hourlyPrice': -100}).hourlyPrice, isNull);
    expect(parse(const {'hourlyPrice': '30000'}).hourlyPrice, isNull);
  });

  test('invalid slotMinutes falls back to the default', () {
    for (final bad in [0, -30, 2000, 'sixty', 45.5]) {
      expect(parse({'slotMinutes': bad}).slotMinutes,
          BookingPolicy.defaultSlotMinutes,
          reason: '$bad');
    }
  });
}
