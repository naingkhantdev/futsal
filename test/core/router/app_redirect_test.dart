import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/app_constants.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/errors/app_exception.dart';
import 'package:futsal_booking/core/router/app_redirect.dart';
import 'package:futsal_booking/core/router/app_routes.dart';
import 'package:futsal_booking/data/vos/auth_session.dart';

String? _redirect(AuthSession session, String location, {bool known = true}) =>
    resolveRedirect(
      session: session,
      uri: Uri.parse(location),
      isKnownRoute: known,
    );

String _withFrom(String path, String from) => Uri(
      path: path,
      queryParameters: {AppConstants.fromQueryParam: from},
    ).toString();

const _customer =
    AuthSession.signedIn(uid: 'c1', role: UserRole.customer, isActive: true);
const _shopAdmin = AuthSession.signedIn(
  uid: 's1',
  role: UserRole.shopAdmin,
  isActive: true,
  shopId: 'shopA',
);
const _superadmin =
    AuthSession.signedIn(uid: 'p1', role: UserRole.superadmin, isActive: true);

void main() {
  const customerBookings = AppRoutes.customerBookings;

  group('resolving states (unknown / incomplete / error) → splash', () {
    final resolving = <String, AuthSession>{
      'unknown': const AuthSession.unknown(),
      'incomplete': const AuthSession.incomplete(uid: 'u1'),
      'error(timeout)': const AuthSession.error(
        failure: SessionFailure.timeout,
        error: AccountSetupTimeoutException(),
        uid: 'u1',
      ),
      'error(unrecognizedRole)': const AuthSession.error(
        failure: SessionFailure.unrecognizedRole,
        error: UnauthorizedRoleException(),
        uid: 'u1',
      ),
      'error(loadFailed, no uid)': const AuthSession.error(
        failure: SessionFailure.loadFailed,
        error: NetworkException(),
      ),
    };

    for (final MapEntry(key: name, value: session) in resolving.entries) {
      group(name, () {
        test('stays on splash', () {
          expect(_redirect(session, AppRoutes.splash), isNull);
          expect(
            _redirect(session, _withFrom(AppRoutes.splash, customerBookings)),
            isNull,
          );
        });

        test('protected route → splash carrying from', () {
          expect(
            _redirect(session, customerBookings),
            _withFrom(AppRoutes.splash, customerBookings),
          );
          expect(
            _redirect(session, AppRoutes.superadminDashboard),
            _withFrom(AppRoutes.splash, AppRoutes.superadminDashboard),
          );
        });

        test('auth routes → splash, keeping an existing from', () {
          expect(_redirect(session, AppRoutes.login), AppRoutes.splash);
          expect(_redirect(session, AppRoutes.register), AppRoutes.splash);
          expect(
            _redirect(session, AppRoutes.forgotPassword),
            AppRoutes.splash,
          );
          expect(
            _redirect(session, _withFrom(AppRoutes.login, customerBookings)),
            _withFrom(AppRoutes.splash, customerBookings),
          );
        });

        test('account-blocked and unknown paths → bare splash', () {
          expect(
            _redirect(session, AppRoutes.accountBlocked),
            AppRoutes.splash,
          );
          expect(
            _redirect(session, '/nowhere', known: false),
            AppRoutes.splash,
          );
        });
      });
    }
  });

  group('signed out', () {
    const session = AuthSession.signedOut();

    test('auth routes allowed', () {
      for (final path in AppRoutes.authRoutes) {
        expect(_redirect(session, path), isNull, reason: path);
      }
    });

    test('splash → login (keeping from)', () {
      expect(_redirect(session, AppRoutes.splash), AppRoutes.login);
      expect(
        _redirect(session, _withFrom(AppRoutes.splash, customerBookings)),
        _withFrom(AppRoutes.login, customerBookings),
      );
    });

    test('protected route → login?from', () {
      expect(
        _redirect(session, customerBookings),
        _withFrom(AppRoutes.login, customerBookings),
      );
      expect(
        _redirect(session, AppRoutes.shopAdminDashboard),
        _withFrom(AppRoutes.login, AppRoutes.shopAdminDashboard),
      );
    });

    test('account-blocked and unknown paths → bare login', () {
      expect(_redirect(session, AppRoutes.accountBlocked), AppRoutes.login);
      expect(
        _redirect(session, '/nowhere', known: false),
        AppRoutes.login,
      );
    });
  });

  group('signed in, blocked', () {
    final blocked = <String, AuthSession>{
      'disabled customer': const AuthSession.signedIn(
        uid: 'c1',
        role: UserRole.customer,
        isActive: false,
      ),
      'disabled superadmin': const AuthSession.signedIn(
        uid: 'p1',
        role: UserRole.superadmin,
        isActive: false,
      ),
      'shop admin without shopId': const AuthSession.signedIn(
        uid: 's1',
        role: UserRole.shopAdmin,
        isActive: true,
      ),
      'shop admin with empty shopId': const AuthSession.signedIn(
        uid: 's1',
        role: UserRole.shopAdmin,
        isActive: true,
        shopId: '',
      ),
    };

    for (final MapEntry(key: name, value: session) in blocked.entries) {
      test('$name → only /account-blocked', () {
        expect(_redirect(session, AppRoutes.accountBlocked), isNull);
        for (final path in [
          AppRoutes.splash,
          AppRoutes.login,
          customerBookings,
          AppRoutes.shopAdminDashboard,
          AppRoutes.superadminDashboard,
        ]) {
          expect(
            _redirect(session, path),
            AppRoutes.accountBlocked,
            reason: path,
          );
        }
        expect(
          _redirect(session, '/nowhere', known: false),
          AppRoutes.accountBlocked,
        );
      });
    }
  });

  group('signed in, active', () {
    test('splash / auth routes / blocked → role home', () {
      for (final path in [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
        AppRoutes.accountBlocked,
      ]) {
        expect(_redirect(_customer, path), AppRoutes.customerHome,
            reason: path);
        expect(_redirect(_shopAdmin, path), AppRoutes.shopAdminDashboard,
            reason: path);
        expect(_redirect(_superadmin, path), AppRoutes.superadminDashboard,
            reason: path);
      }
    });

    test('from is honoured only inside the role prefix', () {
      expect(
        _redirect(_customer, _withFrom(AppRoutes.splash, customerBookings)),
        customerBookings,
      );
      expect(
        _redirect(
          _customer,
          _withFrom(AppRoutes.splash, AppRoutes.superadminDashboard),
        ),
        AppRoutes.customerHome,
      );
      expect(
        _redirect(
          _shopAdmin,
          _withFrom(AppRoutes.login, AppRoutes.shopAdminBookings),
        ),
        AppRoutes.shopAdminBookings,
      );
    });

    test("another role's area → own home", () {
      expect(_redirect(_customer, AppRoutes.shopAdminDashboard),
          AppRoutes.customerHome);
      expect(_redirect(_customer, AppRoutes.superadminDashboard),
          AppRoutes.customerHome);
      expect(_redirect(_shopAdmin, customerBookings),
          AppRoutes.shopAdminDashboard);
      expect(_redirect(_shopAdmin, AppRoutes.superadminShops),
          AppRoutes.shopAdminDashboard);
      expect(_redirect(_superadmin, customerBookings),
          AppRoutes.superadminDashboard);
      expect(_redirect(_superadmin, AppRoutes.shopAdminDashboard),
          AppRoutes.superadminDashboard);
    });

    test('own area passes through', () {
      expect(_redirect(_customer, customerBookings), isNull);
      expect(_redirect(_customer, AppRoutes.customerProfileEdit), isNull);
      expect(_redirect(_shopAdmin, AppRoutes.shopAdminStadiums), isNull);
      expect(_redirect(_superadmin, AppRoutes.superadminShops), isNull);
    });

    test('unknown path → role home', () {
      expect(_redirect(_customer, '/customer/nope', known: false),
          AppRoutes.customerHome);
      expect(_redirect(_superadmin, '/nowhere', known: false),
          AppRoutes.superadminDashboard);
    });
  });
}
