import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/data/repositories/mappers/booking_mapper.dart';
import 'package:futsal_booking/data/responses/booking_response.dart';
import 'package:futsal_booking/data/vos/booking_vo.dart';

void main() {
  final start = DateTime(2026, 9, 24, 19);
  final end = DateTime(2026, 9, 24, 20, 30);
  final t = DateTime(2026, 9, 20);

  BookingVO fromMap({String status = 'confirmed'}) =>
      BookingResponse.fromFirestore('b1', {
        'shopId': 's1',
        'customerId': 'u1',
        'stadiumId': 'st1',
        'courtId': 'c1',
        'bookingDate': '2026-09-24',
        'startMinute': 1140,
        'endMinute': 1230,
        'startAt': Timestamp.fromDate(start),
        'endAt': Timestamp.fromDate(end),
        'pricePerHour': 30000,
        'totalPrice': 45000,
        'currency': 'MMK',
        'status': status,
        'paymentStatus': 'unpaid',
        'customerNameSnapshot': 'Aung',
        'customerPhoneSnapshot': '+95 9123',
        'stadiumNameSnapshot': 'Arena One',
        'courtNameSnapshot': 'Court 1',
        'createdAt': Timestamp.fromDate(t),
        'updatedAt': Timestamp.fromDate(t),
      }).toVO();

  test('Firestore map -> BookingResponse -> BookingVO keeps every field', () {
    expect(
      fromMap(),
      BookingVO(
        id: 'b1',
        shopId: 's1',
        customerId: 'u1',
        stadiumId: 'st1',
        courtId: 'c1',
        bookingDate: '2026-09-24',
        startMinute: 1140,
        endMinute: 1230,
        startAt: start,
        endAt: end,
        pricePerHour: 30000,
        totalPrice: 45000,
        currency: 'MMK',
        status: BookingStatus.confirmed,
        paymentStatus: PaymentStatus.unpaid,
        customerNameSnapshot: 'Aung',
        customerPhoneSnapshot: '+95 9123',
        stadiumNameSnapshot: 'Arena One',
        courtNameSnapshot: 'Court 1',
        createdAt: t,
        updatedAt: t,
      ),
    );
  });

  test('durationMinutes and blocking', () {
    final vo = fromMap();
    expect(vo.durationMinutes, 90);
    expect(vo.timeRange.isValid, isTrue);
    expect(vo.blocksAvailability, isTrue);
    expect(fromMap(status: 'cancelled').blocksAvailability, isFalse);
  });

  test('isUpcoming: blocking status and start in the future', () {
    final before = start.subtract(const Duration(minutes: 1));
    expect(fromMap().isUpcoming(before), isTrue);
    expect(fromMap(status: 'pending').isUpcoming(before), isTrue);
    expect(fromMap().isUpcoming(start), isFalse);
    expect(fromMap().isUpcoming(end), isFalse);
    expect(fromMap(status: 'cancelled').isUpcoming(before), isFalse);
    expect(fromMap(status: 'completed').isUpcoming(before), isFalse);
    expect(fromMap().copyWith(startAt: null).isUpcoming(before), isFalse);
  });
}
