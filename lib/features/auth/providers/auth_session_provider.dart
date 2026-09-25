import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/domain_enums.dart';
import '../../../core/errors/firebase_error_mapper.dart';
import '../../../data/repositories/auth_session_source.dart';
import '../../../data/vos/auth_session.dart';

/// Raw session stream. Invalidate it to retry resolution from scratch
/// (splash "Try again").
final authSessionProvider = StreamProvider<AuthSession>(
  (ref) => ref.watch(authSessionSourceProvider).watchSession(),
);

/// Session as a plain value for the router and screens: loading →
/// [SessionUnknown], stream error → [SessionError] (never stuck on splash).
final currentAuthSessionProvider = Provider<AuthSession>(
  (ref) => sessionFromAsync(ref.watch(authSessionProvider)),
);

/// SHOP scope: the signed-in shop admin's `users/{uid}.shopId`, or `null`
/// for any other session. UX only: shop screens read their shop from here,
/// never from the URL, and firestore.rules check the same field on every
/// read and write.
final currentShopIdProvider = Provider<String?>(
  (ref) => ref.watch(
    currentAuthSessionProvider.select(
      (s) => s is SignedIn && s.role == UserRole.shopAdmin ? s.shopId : null,
    ),
  ),
);

/// Pure mapping, exposed for tests.
AuthSession sessionFromAsync(AsyncValue<AuthSession> value) {
  // Check the error first: after an error Riverpod may still carry the
  // previous value in `valueOrNull`.
  if (value.hasError && !value.isLoading) {
    return AuthSession.error(
      failure: SessionFailure.loadFailed,
      error: FirebaseErrorMapper.map(value.error!, value.stackTrace),
    );
  }
  return value.valueOrNull ?? const AuthSession.unknown();
}
