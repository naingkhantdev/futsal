import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/utils/time_range.dart';
import 'package:futsal_booking/data/repositories/mappers/stadium_mapper.dart';
import 'package:futsal_booking/data/responses/stadium_response.dart';
import 'package:futsal_booking/data/vos/stadium_vo.dart';

void main() {
  test('Firestore map -> StadiumResponse -> StadiumVO keeps every field', () {
    final t = DateTime(2026, 2, 3);
    final vo = StadiumResponse.fromFirestore('st1', {
      'shopId': 's1',
      'name': 'Arena One',
      'description': 'Indoor',
      'address': '2 Side St',
      'township': 'Kamayut',
      'city': 'Yangon',
      'latitude': 16.82,
      'longitude': 96.13,
      'images': const ['a.jpg', 'b.jpg'],
      'facilities': const ['parking', 'cafe'],
      'openMinute': 480,
      'closeMinute': 1320,
      'timeZone': 'Asia/Yangon',
      'isActive': true,
      'isPublished': true,
      'minHourlyPrice': 25000,
      'createdAt': Timestamp.fromDate(t),
      'updatedAt': Timestamp.fromDate(t),
    }).toVO();

    expect(
      vo,
      StadiumVO(
        id: 'st1',
        shopId: 's1',
        name: 'Arena One',
        description: 'Indoor',
        address: '2 Side St',
        township: 'Kamayut',
        city: 'Yangon',
        latitude: 16.82,
        longitude: 96.13,
        images: const ['a.jpg', 'b.jpg'],
        facilities: const [Facility.parking, Facility.cafe],
        openMinute: 480,
        closeMinute: 1320,
        timeZone: 'Asia/Yangon',
        isActive: true,
        isPublished: true,
        minHourlyPrice: 25000,
        createdAt: t,
        updatedAt: t,
      ),
    );
    expect(vo.openingHours, const TimeRange(480, 1320));
    expect(vo.hasValidOpeningHours, isTrue);
    expect(vo.coverImage, 'a.jpg');
    expect(vo.hasLocation, isTrue);
  });

  test('empty doc maps to a closed, unpublished stadium', () {
    final vo = StadiumResponse.fromFirestore('st1', const {}).toVO();
    expect(vo.hasValidOpeningHours, isFalse);
    expect(vo.isPublished, isFalse);
    expect(vo.coverImage, isNull);
    expect(vo.hasLocation, isFalse);
  });
}
