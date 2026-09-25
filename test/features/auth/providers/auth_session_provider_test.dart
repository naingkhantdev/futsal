import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/errors/app_exception.dart';
import 'package:futsal_booking/data/vos/auth_session.dart';
import 'package:futsal_booking/features/auth/providers/auth_session_provider.dart';

void main() {
  group('sessionFromAsync', () {
    test('loading → unknown (splash)', () {
      expect(
        sessionFromAsync(const AsyncLoading()),
        const AuthSession.unknown(),
      );
    });

    test('data passes through', () {
      const session =
          AuthSession.signedIn(uid: 'u', role: UserRole.customer, isActive: true);
      expect(sessionFromAsync(const AsyncData(session)), session);
    });

    test('stream error → SessionError(loadFailed) with a mapped error', () {
      final session = sessionFromAsync(
        AsyncError(
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
          StackTrace.empty,
        ),
      );
      expect(session, isA<SessionError>());
      final error = session as SessionError;
      expect(error.failure, SessionFailure.loadFailed);
      expect(error.error, isA<NetworkException>());
      expect(error.failure.canRetry, isTrue);
    });
  });
}
