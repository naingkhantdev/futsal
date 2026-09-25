import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/data/responses/booking_response.dart';

void main() {
  test('parses a full doc', () {
    final start = DateTime(2026, 9, 24, 12, 30);
    final end = DateTime(2026, 9, 24, 13, 30);
    final r = BookingResponse.fromFirestore('b1', {
      'shopId': 's1',
      'customerId': 'u1',
      'stadiumId': 'st1',
      'courtId': 'c1',
      'bookingDate': '2026-09-24',
      'startMinute': 1140,
      'endMinute': 1200,
      'startAt': Timestamp.fromDate(start),
      'endAt': Timestamp.fromDate(end),
      'pricePerHour': 30000,
      'totalPrice': 30000,
      'currency': 'MMK',
      'status': 'confirmed',
      'paymentStatus': 'paid',
      'customerNameSnapshot': 'Aung',
      'customerPhoneSnapshot': '+95 9123',
      'stadiumNameSnapshot': 'Arena One',
      'courtNameSnapshot': 'Court 1',
    });
    expect(r.bookingDate, '2026-09-24');
    expect(r.startMinute, 1140);
    expect(r.endMinute, 1200);
    expect(r.startAt, start);
    expect(r.endAt, end);
    expect(r.totalPrice, 30000);
    expect(r.status, BookingStatus.confirmed);
    expect(r.paymentStatus, PaymentStatus.paid);
    expect(r.customerPhoneSnapshot, '+95 9123');
  });

  test('empty doc: safe defaults', () {
    final r = BookingResponse.fromFirestore('b1', const {});
    expect(r.customerId, '');
    expect(r.bookingDate, '');
    expect(r.startMinute, 0);
    expect(r.endMinute, 0);
    expect(r.startAt, isNull);
    expect(r.pricePerHour, 0);
    expect(r.totalPrice, 0);
    expect(r.currency, 'MMK');
    expect(r.status, BookingStatus.pending);
    expect(r.paymentStatus, PaymentStatus.unpaid);
    expect(r.customerNameSnapshot, '');
  });

  test('unknown enums never elevate', () {
    final r = BookingResponse.fromFirestore('b1', const {
      'status': 'CONFIRMED',
      'paymentStatus': 'paid_in_full',
    });
    expect(r.status, BookingStatus.pending);
    expect(r.paymentStatus, PaymentStatus.unpaid);
  });

  test('fractional money is not trusted', () {
    final r = BookingResponse.fromFirestore('b1', const {
      'pricePerHour': 30000.5,
      'totalPrice': -1,
    });
    expect(r.pricePerHour, 0);
    expect(r.totalPrice, 0);
  });
}
