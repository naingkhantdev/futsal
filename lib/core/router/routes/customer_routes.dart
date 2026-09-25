import 'package:go_router/go_router.dart';

import '../../../features/customer/booking/screens/booking_confirmation_screen.dart';
import '../../../features/customer/booking/screens/booking_review_screen.dart';
import '../../../features/customer/booking/screens/slot_selection_screen.dart';
import '../../../features/customer/bookings/screens/customer_booking_detail_screen.dart';
import '../../../features/customer/bookings/screens/customer_bookings_screen.dart';
import '../../../features/customer/home/screens/customer_home_screen.dart';
import '../../../features/customer/notifications/screens/customer_notifications_screen.dart';
import '../../../features/customer/profile/screens/change_password_screen.dart';
import '../../../features/customer/profile/screens/customer_profile_screen.dart';
import '../../../features/customer/profile/screens/edit_profile_screen.dart';
import '../../../features/customer/stadiums/screens/customer_explore_screen.dart';
import '../../../features/customer/stadiums/screens/stadium_details_screen.dart';
import '../../constants/domain_enums.dart';
import '../app_routes.dart';
import '../navigator_keys.dart';
import '../role_nav_shell.dart';

/// CUSTOMER scope. Branch order must match `NavDestinations.customer`.
final List<RouteBase> customerRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (_, __, shell) =>
        RoleNavShell(role: UserRole.customer, navigationShell: shell),
    branches: [
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.customerHome,
          builder: (_, __) => const CustomerHomeScreen(),
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.customerExplore,
          builder: (_, __) => const CustomerExploreScreen(),
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.customerBookings,
          builder: (_, __) => const CustomerBookingsScreen(),
          routes: [
            // Sibling of the detail route (not a child) so Back from the
            // confirmation returns to Bookings. Listed first to match first.
            GoRoute(
              path: ':${AppRoutes.bookingIdParam}/confirmation',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => BookingConfirmationScreen(
                bookingId: s.pathParameters[AppRoutes.bookingIdParam]!,
              ),
            ),
            GoRoute(
              path: ':${AppRoutes.bookingIdParam}',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, s) => CustomerBookingDetailScreen(
                bookingId: s.pathParameters[AppRoutes.bookingIdParam]!,
              ),
            ),
          ],
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.customerNotifications,
          builder: (_, __) => const CustomerNotificationsScreen(),
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: AppRoutes.customerProfile,
          builder: (_, __) => const CustomerProfileScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => const EditProfileScreen(),
            ),
            GoRoute(
              path: 'change-password',
              parentNavigatorKey: rootNavigatorKey,
              builder: (_, __) => const ChangePasswordScreen(),
            ),
          ],
        ),
      ]),
    ],
  ),
  // Stadium pages sit outside the tab paths, so they are top-level routes
  // (root navigator, nav hidden). Open them with `push` from Home/Explore.
  GoRoute(
    path: AppRoutes.customerStadiumPattern,
    builder: (_, s) => StadiumDetailsScreen(
      stadiumId: s.pathParameters[AppRoutes.stadiumIdParam]!,
    ),
    routes: [
      GoRoute(
        path: 'book',
        builder: (_, s) => SlotSelectionScreen(
          stadiumId: s.pathParameters[AppRoutes.stadiumIdParam]!,
          courtId: s.uri.queryParameters[AppRoutes.courtIdQuery],
          date: s.uri.queryParameters[AppRoutes.dateQuery],
        ),
        routes: [
          GoRoute(
            path: 'review',
            builder: (_, s) => BookingReviewScreen(
              stadiumId: s.pathParameters[AppRoutes.stadiumIdParam]!,
            ),
          ),
        ],
      ),
    ],
  ),
];
