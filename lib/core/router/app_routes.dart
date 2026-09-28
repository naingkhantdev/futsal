import '../constants/domain_enums.dart';

/// Route path constants and builders (design_system.md §8.2).
///
/// Segments are kebab-case, path params camelCase. Pass IDs in paths, never
/// objects in `extra`, so routes survive restoration and deep links.
abstract final class AppRoutes {
  // Path parameter names
  static const String stadiumIdParam = 'stadiumId';
  static const String courtIdParam = 'courtId';
  static const String bookingIdParam = 'bookingId';
  static const String customerIdParam = 'customerId';
  static const String shopIdParam = 'shopId';

  // Query parameter names
  static const String dateQuery = 'date';
  static const String courtIdQuery = 'courtId';
  static const String stadiumIdQuery = 'stadiumId';
  static const String viewQuery = 'view';
  static const String viewCourts = 'courts';
  static const String tabQuery = 'tab';
  static const String tabOnboarding = 'onboarding';

  // Auth / system
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String accountBlocked = '/account-blocked';

  /// Routes reachable while signed out.
  static const Set<String> authRoutes = {login, register, forgotPassword};

  // Role prefixes
  static const String customerPrefix = '/customer';
  static const String shopAdminPrefix = '/shop-admin';
  static const String superadminPrefix = '/superadmin';

  // Customer
  static const String customerHome = '/customer/home';
  static const String customerExplore = '/customer/explore';
  static const String customerBookings = '/customer/bookings';
  static const String customerNotifications = '/customer/notifications';
  static const String customerProfile = '/customer/profile';
  static const String customerStadiumPattern = '/customer/stadiums/:stadiumId';
  static const String customerProfileEdit = '/customer/profile/edit';
  static const String customerChangePassword =
      '/customer/profile/change-password';

  static String customerStadium(String stadiumId) =>
      '/customer/stadiums/$stadiumId';
  static String customerBookStadium(String stadiumId) =>
      '/customer/stadiums/$stadiumId/book';
  static String customerBookingReview(String stadiumId) =>
      '/customer/stadiums/$stadiumId/book/review';
  static String customerBooking(String bookingId) =>
      '/customer/bookings/$bookingId';
  static String customerBookingConfirmation(String bookingId) =>
      '/customer/bookings/$bookingId/confirmation';

  // Shop admin
  static const String shopAdminDashboard = '/shop-admin/dashboard';
  static const String shopAdminBookings = '/shop-admin/bookings';
  static const String shopAdminStadiums = '/shop-admin/stadiums';
  static const String shopAdminCustomers = '/shop-admin/customers';
  static const String shopAdminSettings = '/shop-admin/settings';
  static const String shopAdminStadiumNew = '/shop-admin/stadiums/new';
  static const String shopAdminBlockedSlots = '/shop-admin/blocked-slots';
  static const String shopAdminBlockedSlotNew = '/shop-admin/blocked-slots/new';
  static const String shopAdminShopProfile = '/shop-admin/settings/shop-profile';
  static const String shopAdminBlacklist = '/shop-admin/settings/blacklist';

  static String shopAdminBooking(String bookingId) =>
      '/shop-admin/bookings/$bookingId';
  static String shopAdminStadium(String stadiumId) =>
      '/shop-admin/stadiums/$stadiumId';
  static String shopAdminStadiumEdit(String stadiumId) =>
      '/shop-admin/stadiums/$stadiumId/edit';
  static String shopAdminCourtNew(String stadiumId) =>
      '/shop-admin/stadiums/$stadiumId/courts/new';
  static String shopAdminCourt(String stadiumId, String courtId) =>
      '/shop-admin/stadiums/$stadiumId/courts/$courtId';
  static String shopAdminCourtEdit(String stadiumId, String courtId) =>
      '/shop-admin/stadiums/$stadiumId/courts/$courtId/edit';
  static String shopAdminCustomer(String customerId) =>
      '/shop-admin/customers/$customerId';

  // Superadmin
  static const String superadminDashboard = '/superadmin/dashboard';
  static const String superadminShops = '/superadmin/shops';
  static const String superadminBookings = '/superadmin/bookings';
  static const String superadminCustomers = '/superadmin/customers';
  static const String superadminSettings = '/superadmin/settings';
  static const String superadminShopNew = '/superadmin/shops/new';
  static const String superadminAnnouncements =
      '/superadmin/settings/announcements';
  static const String superadminAnnouncementNew =
      '/superadmin/settings/announcements/new';

  static String superadminShop(String shopId) => '/superadmin/shops/$shopId';
  static String superadminShopEdit(String shopId) =>
      '/superadmin/shops/$shopId/edit';
  static String superadminShopAdmins(String shopId) =>
      '/superadmin/shops/$shopId/admins';
  static String superadminShopAdminInvite(String shopId) =>
      '/superadmin/shops/$shopId/admins/invite';
  static String superadminBooking(String bookingId) =>
      '/superadmin/bookings/$bookingId';
  static String superadminCustomer(String customerId) =>
      '/superadmin/customers/$customerId';

  // Role helpers
  static String homeFor(UserRole role) => switch (role) {
        UserRole.customer => customerHome,
        UserRole.shopAdmin => shopAdminDashboard,
        UserRole.superadmin => superadminDashboard,
      };

  static String prefixFor(UserRole role) => switch (role) {
        UserRole.customer => customerPrefix,
        UserRole.shopAdmin => shopAdminPrefix,
        UserRole.superadmin => superadminPrefix,
      };

  /// True when [path] is [prefix] itself or below it (`/customer/...`).
  static bool isUnder(String path, String prefix) =>
      path == prefix || path.startsWith('$prefix/');
}
