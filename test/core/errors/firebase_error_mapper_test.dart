import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/errors/app_exception.dart';
import 'package:futsal_booking/core/errors/firebase_error_mapper.dart';

AppException _auth(String code) =>
    FirebaseErrorMapper.map(FirebaseAuthException(code: code, message: 'raw'));

void main() {
  group('auth error codes', () {
    final cases = <String, Type>{
      'invalid-credential': InvalidCredentialsException,
      'invalid-login-credentials': InvalidCredentialsException,
      'wrong-password': InvalidCredentialsException,
      'user-not-found': InvalidCredentialsException,
      'invalid-email': InvalidEmailException,
      'email-already-in-use': EmailAlreadyInUseException,
      'weak-password': WeakPasswordException,
      'too-many-requests': TooManyRequestsException,
      'user-disabled': AccountDisabledException,
      'network-request-failed': NetworkException,
      'requires-recent-login': AuthenticationException,
      'user-token-expired': AuthenticationException,
      'invalid-user-token': AuthenticationException,
      'user-mismatch': AuthenticationException,
      AuthErrorCodes.noCurrentUser: AuthenticationException,
      'something-new': ServerException,
    };

    for (final MapEntry(key: code, value: type) in cases.entries) {
      test('$code → $type', () {
        expect(_auth(code).runtimeType, type);
      });
    }

    test('never exposes the raw Firebase message', () {
      final e = _auth('wrong-password');
      expect(e.message, isNot(contains('raw')));
      expect(e.cause, isA<FirebaseAuthException>());
    });

    test('user-not-found and wrong-password are indistinguishable', () {
      expect(_auth('user-not-found').message, _auth('wrong-password').message);
    });
  });

  group('common Firebase codes', () {
    AppException fs(String code) => FirebaseErrorMapper.map(
          FirebaseException(plugin: 'cloud_firestore', code: code),
        );

    test('Firestore codes', () {
      expect(fs('permission-denied'), isA<PermissionDeniedException>());
      expect(fs('PERMISSION_DENIED'), isA<PermissionDeniedException>());
      expect(fs('unauthenticated'), isA<AuthenticationException>());
      expect(fs('unavailable'), isA<NetworkException>());
      expect(fs('not-found'), isA<NotFoundException>());
      expect(fs('internal'), isA<ServerException>());
    });
  });

  group('non-Firebase errors', () {
    test('AppException passes through unchanged', () {
      const original = IncorrectPasswordException();
      expect(identical(FirebaseErrorMapper.map(original), original), isTrue);
    });

    test('timeout → network', () {
      expect(
        FirebaseErrorMapper.map(TimeoutException('slow')),
        isA<NetworkException>(),
      );
    });

    test('anything else → unknown', () {
      expect(FirebaseErrorMapper.map(StateError('x')), isA<UnknownException>());
    });
  });
}
