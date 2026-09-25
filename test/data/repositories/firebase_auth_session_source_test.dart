import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/errors/app_exception.dart';
import 'package:futsal_booking/data/data_agents/auth_data_agent.dart';
import 'package:futsal_booking/data/data_agents/user_data_agent.dart';
import 'package:futsal_booking/data/repositories/firebase_auth_session_source.dart';
import 'package:futsal_booking/data/responses/auth_user_response.dart';
import 'package:futsal_booking/data/responses/user_response.dart';
import 'package:futsal_booking/data/vos/auth_session.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthDataAgent extends Mock implements AuthDataAgent {}

class _MockUserDataAgent extends Mock implements UserDataAgent {}

const _uid = 'u1';
const _authUser =
    AuthUserResponse(uid: _uid, email: 'a@b.co', displayName: 'Aung');
const _timeout = Duration(milliseconds: 120);
const _repairDelay = Duration(milliseconds: 20);

UserResponse _profile({
  String? role = 'customer',
  String? shopId,
  bool isActive = true,
}) =>
    UserResponse(
      id: _uid,
      name: 'Aung',
      email: 'a@b.co',
      isActive: isActive,
      role: role,
      shopId: shopId,
    );

/// Lets pending microtasks / zero-delay timers run.
Future<void> _settle() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late _MockAuthDataAgent auth;
  late _MockUserDataAgent users;
  late StreamController<AuthUserResponse?> authEvents;
  late StreamController<UserResponse?> profileEvents;
  late List<AuthSession> emitted;
  late StreamSubscription<AuthSession> sub;

  setUp(() {
    auth = _MockAuthDataAgent();
    users = _MockUserDataAgent();
    authEvents = StreamController<AuthUserResponse?>();
    profileEvents = StreamController<UserResponse?>();
    emitted = [];

    when(() => auth.watchAuthUser()).thenAnswer((_) => authEvents.stream);
    when(() => users.watchUser(any())).thenAnswer((_) => profileEvents.stream);
    when(() => users.createCustomerProfile(
          any(),
          email: any(named: 'email'),
          name: any(named: 'name'),
          phone: any(named: 'phone'),
        )).thenAnswer((_) async => true);

    final source = FirebaseAuthSessionSource(
      authDataAgent: auth,
      userDataAgent: users,
      resolveTimeout: _timeout,
      repairDelay: _repairDelay,
    );
    sub = source.watchSession().listen(emitted.add);
  });

  tearDown(() async {
    await sub.cancel();
    // Not awaited: close() on a single-subscription controller only
    // completes once a listener gets the done event, and some tests never
    // reach the profile subscription.
    unawaited(authEvents.close());
    unawaited(profileEvents.close());
  });

  test('no Firebase user → signed out', () async {
    authEvents.add(null);
    await _settle();
    expect(emitted, [const AuthSession.signedOut()]);
  });

  test('customer profile → signed in (role from users/{uid})', () async {
    authEvents.add(_authUser);
    profileEvents.add(_profile());
    await _settle();

    expect(emitted.last, const AuthSession.signedIn(
      uid: _uid,
      role: UserRole.customer,
      isActive: true,
    ));
  });

  test('profile isActive=false → signed in but blocked', () async {
    authEvents.add(_authUser);
    profileEvents.add(_profile(isActive: false));
    await _settle();

    final session = emitted.last;
    expect(session, isA<SignedIn>());
    expect((session as SignedIn).isBlocked, isTrue);
  });

  test('SHOP scope: shopId kept for shop admins', () async {
    authEvents.add(_authUser);
    profileEvents.add(_profile(role: 'shopAdmin', shopId: 'shopA'));
    await _settle();
    expect((emitted.last as SignedIn).shopId, 'shopA');
  });

  test('customer with a stray shopId → shopId ignored', () async {
    authEvents.add(_authUser);
    profileEvents.add(_profile(shopId: 'shopA'));
    await _settle();
    expect((emitted.last as SignedIn).shopId, isNull);
  });

  test('role change by a superadmin reaches the session live', () async {
    authEvents.add(_authUser);
    profileEvents.add(_profile());
    await _settle();
    profileEvents.add(_profile(role: 'shopAdmin', shopId: 'shopA'));
    await _settle();

    expect(emitted.last, const AuthSession.signedIn(
      uid: _uid,
      role: UserRole.shopAdmin,
      isActive: true,
      shopId: 'shopA',
    ));
  });

  test(
      'missing profile → incomplete, then the customer doc is re-created '
      'and the session signs in', () async {
    authEvents.add(_authUser);
    profileEvents.add(null);
    await _settle();
    expect(emitted.last, const AuthSession.incomplete(uid: _uid));

    await Future<void>.delayed(_repairDelay * 2);
    verify(() => users.createCustomerProfile(
          _uid,
          email: 'a@b.co',
          name: 'Aung',
          phone: null,
        )).called(1);

    profileEvents.add(_profile());
    await _settle();
    expect(emitted.last, isA<SignedIn>());
  });

  test('profile appears before the repair delay → no repair write', () async {
    authEvents.add(_authUser);
    profileEvents.add(null);
    await _settle();
    profileEvents.add(_profile());
    await Future<void>.delayed(_repairDelay * 2);

    verifyNever(() => users.createCustomerProfile(
          any(),
          email: any(named: 'email'),
          name: any(named: 'name'),
          phone: any(named: 'phone'),
        ));
    expect(emitted.last, isA<SignedIn>());
  });

  test('repair write fails → error(setupFailed), retryable', () async {
    when(() => users.createCustomerProfile(
          any(),
          email: any(named: 'email'),
          name: any(named: 'name'),
          phone: any(named: 'phone'),
        )).thenThrow(FirebaseException(
      plugin: 'cloud_firestore',
      code: 'permission-denied',
    ));
    authEvents.add(_authUser);
    profileEvents.add(null);
    await Future<void>.delayed(_repairDelay * 2);

    final session = emitted.last as SessionError;
    expect(session.failure, SessionFailure.setupFailed);
    expect(session.failure.canRetry, isTrue);
    expect(emitted.whereType<SignedIn>(), isEmpty);
  });

  test('nothing resolves within the timeout → error(timeout)', () async {
    authEvents.add(_authUser);
    await Future<void>.delayed(_timeout * 2);

    expect(emitted.last, const AuthSession.error(
      failure: SessionFailure.timeout,
      error: AccountSetupTimeoutException(),
      uid: _uid,
    ));
    expect(emitted.whereType<SignedIn>(), isEmpty);
  });

  test('unknown role string → error(unrecognizedRole), never a default',
      () async {
    authEvents.add(_authUser);
    profileEvents.add(_profile(role: 'admin'));
    await _settle();

    expect(emitted.last, const AuthSession.error(
      failure: SessionFailure.unrecognizedRole,
      error: UnauthorizedRoleException(),
      uid: _uid,
    ));
    expect(emitted.whereType<SignedIn>(), isEmpty);
  });

  test('missing role → error(unrecognizedRole)', () async {
    authEvents.add(_authUser);
    profileEvents.add(_profile(role: null));
    await _settle();
    expect((emitted.last as SessionError).failure,
        SessionFailure.unrecognizedRole);
  });

  test('user-disabled from the auth stream → error(accountDisabled)',
      () async {
    authEvents.addError(FirebaseAuthException(code: 'user-disabled'));
    await _settle();

    final session = emitted.last as SessionError;
    expect(session.failure, SessionFailure.accountDisabled);
    expect(session.error, isA<AccountDisabledException>());
    expect(session.failure.canRetry, isFalse);
  });

  test('sign-out after sign-in → signed out', () async {
    authEvents.add(_authUser);
    profileEvents.add(_profile());
    await _settle();
    authEvents.add(null);
    await _settle();
    expect(emitted.last, const AuthSession.signedOut());
  });
}
