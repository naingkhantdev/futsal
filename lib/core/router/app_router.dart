import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/vos/auth_session.dart';
import '../../features/auth/providers/auth_session_provider.dart';
import '../errors/app_exception.dart';
import '../widgets/error_view.dart';
import 'app_redirect.dart';
import 'app_routes.dart';
import 'navigator_keys.dart';
import 'routes/auth_routes.dart';
import 'routes/customer_routes.dart';
import 'routes/shop_admin_routes.dart';
import 'routes/superadmin_routes.dart';

/// App router.
///
/// Route guards here are UX only (keep users out of screens they can't
/// use). Real authorization is enforced by Firestore/Storage Security Rules
/// and Cloud Functions, which never trust client role, shopId or routes.
final appRouterProvider = Provider<GoRouter>((ref) {
  // Mirrors the session provider into a Listenable so GoRouter re-runs the
  // redirect whenever the session changes, without rebuilding the router.
  final session = ValueNotifier<AuthSession>(const AuthSession.unknown());
  ref.listen<AuthSession>(
    // Loading → unknown, stream errors → SessionError (see
    // `sessionFromAsync`); both land on splash, which shows the error view.
    currentAuthSessionProvider,
    (_, next) => session.value = next,
    fireImmediately: true,
  );

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: session,
    redirect: (context, state) => resolveRedirect(
      session: session.value,
      uri: state.uri,
      // No matched route → unknown path (handled by redirect rule 6).
      isKnownRoute: state.topRoute != null,
    ),
    routes: [
      ...authRoutes,
      ...customerRoutes,
      ...shopAdminRoutes,
      ...superadminRoutes,
    ],
    // Fallback only; the redirect normally sends unknown paths home/login.
    errorBuilder: (_, __) => const Scaffold(
      body: ErrorView(error: NotFoundException()),
    ),
  );

  ref.onDispose(() {
    router.dispose();
    session.dispose();
  });
  return router;
});
