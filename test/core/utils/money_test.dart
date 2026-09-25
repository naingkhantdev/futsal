import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/utils/money.dart';

void main() {
  group('Money.totalPrice', () {
    int? price(int hourly, int minutes, {int slot = 60}) => Money.totalPrice(
          hourlyPrice: hourly,
          minutes: minutes,
          slotMinutes: slot,
        );

    test('hourlyPrice * minutes / 60', () {
      expect(price(30000, 60), 30000);
      expect(price(30000, 120), 60000);
      expect(price(25000, 90, slot: 30), 37500);
      expect(price(0, 60), 0);
    });

    test('rejects durations that are not whole slots (no silent rounding)',
        () {
      expect(price(30000, 90), isNull);
      expect(price(30000, 30), isNull);
      expect(price(30000, 45, slot: 30), isNull);
    });

    test('rejects non-positive minutes / slot and negative price', () {
      expect(price(30000, 0), isNull);
      expect(price(30000, -60), isNull);
      expect(price(30000, 60, slot: 0), isNull);
      expect(price(-1, 60), isNull);
    });

    test('non-divisible amounts round half up to a whole kyat', () {
      // 25,001 * 45 / 60 = 18,750.75 -> 18,751
      expect(price(25001, 45, slot: 45), 18751);
      // 10 * 15 / 60 = 2.5 -> 3 (half up)
      expect(price(10, 15, slot: 15), 3);
      // 10 * 5 / 60 = 0.83 -> 1 ; 1 * 15 / 60 = 0.25 -> 0
      expect(price(10, 5, slot: 5), 1);
      expect(price(1, 15, slot: 15), 0);
    });
  });

  group('Money.formatMmk', () {
    test('groups thousands', () {
      expect(Money.formatMmk(0), 'MMK 0');
      expect(Money.formatMmk(999), 'MMK 999');
      expect(Money.formatMmk(1000), 'MMK 1,000');
      expect(Money.formatMmk(30000), 'MMK 30,000');
      expect(Money.formatMmk(1234567), 'MMK 1,234,567');
    });

    test('negative amounts', () {
      expect(Money.formatMmk(-45000), '-MMK 45,000');
    });
  });
}
