import 'package:go_router/go_router.dart';

import '../../../features/shared/widgets/app_tours.dart';
import '../../../features/superadmin/announcements/screens/announcements_screen.dart';
import '../../../features/superadmin/announcements/screens/new_announcement_screen.dart';
import '../../../features/superadmin/bookings/screens/superadmin_booking_detail_screen.dart';
import '../../../features/superadmin/bookings/screens/superadmin_bookings_screen.dart';
import '../../../features/superadmin/customers/screens/superadmin_customer_detail_screen.dart';
import '../../../features/superadmin/customers/screens/superadmin_customers_screen.dart';
import '../../../features/superadmin/dashboard/screens/superadmin_dashboard_screen.dart';
import '../../../features/superadmin/settings/screens/superadmin_settings_screen.dart';
import '../../../features/superadmin/shop_admins/screens/invite_shop_admin_screen.dart';
import '../../../features/superadmin/shop_admins/screens/shop_admins_screen.dart';
import '../../../features/superadmin/shops/screens/shop_detail_screen.dart';
import '../../../features/superadmin/shops/screens/shop_form_screen.dart';
import '../../../features/superadmin/shops/screens/shops_screen.dart';
import '../../constants/domain_enums.dart';
import '../app_routes.dart';
import '../navigator_keys.dart';
import '../role_nav_shell.dart';

/// PLATFORM scope. Branch order must match `NavDestinations.superadmin`.
final List<RouteBase> superadminRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (_, __, shell) =>
        RoleNavShell(role: UserRole.superadmin, navigationShell: shell),
    branches: [
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminDashboard,
          builder: (_, __) => AppTours.superadminDashboard.wrap(
            const SuperadminDashboardScreen(),
          ),
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminShops,
          builder: (_, s) => AppTours.superadminShops.wrap(
            ShopsScreen(
              showOnboarding: s.uri.queryParameters[AppRoutes.tabQuery] ==
                  AppRoutes.tabOnboarding,
            ),
          ),
          routes: [
            // 'new' must precede ':shopId'.
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => AppTours.superadminShopForm.wrap(
                const ShopFormScreen(),
              ),
            ),
            GoRoute(
              path: ':${AppRoutes.shopIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => AppTours.superadminShopDetail.wrap(
                ShopDetailScreen(
                  shopId: s.pathParameters[AppRoutes.shopIdParam]!,
                ),
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, s) => AppTours.superadminShopForm.wrap(
                    ShopFormScreen(
                      shopId: s.pathParameters[AppRoutes.shopIdParam],
                    ),
                  ),
                ),
                GoRoute(
                  path: 'admins',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, s) => AppTours.superadminShopAdmins.wrap(
                    ShopAdminsScreen(
                      shopId: s.pathParameters[AppRoutes.shopIdParam]!,
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'invite',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, s) =>
                          AppTours.superadminInviteShopAdmin.wrap(
                        InviteShopAdminScreen(
                          shopId: s.pathParameters[AppRoutes.shopIdParam]!,
                        ),
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
          builder: (_, __) => AppTours.superadminBookings.wrap(
            const SuperadminBookingsScreen(),
          ),
          routes: [
            GoRoute(
              path: ':${AppRoutes.bookingIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => AppTours.superadminBookingDetail.wrap(
                SuperadminBookingDetailScreen(
                  bookingId: s.pathParameters[AppRoutes.bookingIdParam]!,
                ),
              ),
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminCustomers,
          builder: (_, __) => AppTours.superadminCustomers.wrap(
            const SuperadminCustomersScreen(),
          ),
          routes: [
            GoRoute(
              path: ':${AppRoutes.customerIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => AppTours.superadminCustomerDetail.wrap(
                SuperadminCustomerDetailScreen(
                  customerId: s.pathParameters[AppRoutes.customerIdParam]!,
                ),
              ),
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.superadminSettings,
          builder: (_, __) => AppTours.superadminSettings.wrap(
            const SuperadminSettingsScreen(),
          ),
          routes: [
            GoRoute(
              path: 'announcements',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => AppTours.superadminAnnouncements.wrap(
                const AnnouncementsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => AppTours.superadminNewAnnouncement.wrap(
                    const NewAnnouncementScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    ],
  ),
];
