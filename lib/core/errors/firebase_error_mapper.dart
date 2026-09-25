import 'dart:async' show TimeoutException;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_exception.dart';

/// Machine-readable `details.reason` values that Cloud Functions put in
/// `HttpsError(code, message, {reason: ...})` for domain failures.
/// The functions/ code must use exactly these strings.
abstract final class ServerErrorReason {
  static const String bookingConflict = 'booking-conflict';
  static const String courtUnavailable = 'court-unavailable';
  static const String stadiumUnavailable = 'stadium-unavailable';
  static const String shopUnavailable = 'shop-unavailable';
  static const String invalidBookingTime = 'invalid-booking-time';
  static const String invalidDate = 'invalid-date';
  static const String accountDisabled = 'account-disabled';
}

/// Client-side auth error codes raised by `lib/firebase/auth` wrappers
/// (not issued by Firebase itself).
abstract final class AuthErrorCodes {
  /// An operation needed a signed-in user but there was none.
  static const String noCurrentUser = 'no-current-user';
}

/// Converts any thrown error into an [AppException].
///
/// Called by repositories (data layer) only — never from widgets. Raw error
/// text is preserved in [AppException.cause] for logging and never shown.
abstract final class FirebaseErrorMapper {
  static AppException map(Object error, [StackTrace? stackTrace]) {
    final st = stackTrace;
    return switch (error) {
      final AppException e => e,
      // Subclasses of FirebaseException must be matched before it.
      final FirebaseFunctionsException e => _fromFunctions(e, st),
      final FirebaseAuthException e => _fromAuth(e, st),
      final FirebaseException e => _fromCommonCode(e, st),
      TimeoutException() => NetworkException(cause: error, stackTrace: st),
      _ => UnknownException(cause: error, stackTrace: st),
    };
  }

  static AppException _fromAuth(FirebaseAuthException e, StackTrace? st) {
    return switch (e.code) {
      'invalid-credential' ||
      'invalid-login-credentials' ||
      'wrong-password' ||
      'user-not-found' =>
        InvalidCredentialsException(cause: e, stackTrace: st),
      'invalid-email' => InvalidEmailException(cause: e, stackTrace: st),
      'email-already-in-use' =>
        EmailAlreadyInUseException(cause: e, stackTrace: st),
      'weak-password' => WeakPasswordException(cause: e, stackTrace: st),
      'too-many-requests' =>
        TooManyRequestsException(cause: e, stackTrace: st),
      'user-disabled' => AccountDisabledException(cause: e, stackTrace: st),
      'network-request-failed' => NetworkException(cause: e, stackTrace: st),
      'requires-recent-login' ||
      'user-token-expired' ||
      'invalid-user-token' ||
      'user-mismatch' ||
      AuthErrorCodes.noCurrentUser =>
        AuthenticationException(cause: e, stackTrace: st),
      _ => ServerException(cause: e, stackTrace: st),
    };
  }

  static AppException _fromFunctions(
    FirebaseFunctionsException e,
    StackTrace? st,
  ) {
    final details = e.details;
    final reason = details is Map ? details['reason'] : null;
    final AppException? byReason = switch (reason) {
      ServerErrorReason.bookingConflict =>
        BookingConflictException(cause: e, stackTrace: st),
      ServerErrorReason.courtUnavailable =>
        CourtUnavailableException(cause: e, stackTrace: st),
      ServerErrorReason.stadiumUnavailable =>
        StadiumUnavailableException(cause: e, stackTrace: st),
      ServerErrorReason.shopUnavailable =>
        ShopUnavailableException(cause: e, stackTrace: st),
      ServerErrorReason.invalidBookingTime =>
        InvalidBookingTimeException(cause: e, stackTrace: st),
      ServerErrorReason.invalidDate =>
        InvalidDateException(cause: e, stackTrace: st),
      ServerErrorReason.accountDisabled =>
        AccountDisabledException(cause: e, stackTrace: st),
      _ => null,
    };
    if (byReason != null) return byReason;

    return switch (_normalize(e.code)) {
      'already-exists' => BookingConflictException(cause: e, stackTrace: st),
      _ => _fromCommonCode(e, st),
    };
  }

  /// Codes shared by Firestore, Storage and Functions.
  static AppException _fromCommonCode(FirebaseException e, StackTrace? st) {
    return switch (_normalize(e.code)) {
      'permission-denied' ||
      'unauthorized' =>
        PermissionDeniedException(cause: e, stackTrace: st),
      'unauthenticated' => AuthenticationException(cause: e, stackTrace: st),
      'unavailable' ||
      'deadline-exceeded' ||
      'retry-limit-exceeded' ||
      'network-request-failed' =>
        NetworkException(cause: e, stackTrace: st),
      'not-found' ||
      'object-not-found' =>
        NotFoundException(cause: e, stackTrace: st),
      'resource-exhausted' =>
        TooManyRequestsException(cause: e, stackTrace: st),
      _ => ServerException(cause: e, stackTrace: st),
    };
  }

  /// Some platforms report `PERMISSION_DENIED`, others `permission-denied`.
  static String _normalize(String code) =>
      code.toLowerCase().replaceAll('_', '-');
}
