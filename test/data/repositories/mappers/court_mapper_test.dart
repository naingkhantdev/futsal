import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/utils/time_range.dart';
import 'package:futsal_booking/data/repositories/mappers/court_mapper.dart';
import 'package:futsal_booking/data/responses/court_response.dart';
import 'package:futsal_booking/data/vos/court_vo.dart';

void main() {
  test('Firestore map -> CourtResponse -> CourtVO keeps every field', () {
    final t = DateTime(2026, 3, 4);
    final vo = CourtResponse.fromFirestore(
      'c1',
      {
        'shopId': 's1',
        'stadiumId': 'st1',
        'name': 'Court 1',
        'description': 'Near the entrance',
        'surfaceType': 'turf',
        'capacity': 10,
        'hourlyPrice': 30000,
        'currency': 'MMK',
        'slotMinutes': 60,
        'images': const ['c.jpg'],
        'isActive': true,
        'createdAt': Timestamp.fromDate(t),
        'updatedAt': Timestamp.fromDate(t),
      },
      parentStadiumId: 'st1',
    ).toVO();

    expect(
      vo,
      CourtVO(
        id: 'c1',
        shopId: 's1',
        stadiumId: 'st1',
        name: 'Court 1',
        description: 'Near the entrance',
        surfaceType: 'turf',
        capacity: 10,
        hourlyPrice: 30000,
        currency: 'MMK',
        slotMinutes: 60,
        images: const ['c.jpg'],
        isActive: true,
        createdAt: t,
        updatedAt: t,
      ),
    );
  });

  test('slot and preview-price helpers', () {
    const court = CourtVO(
      id: 'c1',
      shopId: 's1',
      stadiumId: 'st1',
      name: 'Court 1',
      hourlyPrice: 30000,
      currency: 'MMK',
      slotMinutes: 60,
      isActive: true,
    );
    expect(court.slots(openMinute: 480, closeMinute: 600),
        const [TimeRange(480, 540), TimeRange(540, 600)]);
    expect(court.previewPrice(120), 60000);
    expect(court.previewPrice(90), isNull);
    expect(court.copyWith(hourlyPrice: null).previewPrice(60), isNull);
  });
}
