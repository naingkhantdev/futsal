import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/utils/date_key.dart';

void main() {
  test('fromDate pads fields', () {
    expect(DateKey.fromDate(DateTime(2026, 3, 7)), '2026-03-07');
    expect(DateKey.fromDate(DateTime.utc(2026, 12, 31, 23)), '2026-12-31');
  });

  test('tryParse accepts real dates only', () {
    expect(DateKey.tryParse('2026-09-24'), DateTime.utc(2026, 9, 24));
    expect(DateKey.tryParse('2028-02-29'), DateTime.utc(2028, 2, 29));
    for (final bad in [
      null,
      '',
      '2026-9-24',
      '2026/09/24',
      '2026-02-30',
      '2026-13-01',
      '2026-09-24T00:00',
    ]) {
      expect(DateKey.tryParse(bad), isNull, reason: '$bad');
      expect(DateKey.isValid(bad), isFalse, reason: '$bad');
    }
  });
}
