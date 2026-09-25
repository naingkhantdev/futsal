import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/data/responses/blocked_slot_response.dart';

void main() {
  test('parses a full doc', () {
    final r = BlockedSlotResponse.fromFirestore('bs1', const {
      'shopId': 's1',
      'stadiumId': 'st1',
      'courtId': 'c1',
      'date': '2026-09-24',
      'startMinute': 600,
      'endMinute': 720,
      'reason': 'privateEvent',
      'note': 'Company match',
      'createdBy': 'admin1',
    });
    expect(r.date, '2026-09-24');
    expect(r.startMinute, 600);
    expect(r.endMinute, 720);
    expect(r.reason, BlockedSlotReason.privateEvent);
    expect(r.note, 'Company match');
  });

  test('missing fields and unknown reason fall back', () {
    final r = BlockedSlotResponse.fromFirestore('bs1', const {
      'reason': 'alienInvasion',
    });
    expect(r.shopId, '');
    expect(r.startMinute, 0);
    expect(r.endMinute, 0);
    expect(r.reason, BlockedSlotReason.other);
    expect(r.note, isNull);
  });
}
