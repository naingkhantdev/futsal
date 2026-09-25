/// Form field validators (design_system.md §9 "Validation messages").
///
/// Pure functions returning `null` when valid, otherwise the user-facing
/// message. Client validation is UX only — Security Rules re-check the
/// fields the client may write (`users/{uid}`: name, phone).
library;

import '../constants/venue_policy.dart';

/// Length / count limits. Keep in sync with `firestore.rules`
/// (`validProfileUpdate`).
abstract final class ValidationLimits {
  static const int nameMinLength = 2;
  static const int nameMaxLength = 80;
  static const int phoneMinDigits = 7;
  static const int phoneMaxDigits = 15;
  static const int passwordMinLength = 8;
}

/// Fixed validation copy.
abstract final class ValidationMessages {
  static const String nameRequired = 'Enter your name';
  static const String nameTooLong = 'Use 80 characters or fewer';
  static const String emailRequired = 'Enter your email';
  static const String emailInvalid = 'Enter a valid email address';
  static const String phoneInvalid = 'Enter a valid phone number';
  static const String passwordRequired = 'Enter your password';
  static const String passwordTooShort = 'Use at least 8 characters';
  static const String currentPasswordRequired = 'Enter your current password';
  static const String passwordUnchanged =
      'Choose a password different from your current one';
}

abstract final class AppValidators {
  // Deliberately permissive: one "@", no spaces, a dot in the domain.
  // Firebase Auth performs the authoritative check.
  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  // Optional leading "+", then digits and spaces only.
  static final RegExp _phoneChars = RegExp(r'^\+?[0-9 ]+$');
  static final RegExp _nonDigit = RegExp(r'[^0-9]');

  /// Required, 2–80 characters after trimming.
  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.length < ValidationLimits.nameMinLength) {
      return ValidationMessages.nameRequired;
    }
    if (v.length > ValidationLimits.nameMaxLength) {
      return ValidationMessages.nameTooLong;
    }
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return ValidationMessages.emailRequired;
    if (!_email.hasMatch(v)) return ValidationMessages.emailInvalid;
    return null;
  }

  /// Optional. When present: 7–15 digits; "+" (leading) and spaces allowed.
  static String? optionalPhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (!_phoneChars.hasMatch(v)) return ValidationMessages.phoneInvalid;
    final digits = v.replaceAll(_nonDigit, '').length;
    if (digits < ValidationLimits.phoneMinDigits ||
        digits > ValidationLimits.phoneMaxDigits) {
      return ValidationMessages.phoneInvalid;
    }
    return null;
  }

  /// Login: required only (never hint at the password policy on login).
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.passwordRequired;
    }
    return null;
  }

  /// Current password in the change-password form.
  static String? currentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.currentPasswordRequired;
    }
    return null;
  }

  /// Register / change password: at least 8 characters.
  static String? newPassword(String? value) {
    if (value == null || value.length < ValidationLimits.passwordMinLength) {
      return ValidationMessages.passwordTooShort;
    }
    return null;
  }

  /// New password must satisfy [newPassword] and differ from [current].
  static String? changedPassword(String? value, String current) {
    final base = newPassword(value);
    if (base != null) return base;
    if (value == current) return ValidationMessages.passwordUnchanged;
    return null;
  }

  /// Trimmed phone, or `null` when blank (stored as null, not "").
  static String? normalizePhone(String? value) {
    final v = value?.trim() ?? '';
    return v.isEmpty ? null : v;
  }
}

/// Shop / stadium / court form validators. Limits come from `VenuePolicy`,
/// which mirrors firestore.rules (`validShopShape`, `validStadiumShape`,
/// `validCourtShape`).
abstract final class VenueValidators {
  static final RegExp _digits = RegExp(r'^[0-9]+$');

  /// Required display name (shop / stadium / court), 2–80 characters.
  static String? title(String? value, {required String emptyMessage}) {
    final v = value?.trim() ?? '';
    if (v.length < ValidationLimits.nameMinLength) return emptyMessage;
    if (v.length > ValidationLimits.nameMaxLength) {
      return ValidationMessages.nameTooLong;
    }
    return null;
  }

  /// Optional free text of at most [max] characters.
  static String? optionalText(String? value, int max) {
    final v = value?.trim() ?? '';
    return v.length > max ? 'Use $max characters or fewer' : null;
  }

  static String? optionalEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (v.length > VenuePolicy.emailMaxLength) {
      return ValidationMessages.emailInvalid;
    }
    return AppValidators.email(v);
  }

  /// Required whole kyat, 0 … [VenuePolicy.maxHourlyPrice].
  static String? hourlyPrice(String? value) {
    final v = value?.trim().replaceAll(',', '') ?? '';
    if (v.isEmpty) return 'Enter the price per hour';
    if (!_digits.hasMatch(v)) return 'Use whole kyat, digits only';
    final n = int.tryParse(v);
    if (n == null || n > VenuePolicy.maxHourlyPrice) {
      return 'Enter a price up to ${VenuePolicy.maxHourlyPrice}';
    }
    return null;
  }

  /// Optional players count, 1 … [VenuePolicy.maxCapacity].
  static String? optionalCapacity(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    final n = _digits.hasMatch(v) ? int.tryParse(v) : null;
    if (n == null || n < 1 || n > VenuePolicy.maxCapacity) {
      return 'Enter a number from 1 to ${VenuePolicy.maxCapacity}';
    }
    return null;
  }

  /// Parses a value accepted by [hourlyPrice] / [optionalCapacity].
  static int? parseInt(String? value) {
    final v = value?.trim().replaceAll(',', '') ?? '';
    return v.isEmpty ? null : int.tryParse(v);
  }
}
