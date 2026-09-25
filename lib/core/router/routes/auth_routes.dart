import 'package:go_router/go_router.dart';

import '../../../features/auth/screens/account_blocked_screen.dart';
import '../../../features/auth/screens/forgot_password_screen.dart';
import '../../../features/auth/screens/login_screen.dart';
import '../../../features/auth/screens/register_screen.dart';
import '../../../features/auth/screens/splash_screen.dart';
import '../app_routes.dart';

/// Top-level auth / system routes (no shell).
final List<RouteBase> authRoutes = [
  GoRoute(
    path: AppRoutes.splash,
    builder: (_, __) => const SplashScreen(),
  ),
  GoRoute(
    path: AppRoutes.login,
    builder: (_, __) => const LoginScreen(),
  ),
  GoRoute(
    path: AppRoutes.register,
    builder: (_, __) => const RegisterScreen(),
  ),
  GoRoute(
    path: AppRoutes.forgotPassword,
    builder: (_, __) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: AppRoutes.accountBlocked,
    builder: (_, __) => const AccountBlockedScreen(),
  ),
];
