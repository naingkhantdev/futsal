import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/utils/time_range.dart';
import 'package:futsal_booking/data/repositories/mappers/blocked_slot_mapper.dart';
import 'package:futsal_booking/data/responses/blocked_slot_response.dart';
import 'package:futsal_booking/data/vos/blocked_slot_vo.dart';

void main() {
  test('Firestore map -> BlockedSlotResponse -> BlockedSlotVO', () {
    final start = DateTime(2026, 9, 24, 10);
    final end = DateTime(2026, 9, 24, 12);
    final t = DateTime(2026, 9, 1);
    final vo = BlockedSlotResponse.fromFirestore('bs1', {
      'shopId': 's1',
      'stadiumId': 'st1',
      'courtId': 'c1',
      'date': '2026-09-24',
      'startMinute': 600,
      'endMinute': 720,
      'startAt': Timestamp.fromDate(start),
      'endAt': Timestamp.fromDate(end),
      'reason': 'maintenance',
      'note': 'Resurfacing',
      'createdBy': 'admin1',
      'createdAt': Timestamp.fromDate(t),
      'updatedAt': Timestamp.fromDate(t),
    }).toVO();

    expect(
      vo,
      BlockedSlotVO(
        id: 'bs1',
        shopId: 's1',
        stadiumId: 'st1',
        courtId: 'c1',
        date: '2026-09-24',
        startMinute: 600,
        endMinute: 720,
        startAt: start,
        endAt: end,
        reason: BlockedSlotReason.maintenance,
        note: 'Resurfacing',
        createdBy: 'admin1',
        createdAt: t,
        updatedAt: t,
      ),
    );
    expect(vo.timeRange, const TimeRange(600, 720));
  });
}
