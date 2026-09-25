import '../../data/vos/auth_session.dart';
import '../constants/app_constants.dart';
import 'app_routes.dart';

/// Pure redirect policy (design_system.md §8.3), evaluated in order.
///
/// Route guards are UX only: they stop users landing on screens they can't
/// use. Real enforcement is Firestore/Storage Security Rules — never rely
/// on this for authorization.
///
/// [isKnownRoute] is false when the location matched no route.
String? resolveRedirect({
  required AuthSession session,
  required Uri uri,
  required bool isKnownRoute,
}) {
  final path = uri.path;
  final from = uri.queryParameters[AppConstants.fromQueryParam];

  switch (session) {
    // 1. Session loading, missing profile being re-created, or resolution
    //    error → splash
    //    (carrying the original destination). Splash renders the error
    //    state with "Try again" / "Sign out" (design_system.md §8.3), so a
    //    failed resolution never leaves an endless spinner.
    case SessionUnknown() || SessionIncomplete() || SessionError():
      if (path == AppRoutes.splash) return null;
      return _withFrom(AppRoutes.splash, _originalTarget(uri, from, isKnownRoute));

    // 2. Signed out → auth routes only.
    case SignedOut():
      if (AppRoutes.authRoutes.contains(path)) return null;
      if (path == AppRoutes.splash) return _withFrom(AppRoutes.login, from);
      if (!isKnownRoute || path == AppRoutes.accountBlocked) {
        return AppRoutes.login;
      }
      return _withFrom(AppRoutes.login, uri.toString());

    case final SignedIn signedIn:
      // 3. Disabled account / shop admin without shop → blocked screen only.
      if (signedIn.isBlocked) {
        return path == AppRoutes.accountBlocked
            ? null
            : AppRoutes.accountBlocked;
      }

      final home = AppRoutes.homeFor(signedIn.role);
      final prefix = AppRoutes.prefixFor(signedIn.role);

      // 4. On splash / auth route / blocked screen → `from` (if it belongs to
      //    this role) else role home.
      if (path == AppRoutes.splash ||
          path == AppRoutes.accountBlocked ||
          AppRoutes.authRoutes.contains(path)) {
        final target = from == null ? null : Uri.tryParse(from);
        if (target != null && AppRoutes.isUnder(target.path, prefix)) {
          return from;
        }
        return home;
      }

      // 5. Another role's area → role home (no error screen, no flash).
      if (!AppRoutes.isUnder(path, prefix)) return home;

      // 6. Unknown path inside the role area → role home.
      if (!isKnownRoute) return home;

      return null;
  }
}

/// The destination worth returning to after the session resolves: the
/// current location for real screens, the existing `from` for system routes.
String? _originalTarget(Uri uri, String? from, bool isKnownRoute) {
  final path = uri.path;
  final isSystemRoute = path == AppRoutes.splash ||
      path == AppRoutes.accountBlocked ||
      AppRoutes.authRoutes.contains(path);
  if (isSystemRoute) return from;
  return isKnownRoute ? uri.toString() : null;
}

String _withFrom(String path, String? from) {
  if (from == null || from.isEmpty) return path;
  return Uri(
    path: path,
    queryParameters: {AppConstants.fromQueryParam: from},
  ).toString();
}
