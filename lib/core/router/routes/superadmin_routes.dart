import 'package:go_router/go_router.dart';

import '../../../features/shop_admin/stadiums/screens/location_picker_screen.dart';
import '../../../features/superadmin/announcements/screens/announcements_screen.dart';
import '../../../features/superadmin/announcements/screens/new_announcement_screen.dart';
import '../../../features/superadmin/bookings/screens/superadmin_booking_detail_screen.dart';
import '../../../features/superadmin/bookings/screens/superadmin_bookings_screen.dart';
import '../../../features/superadmin/customers/screens/superadmin_customer_detail_screen.dart';
import '../../../features/superadmin/customers/screens/superadmin_customers_screen.dart';
import '../../../features/superadmin/dashboard/screens/superadmin_dashboard_screen.dart';
import '../../../features/superadmin/settings/screens/superadmin_settings_screen.dart';
import '../../../features/superadmin/shell/widgets/superadmin_shell.dart';
import '../../../features/superadmin/shop_admins/screens/invite_shop_admin_screen.dart';
import '../../../features/superadmin/shop_admins/screens/shop_admins_screen.dart';
import '../../../features/superadmin/shops/screens/shop_detail_screen.dart';
import '../../../features/superadmin/shops/screens/shop_form_screen.dart';
import '../../../features/superadmin/shops/screens/shops_screen.dart';
import '../../utils/geo_location.dart';
import '../app_routes.dart';
import '../navigator_keys.dart';

/// PLATFORM scope. Branch order must match `NavDestinations.superadmin`.
final List<RouteBase> superadminRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (_, __, shell) => SuperadminShell(navigationShell: shell),
    branches: [
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminDashboard,
          builder: (_, __) => const SuperadminDashboardScreen(),
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminShops,
          builder: (_, s) => ShopsScreen(
            showOnboarding: s.uri.queryParameters[AppRoutes.tabQuery] ==
                AppRoutes.tabOnboarding,
          ),
          routes: [
            // 'new' and 'pick-location' must precede ':shopId'.
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => const ShopFormScreen(),
            ),
            GoRoute(
              path: 'pick-location',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) =>
                  LocationPickerScreen(initial: s.extra as MapPoint?),
            ),
            GoRoute(
              path: ':${AppRoutes.shopIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => ShopDetailScreen(
                shopId: s.pathParameters[AppRoutes.shopIdParam]!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, s) => ShopFormScreen(
                    shopId: s.pathParameters[AppRoutes.shopIdParam],
                  ),
                ),
                GoRoute(
                  path: 'admins',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, s) => ShopAdminsScreen(
                    shopId: s.pathParameters[AppRoutes.shopIdParam]!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'invite',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, s) => InviteShopAdminScreen(
                        shopId: s.pathParameters[AppRoutes.shopIdParam]!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminBookings,
          builder: (_, __) => const SuperadminBookingsScreen(),
          routes: [
            GoRoute(
              path: ':${AppRoutes.bookingIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => SuperadminBookingDetailScreen(
                bookingId: s.pathParameters[AppRoutes.bookingIdParam]!,
              ),
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminCustomers,
          builder: (_, __) => const SuperadminCustomersScreen(),
          routes: [
            GoRoute(
              path: ':${AppRoutes.customerIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => SuperadminCustomerDetailScreen(
                customerId: s.pathParameters[AppRoutes.customerIdParam]!,
              ),
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminSettings,
          builder: (_, __) => const SuperadminSettingsScreen(),
          routes: [
            GoRoute(
              path: 'announcements',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => const AnnouncementsScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const NewAnnouncementScreen(),
                ),
              ],
            ),
          ],
        ),
      ]),
    ],
  ),
];
