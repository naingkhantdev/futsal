import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/errors/app_exception.dart';
import 'package:futsal_booking/data/data_agents/auth_data_agent.dart';
import 'package:futsal_booking/data/data_agents/user_data_agent.dart';
import 'package:futsal_booking/data/repositories/auth_repository_impl.dart';
import 'package:futsal_booking/data/responses/auth_user_response.dart';
import 'package:futsal_booking/data/responses/user_response.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthDataAgent extends Mock implements AuthDataAgent {}

class _MockUserDataAgent extends Mock implements UserDataAgent {}

const _user = AuthUserResponse(uid: 'u1', email: 'a@b.co');

UserResponse _profile({String? role = 'customer', bool isActive = true}) =>
    UserResponse(
      id: 'u1',
      name: 'Aung',
      email: 'a@b.co',
      phone: '+95 912345678',
      role: role,
      isActive: isActive,
    );

FirebaseAuthException _authError(String code) =>
    FirebaseAuthException(code: code, message: 'raw firebase text');

void main() {
  late _MockAuthDataAgent auth;
  late _MockUserDataAgent users;
  late AuthRepositoryImpl repo;

  void stubUpdateProfile() {
    when(() => users.updateProfile(
          any(),
          name: any(named: 'name'),
          phone: any(named: 'phone'),
        )).thenAnswer((_) async {});
  }

  setUp(() {
    auth = _MockAuthDataAgent();
    users = _MockUserDataAgent();
    repo = AuthRepositoryImpl(
      authDataAgent: auth,
      userDataAgent: users,
    );
  });

  group('signIn', () {
    test('trims the email and delegates', () async {
      when(() => auth.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => _user);

      await repo.signIn(email: '  a@b.co ', password: ' pw ');

      verify(() => auth.signIn(email: 'a@b.co', password: ' pw ')).called(1);
    });

    final cases = <String, Matcher>{
      'wrong-password': isA<InvalidCredentialsException>(),
      'invalid-credential': isA<InvalidCredentialsException>(),
      'user-disabled': isA<AccountDisabledException>(),
      'too-many-requests': isA<TooManyRequestsException>(),
      'network-request-failed': isA<NetworkException>(),
    };
    for (final MapEntry(key: code, value: matcher) in cases.entries) {
      test('$code is mapped to an AppException', () {
        when(() => auth.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(_authError(code));

        expect(
          repo.signIn(email: 'a@b.co', password: 'pw'),
          throwsA(matcher),
        );
      });
    }
  });

  group('register', () {
    void stubCreateProfile({bool created = true}) {
      when(() => users.createCustomerProfile(
            any(),
            email: any(named: 'email'),
            name: any(named: 'name'),
            phone: any(named: 'phone'),
          )).thenAnswer((_) async => created);
    }

    void verifyNoProfileWrites() {
      verifyNever(() => users.createCustomerProfile(
            any(),
            email: any(named: 'email'),
            name: any(named: 'name'),
            phone: any(named: 'phone'),
          ));
      verifyNever(() => users.updateProfile(
            any(),
            name: any(named: 'name'),
            phone: any(named: 'phone'),
          ));
    }

    setUp(() {
      when(() => auth.createAccount(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => _user);
      when(() => auth.updateDisplayName(any())).thenAnswer((_) async {});
      stubUpdateProfile();
    });

    test('creates the account, then the customer doc with trimmed input',
        () async {
      stubCreateProfile();

      await repo.register(
        name: '  Aung  ',
        email: ' a@b.co ',
        phone: '   ',
        password: 'password1',
      );

      verify(() => auth.createAccount(email: 'a@b.co', password: 'password1'))
          .called(1);
      verify(() => auth.updateDisplayName('Aung')).called(1);
      verify(() => users.createCustomerProfile(
            'u1',
            email: 'a@b.co',
            name: 'Aung',
            phone: null,
          )).called(1);
      verifyNever(() => users.updateProfile(
            any(),
            name: any(named: 'name'),
            phone: any(named: 'phone'),
          ));
    });

    test('doc already re-created by the session → name/phone updated',
        () async {
      stubCreateProfile(created: false);

      await repo.register(
        name: 'Aung',
        email: 'a@b.co',
        phone: null,
        password: 'password1',
      );

      verify(() => users.updateProfile('u1', name: 'Aung', phone: null))
          .called(1);
    });

    test('display-name failure does not stop the profile write', () async {
      when(() => auth.updateDisplayName(any()))
          .thenThrow(_authError('network-request-failed'));
      stubCreateProfile();

      await expectLater(
        repo.register(
          name: 'Aung',
          email: 'a@b.co',
          phone: null,
          password: 'password1',
        ),
        completes,
      );
      verify(() => users.createCustomerProfile(
            'u1',
            email: any(named: 'email'),
            name: any(named: 'name'),
            phone: any(named: 'phone'),
          )).called(1);
    });

    test('profile write rejected → mapped AppException is thrown', () async {
      when(() => users.createCustomerProfile(
            any(),
            email: any(named: 'email'),
            name: any(named: 'name'),
            phone: any(named: 'phone'),
          )).thenThrow(
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      );

      await expectLater(
        repo.register(
          name: 'Aung',
          email: 'a@b.co',
          phone: null,
          password: 'password1',
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('email-already-in-use → EmailAlreadyInUseException, no profile write',
        () async {
      when(() => auth.createAccount(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(_authError('email-already-in-use'));

      await expectLater(
        repo.register(
          name: 'Aung',
          email: 'a@b.co',
          phone: null,
          password: 'password1',
        ),
        throwsA(isA<EmailAlreadyInUseException>()),
      );
      verifyNoProfileWrites();
    });

    test('weak-password → WeakPasswordException', () {
      when(() => auth.createAccount(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(_authError('weak-password'));

      expect(
        repo.register(
          name: 'Aung',
          email: 'a@b.co',
          phone: null,
          password: 'short',
        ),
        throwsA(isA<WeakPasswordException>()),
      );
    });
  });

  test('sendPasswordReset trims the email', () async {
    when(() => auth.sendPasswordReset(any())).thenAnswer((_) async {});
    await repo.sendPasswordReset(' a@b.co ');
    verify(() => auth.sendPasswordReset('a@b.co')).called(1);
  });

  test('signOut maps failures', () {
    when(() => auth.signOut()).thenThrow(_authError('network-request-failed'));
    expect(repo.signOut(), throwsA(isA<NetworkException>()));
  });

  group('changePassword', () {
    test('re-authenticates, then updates the password', () async {
      when(() => auth.reauthenticate(any())).thenAnswer((_) async {});
      when(() => auth.updatePassword(any())).thenAnswer((_) async {});

      await repo.changePassword(
        currentPassword: 'oldpass12',
        newPassword: 'newpass12',
      );

      verifyInOrder([
        () => auth.reauthenticate('oldpass12'),
        () => auth.updatePassword('newpass12'),
      ]);
    });

    for (final code in ['wrong-password', 'invalid-credential']) {
      test('$code on re-auth → IncorrectPasswordException', () async {
        when(() => auth.reauthenticate(any())).thenThrow(_authError(code));

        await expectLater(
          repo.changePassword(
            currentPassword: 'nope',
            newPassword: 'newpass12',
          ),
          throwsA(isA<IncorrectPasswordException>()),
        );
        verifyNever(() => auth.updatePassword(any()));
      });
    }

    test('too-many-requests on re-auth stays TooManyRequests', () {
      when(() => auth.reauthenticate(any()))
          .thenThrow(_authError('too-many-requests'));
      expect(
        repo.changePassword(currentPassword: 'x', newPassword: 'newpass12'),
        throwsA(isA<TooManyRequestsException>()),
      );
    });

    test('weak-password on update → WeakPasswordException', () {
      when(() => auth.reauthenticate(any())).thenAnswer((_) async {});
      when(() => auth.updatePassword(any()))
          .thenThrow(_authError('weak-password'));
      expect(
        repo.changePassword(currentPassword: 'x', newPassword: 'newpass12'),
        throwsA(isA<WeakPasswordException>()),
      );
    });
  });

  group('updateProfile', () {
    test('writes trimmed name + normalized phone for the current user',
        () async {
      when(() => auth.currentUser).thenReturn(_user);
      when(() => auth.updateDisplayName(any())).thenAnswer((_) async {});
      stubUpdateProfile();

      await repo.updateProfile(name: ' Aung ', phone: ' ');

      verify(() => users.updateProfile('u1', name: 'Aung', phone: null))
          .called(1);
    });

    test('display-name sync failure does not fail the save', () async {
      when(() => auth.currentUser).thenReturn(_user);
      when(() => auth.updateDisplayName(any()))
          .thenThrow(_authError('network-request-failed'));
      stubUpdateProfile();

      await expectLater(
        repo.updateProfile(name: 'Aung', phone: '0912345678'),
        completes,
      );
    });

    test('no signed-in user → AuthenticationException', () {
      when(() => auth.currentUser).thenReturn(null);
      expect(
        repo.updateProfile(name: 'Aung', phone: null),
        throwsA(isA<AuthenticationException>()),
      );
    });

    test('rules rejection → PermissionDeniedException', () {
      when(() => auth.currentUser).thenReturn(_user);
      when(() => users.updateProfile(
            any(),
            name: any(named: 'name'),
            phone: any(named: 'phone'),
          )).thenThrow(
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      );
      expect(
        repo.updateProfile(name: 'Aung', phone: null),
        throwsA(isA<PermissionDeniedException>()),
      );
    });
  });

  group('watchProfile', () {
    test('maps Response → VO (role parsed, unknown role → null)', () async {
      when(() => users.watchUser('u1')).thenAnswer(
        (_) => Stream.fromIterable([
          _profile(),
          _profile(role: 'admin', isActive: false),
          null,
        ]),
      );

      final values = await repo.watchProfile('u1').toList();

      expect(values[0]?.role, UserRole.customer);
      expect(values[0]?.name, 'Aung');
      expect(values[0]?.isActive, isTrue);
      expect(values[1]?.role, isNull);
      expect(values[1]?.isActive, isFalse);
      expect(values[2], isNull);
    });

    test('stream errors are mapped to AppException', () {
      when(() => users.watchUser('u1')).thenAnswer(
        (_) => Stream<UserResponse?>.error(
          FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
        ),
      );
      expect(
        repo.watchProfile('u1'),
        emitsError(isA<PermissionDeniedException>()),
      );
    });
  });
}
