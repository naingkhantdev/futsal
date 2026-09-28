import 'package:go_router/go_router.dart';

import '../../../features/shop_admin/blacklist/screens/blacklist_screen.dart';
import '../../../features/shop_admin/blocked_slots/screens/blocked_slot_form_screen.dart';
import '../../../features/shop_admin/blocked_slots/screens/blocked_slots_screen.dart';
import '../../../features/shop_admin/bookings/screens/shop_admin_booking_detail_screen.dart';
import '../../../features/shop_admin/bookings/screens/shop_admin_bookings_screen.dart';
import '../../../features/shop_admin/courts/screens/court_detail_screen.dart';
import '../../../features/shop_admin/courts/screens/court_form_screen.dart';
import '../../../features/shop_admin/customers/screens/shop_admin_customer_detail_screen.dart';
import '../../../features/shop_admin/customers/screens/shop_admin_customers_screen.dart';
import '../../../features/shop_admin/dashboard/screens/shop_admin_dashboard_screen.dart';
import '../../../features/shop_admin/settings/screens/shop_admin_settings_screen.dart';
import '../../../features/shop_admin/shop_profile/screens/shop_profile_screen.dart';
import '../../../features/shop_admin/stadiums/screens/shop_admin_stadium_detail_screen.dart';
import '../../../features/shop_admin/stadiums/screens/shop_admin_stadiums_screen.dart';
import '../../../features/shop_admin/stadiums/screens/stadium_form_screen.dart';
import '../../constants/domain_enums.dart';
import '../app_routes.dart';
import '../navigator_keys.dart';
import '../role_nav_shell.dart';

/// SHOP scope. The shop is always the signed-in admin's `users/{uid}.shopId` —
/// never taken from the URL. Branch order must match
/// `NavDestinations.shopAdmin`.
final List<RouteBase> shopAdminRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (_, __, shell) =>
        RoleNavShell(role: UserRole.shopAdmin, navigationShell: shell),
    branches: [
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.shopAdminDashboard,
          builder: (_, __) => const ShopAdminDashboardScreen(),
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.shopAdminBookings,
          builder: (_, __) => const ShopAdminBookingsScreen(),
          routes: [
            GoRoute(
              path: ':${AppRoutes.bookingIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => ShopAdminBookingDetailScreen(
                bookingId: s.pathParameters[AppRoutes.bookingIdParam]!,
              ),
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.shopAdminStadiums,
          builder: (_, s) => ShopAdminStadiumsScreen(
            showCourts: s.uri.queryParameters[AppRoutes.viewQuery] ==
                AppRoutes.viewCourts,
          ),
          routes: [
            // 'new' must precede ':stadiumId'.
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => const StadiumFormScreen(),
            ),
            GoRoute(
              path: ':${AppRoutes.stadiumIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => ShopAdminStadiumDetailScreen(
                stadiumId: s.pathParameters[AppRoutes.stadiumIdParam]!,
              ),
              routes: _stadiumChildRoutes,
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.shopAdminCustomers,
          builder: (_, __) => const ShopAdminCustomersScreen(),
          routes: [
            GoRoute(
              path: ':${AppRoutes.customerIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => ShopAdminCustomerDetailScreen(
                customerId: s.pathParameters[AppRoutes.customerIdParam]!,
              ),
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.shopAdminSettings,
          builder: (_, __) => const ShopAdminSettingsScreen(),
          routes: [
            GoRoute(
              path: 'shop-profile',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => const ShopProfileScreen(),
            ),
            GoRoute(
              path: 'blacklist',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => const BlacklistScreen(),
            ),
          ],
        ),
      ]),
    ],
  ),
  // Reached from Bookings ("Block time") and court detail; not a tab.
  GoRoute(
    path: AppRoutes.shopAdminBlockedSlots,
    builder: (_, __) => const BlockedSlotsScreen(),
    routes: [
      GoRoute(
        path: 'new',
        builder: (_, s) => BlockedSlotFormScreen(
          stadiumId: s.uri.queryParameters[AppRoutes.stadiumIdQuery],
          courtId: s.uri.queryParameters[AppRoutes.courtIdQuery],
          date: s.uri.queryParameters[AppRoutes.dateQuery],
        ),
      ),
    ],
  ),
];

final List<RouteBase> _stadiumChildRoutes = [
  GoRoute(
    path: 'edit',
    parentNavigatorKey: rootNavigatorKey,
    builder: (_, s) => StadiumFormScreen(
      stadiumId: s.pathParameters[AppRoutes.stadiumIdParam],
    ),
  ),
  // 'courts/new' must precede 'courts/:courtId'.
  GoRoute(
    path: 'courts/new',
    parentNavigatorKey: rootNavigatorKey,
    builder: (_, s) => CourtFormScreen(
      stadiumId: s.pathParameters[AppRoutes.stadiumIdParam]!,
    ),
  ),
  GoRoute(
    path: 'courts/:${AppRoutes.courtIdParam}',
    parentNavigatorKey: rootNavigatorKey,
    builder: (_, s) => CourtDetailScreen(
      stadiumId: s.pathParameters[AppRoutes.stadiumIdParam]!,
      courtId: s.pathParameters[AppRoutes.courtIdParam]!,
    ),
    routes: [
      GoRoute(
        path: 'edit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, s) => CourtFormScreen(
          stadiumId: s.pathParameters[AppRoutes.stadiumIdParam]!,
          courtId: s.pathParameters[AppRoutes.courtIdParam],
        ),
      ),
    ],
  ),
];
