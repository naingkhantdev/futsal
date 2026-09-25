import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/utils/validators.dart';

void main() {
  group('name', () {
    test('required, at least 2 chars after trim', () {
      expect(AppValidators.name(null), ValidationMessages.nameRequired);
      expect(AppValidators.name(''), ValidationMessages.nameRequired);
      expect(AppValidators.name('   '), ValidationMessages.nameRequired);
      expect(AppValidators.name(' A '), ValidationMessages.nameRequired);
      expect(AppValidators.name('Al'), isNull);
      expect(AppValidators.name('  Aung Aung  '), isNull);
    });

    test('max length', () {
      final max = 'a' * ValidationLimits.nameMaxLength;
      expect(AppValidators.name(max), isNull);
      expect(AppValidators.name('${max}a'), ValidationMessages.nameTooLong);
    });
  });

  group('email', () {
    test('required', () {
      expect(AppValidators.email(null), ValidationMessages.emailRequired);
      expect(AppValidators.email('  '), ValidationMessages.emailRequired);
    });

    test('format', () {
      for (final bad in ['plain', 'a@b', '@b.com', 'a b@c.com', 'a@b .com']) {
        expect(AppValidators.email(bad), ValidationMessages.emailInvalid,
            reason: bad);
      }
      for (final good in ['a@b.co', ' user.name+tag@example.com ']) {
        expect(AppValidators.email(good), isNull, reason: good);
      }
    });
  });

  group('optionalPhone', () {
    test('blank is valid (optional)', () {
      expect(AppValidators.optionalPhone(null), isNull);
      expect(AppValidators.optionalPhone(''), isNull);
      expect(AppValidators.optionalPhone('   '), isNull);
    });

    test('7–15 digits, leading + and spaces allowed', () {
      expect(AppValidators.optionalPhone('1234567'), isNull);
      expect(AppValidators.optionalPhone('+95 9 123 456 789'), isNull);
      expect(AppValidators.optionalPhone('123456789012345'), isNull);
    });

    test('rejects too few / too many digits and bad characters', () {
      for (final bad in [
        '123456',
        '1234567890123456',
        '09-123-4567',
        '12+34567890',
        'abc1234567',
        '++1234567',
      ]) {
        expect(AppValidators.optionalPhone(bad), ValidationMessages.phoneInvalid,
            reason: bad);
      }
    });
  });

  group('passwords', () {
    test('login password: required only', () {
      expect(AppValidators.loginPassword(null),
          ValidationMessages.passwordRequired);
      expect(AppValidators.loginPassword(''),
          ValidationMessages.passwordRequired);
      expect(AppValidators.loginPassword('x'), isNull);
    });

    test('current password: required', () {
      expect(AppValidators.currentPassword(''),
          ValidationMessages.currentPasswordRequired);
      expect(AppValidators.currentPassword('x'), isNull);
    });

    test('new password: at least 8 characters', () {
      final min = 'a' * ValidationLimits.passwordMinLength;
      expect(AppValidators.newPassword(null),
          ValidationMessages.passwordTooShort);
      expect(AppValidators.newPassword(min.substring(1)),
          ValidationMessages.passwordTooShort);
      expect(AppValidators.newPassword(min), isNull);
    });

    test('changed password must differ from current', () {
      expect(AppValidators.changedPassword('short', 'whatever1'),
          ValidationMessages.passwordTooShort);
      expect(AppValidators.changedPassword('samepass1', 'samepass1'),
          ValidationMessages.passwordUnchanged);
      expect(AppValidators.changedPassword('newpass12', 'oldpass12'), isNull);
    });
  });

  test('normalizePhone trims and maps blank to null', () {
    expect(AppValidators.normalizePhone(null), isNull);
    expect(AppValidators.normalizePhone('  '), isNull);
    expect(AppValidators.normalizePhone(' +95 912 '), '+95 912');
  });
}
