import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../core/errors/app_exception.dart';

/// Client-side view of the signed-in session, used for UX routing only.
///
/// Role, shopId and isActive are read from `users/{uid}` — the same fields
/// firestore.rules authorize against. The client copy is NOT authoritative:
/// the rules enforce every read and write independently.
@immutable
sealed class AuthSession {
  const AuthSession();

  /// Auth state or the `users/{uid}` profile not resolved yet.
  const factory AuthSession.unknown() = SessionUnknown;

  const factory AuthSession.signedOut() = SignedOut;

  /// Signed in to Firebase Auth, but `users/{uid}` does not exist (e.g.
  /// registration was interrupted after the Auth account was created). The
  /// session re-creates the customer doc; router keeps the user on splash.
  const factory AuthSession.incomplete({required String uid}) =
      SessionIncomplete;

  /// Session could not be resolved. Splash shows an error with
  /// "Try again" (when [SessionFailure.canRetry]) and "Sign out".
  const factory AuthSession.error({
    required SessionFailure failure,
    required AppException error,
    String? uid,
  }) = SessionError;

  const factory AuthSession.signedIn({
    required String uid,
    required UserRole role,
    required bool isActive,
    String? shopId,
  }) = SignedIn;
}

/// Why a session could not be resolved.
enum SessionFailure {
  /// The profile did not resolve within the resolve timeout.
  timeout,

  /// `users/{uid}` was missing and re-creating it failed.
  setupFailed,

  /// PLATFORM: `users/{uid}.role` is missing or not superadmin / shopAdmin /
  /// customer. Treated as not authorized — never mapped to a default role.
  unrecognizedRole,

  /// Firebase reported the account as disabled while resolving.
  accountDisabled,

  /// The profile failed to load (offline, rules, backend error).
  loadFailed;

  bool get canRetry =>
      this == timeout || this == setupFailed || this == loadFailed;
}

final class SessionUnknown extends AuthSession {
  const SessionUnknown();

  @override
  bool operator ==(Object other) => other is SessionUnknown;

  @override
  int get hashCode => (SessionUnknown).hashCode;
}

final class SignedOut extends AuthSession {
  const SignedOut();

  @override
  bool operator ==(Object other) => other is SignedOut;

  @override
  int get hashCode => (SignedOut).hashCode;
}

final class SessionIncomplete extends AuthSession {
  const SessionIncomplete({required this.uid});

  final String uid;

  @override
  bool operator ==(Object other) =>
      other is SessionIncomplete && other.uid == uid;

  @override
  int get hashCode => Object.hash(SessionIncomplete, uid);
}

final class SessionError extends AuthSession {
  const SessionError({required this.failure, required this.error, this.uid});

  final SessionFailure failure;

  /// Friendly, already-mapped error. Never raw Firebase text.
  final AppException error;
  final String? uid;

  @override
  bool operator ==(Object other) =>
      other is SessionError &&
      other.failure == failure &&
      other.uid == uid &&
      other.error.runtimeType == error.runtimeType;

  @override
  int get hashCode => Object.hash(failure, uid, error.runtimeType);
}

final class SignedIn extends AuthSession {
  const SignedIn({
    required this.uid,
    required this.role,
    required this.isActive,
    this.shopId,
  });

  final String uid;
  final UserRole role;

  /// `users/{uid}.isActive`; false when a superadmin deactivated the account.
  final bool isActive;

  /// Set only for [UserRole.shopAdmin].
  final String? shopId;

  /// Disabled account, or a shop admin without a shop assignment.
  bool get isBlocked =>
      !isActive ||
      (role == UserRole.shopAdmin && (shopId == null || shopId!.isEmpty));

  @override
  bool operator ==(Object other) =>
      other is SignedIn &&
      other.uid == uid &&
      other.role == role &&
      other.isActive == isActive &&
      other.shopId == shopId;

  @override
  int get hashCode => Object.hash(uid, role, isActive, shopId);
}
