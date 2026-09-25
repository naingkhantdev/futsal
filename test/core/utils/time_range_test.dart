import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/utils/time_range.dart';

void main() {
  group('TimeRange.overlaps', () {
    const base = TimeRange(600, 660); // 10:00-11:00

    void expectSymmetric(TimeRange a, TimeRange b, bool expected) {
      expect(a.overlaps(b), expected, reason: '$a vs $b');
      expect(b.overlaps(a), expected, reason: '$b vs $a');
    }

    test('adjacent ranges do not overlap', () {
      expectSymmetric(base, const TimeRange(660, 720), false);
      expectSymmetric(base, const TimeRange(540, 600), false);
    });

    test('disjoint ranges do not overlap', () {
      expectSymmetric(base, const TimeRange(720, 780), false);
    });

    test('identical ranges overlap', () {
      expectSymmetric(base, const TimeRange(600, 660), true);
    });

    test('contained ranges overlap', () {
      expectSymmetric(base, const TimeRange(615, 645), true);
      expectSymmetric(base, const TimeRange(540, 720), true);
    });

    test('partial overlaps', () {
      expectSymmetric(base, const TimeRange(630, 690), true);
      expectSymmetric(base, const TimeRange(570, 601), true);
    });
  });

  group('TimeRange.isValid', () {
    test('non-empty and inside one day', () {
      expect(const TimeRange(0, 60).isValid, isTrue);
      expect(const TimeRange(1380, 1440).isValid, isTrue);
      expect(const TimeRange(600, 600).isValid, isFalse);
      expect(const TimeRange(660, 600).isValid, isFalse);
      expect(const TimeRange(-30, 60).isValid, isFalse);
      expect(const TimeRange(1380, 1500).isValid, isFalse);
    });

    test('durationMinutes', () {
      expect(const TimeRange(600, 690).durationMinutes, 90);
    });
  });

  group('SlotRules.generateSlots', () {
    test('fills opening hours exactly', () {
      final slots = SlotRules.generateSlots(
        openMinute: 480,
        closeMinute: 720,
        slotMinutes: 60,
      );
      expect(slots, const [
        TimeRange(480, 540),
        TimeRange(540, 600),
        TimeRange(600, 660),
        TimeRange(660, 720),
      ]);
    });

    test('first slot starts at open, last ends at or before close', () {
      final slots = SlotRules.generateSlots(
        openMinute: 510,
        closeMinute: 750,
        slotMinutes: 60,
      );
      expect(slots.first, const TimeRange(510, 570));
      expect(slots.last, const TimeRange(690, 750));
    });

    test('drops a trailing partial slot', () {
      final slots = SlotRules.generateSlots(
        openMinute: 480,
        closeMinute: 630,
        slotMinutes: 60,
      );
      expect(slots, const [TimeRange(480, 540), TimeRange(540, 600)]);
    });

    test('closing at midnight (1440) is allowed', () {
      final slots = SlotRules.generateSlots(
        openMinute: 1320,
        closeMinute: 1440,
        slotMinutes: 60,
      );
      expect(slots, const [TimeRange(1320, 1380), TimeRange(1380, 1440)]);
    });

    test('hours shorter than one slot give no slots', () {
      expect(
        SlotRules.generateSlots(
          openMinute: 480,
          closeMinute: 510,
          slotMinutes: 60,
        ),
        isEmpty,
      );
    });

    test('invalid input gives no slots', () {
      List<TimeRange> gen(int open, int close, int slot) =>
          SlotRules.generateSlots(
            openMinute: open,
            closeMinute: close,
            slotMinutes: slot,
          );
      expect(gen(600, 600, 60), isEmpty);
      expect(gen(720, 600, 60), isEmpty);
      expect(gen(-60, 600, 60), isEmpty);
      expect(gen(600, 1500, 60), isEmpty);
      expect(gen(480, 720, 0), isEmpty);
      expect(gen(480, 720, -30), isEmpty);
    });
  });

  group('SlotRules.isBookableWindow', () {
    bool bookable(int start, int end, {int slot = 60}) =>
        SlotRules.isBookableWindow(
          TimeRange(start, end),
          openMinute: 480,
          closeMinute: 1320,
          slotMinutes: slot,
        );

    test('aligned whole-slot windows inside hours', () {
      expect(bookable(480, 540), isTrue);
      expect(bookable(600, 780), isTrue);
      expect(bookable(1260, 1320), isTrue);
    });

    test('outside opening hours', () {
      expect(bookable(420, 480), isFalse);
      expect(bookable(1260, 1380), isFalse);
    });

    test('misaligned start or partial slot', () {
      expect(bookable(510, 570), isFalse);
      expect(bookable(480, 570), isFalse);
      expect(bookable(510, 540, slot: 30), isTrue);
    });

    test('empty or inverted range', () {
      expect(bookable(600, 600), isFalse);
      expect(bookable(660, 600), isFalse);
    });
  });

  test('formatMinuteOfDay', () {
    expect(formatMinuteOfDay(0), '00:00');
    expect(formatMinuteOfDay(545), '09:05');
    expect(formatMinuteOfDay(1440), '24:00');
  });
}
