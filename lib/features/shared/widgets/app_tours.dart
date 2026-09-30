import '../../../core/l10n/l10n.dart';
import 'app_tour.dart';

/// Anchor ids used by [TourAnchor]s. Ids are per page (per launcher), so the
/// same id can be reused on different pages.
abstract final class TourIds {
  static const String search = 'search';
  static const String filters = 'filters';
  static const String stadiumFilter = 'stadiumFilter';
  static const String dayStrip = 'dayStrip';
  static const String venues = 'venues';
  static const String stats = 'stats';
  static const String bell = 'bell';
  static const String email = 'email';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String password = 'password';
  static const String newPassword = 'newPassword';
  static const String forgot = 'forgot';
  static const String register = 'register';
  static const String language = 'language';
  static const String primary = 'primary';
  static const String secondary = 'secondary';
  static const String cancel = 'cancel';
  static const String fab = 'fab';
  static const String edit = 'edit';
  static const String tabs = 'tabs';
  static const String courts = 'courts';
  static const String slots = 'slots';
  static const String markAll = 'markAll';
  static const String confirm = 'confirm';
  static const String payment = 'payment';
  static const String reject = 'reject';
  static const String block = 'block';
  static const String blacklist = 'blacklist';
  static const String location = 'location';
  static const String hours = 'hours';
  static const String facilities = 'facilities';
  static const String price = 'price';
  static const String slotLength = 'slotLength';
  static const String where = 'where';
  static const String map = 'map';
  static const String segments = 'segments';
  static const String status = 'status';
  static const String admins = 'admins';
  static const String owner = 'owner';
  static const String audience = 'audience';
}

/// Every page's first-visit tour. Tab indexes follow `NavDestinations`.
/// Steps whose target isn't on screen (e.g. a button only shown for some
/// states) are skipped automatically.
abstract final class AppTours {
  // --- Auth -------------------------------------------------------------------

  static final login = AppTourDef('auth.login', (l) => [
        AppTourStep.anchor(TourIds.email,
            title: l.tourLoginEmailTitle, body: l.tourLoginEmailBody),
        AppTourStep.anchor(TourIds.forgot,
            title: l.tourLoginForgotTitle, body: l.tourLoginForgotBody),
        AppTourStep.anchor(TourIds.register,
            title: l.tourLoginRegisterTitle, body: l.tourLoginRegisterBody),
        _language(l),
      ]);

  static final register = AppTourDef('auth.register', (l) => [
        AppTourStep.anchor(TourIds.name,
            title: l.tourRegisterNameTitle, body: l.tourRegisterNameBody),
        AppTourStep.anchor(TourIds.phone,
            title: l.tourRegisterPhoneTitle, body: l.tourRegisterPhoneBody),
        AppTourStep.anchor(TourIds.primary,
            title: l.tourRegisterButtonTitle, body: l.tourRegisterButtonBody),
        _language(l),
      ]);

  static final forgotPassword = AppTourDef('auth.forgotPassword', (l) => [
        AppTourStep.anchor(TourIds.email,
            title: l.tourForgotEmailTitle, body: l.tourForgotEmailBody),
        AppTourStep.anchor(TourIds.primary,
            title: l.tourForgotButtonTitle, body: l.tourForgotButtonBody),
      ]);

  static AppTourStep _language(AppLocalizations l) => AppTourStep.anchor(
        TourIds.language,
        title: l.tourLanguageTitle,
        body: l.tourLanguageBody,
      );

  static AppTourStep _save(AppLocalizations l) => AppTourStep.anchor(
        TourIds.primary,
        title: l.tourSaveTitle,
        body: l.tourSaveBody,
      );

  // --- Customer ---------------------------------------------------------------

  static final customerHome = AppTourDef('customer.home', (l) => [
        AppTourStep.anchor(TourIds.search,
            title: l.tourCustSearchTitle, body: l.tourCustSearchBody),
        AppTourStep.anchor(TourIds.dayStrip,
            title: l.tourCustDayTitle, body: l.tourCustDayBody),
        AppTourStep.anchor(TourIds.venues,
            title: l.tourCustVenuesTitle, body: l.tourCustVenuesBody),
        AppTourStep.tab(2,
            title: l.tourCustBookingsTitle, body: l.tourCustBookingsBody),
        AppTourStep.tab(3,
            title: l.tourCustNotifTitle, body: l.tourCustNotifBody),
        AppTourStep.tab(4,
            title: l.tourCustProfileTitle, body: l.tourCustProfileBody),
      ]);

  static final customerExplore = AppTourDef('customer.explore', (l) => [
        AppTourStep.anchor(TourIds.search,
            title: l.tourExploreSearchTitle, body: l.tourExploreSearchBody),
        AppTourStep.anchor(TourIds.filters,
            title: l.tourExploreFiltersTitle, body: l.tourExploreFiltersBody),
      ]);

  static final customerStadium = AppTourDef('customer.stadium', (l) => [
        AppTourStep.intro(
            title: l.tourStadiumIntroTitle, body: l.tourStadiumIntroBody),
        AppTourStep.anchor(TourIds.courts,
            title: l.tourStadiumCourtsTitle, body: l.tourStadiumCourtsBody),
        AppTourStep.anchor(TourIds.primary,
            title: l.tourStadiumBookTitle, body: l.tourStadiumBookBody),
      ]);

  static final customerSlots = AppTourDef('customer.slots', (l) => [
        AppTourStep.anchor(TourIds.courts,
            title: l.tourSlotsCourtTitle, body: l.tourSlotsCourtBody),
        AppTourStep.anchor(TourIds.dayStrip,
            title: l.tourSlotsDayTitle, body: l.tourSlotsDayBody),
        AppTourStep.anchor(TourIds.slots,
            title: l.tourSlotsGridTitle, body: l.tourSlotsGridBody),
        AppTourStep.anchor(TourIds.primary,
            title: l.tourSlotsContinueTitle, body: l.tourSlotsContinueBody),
      ]);

  static final customerReview = AppTourDef('customer.review', (l) => [
        AppTourStep.intro(
            title: l.tourReviewIntroTitle, body: l.tourReviewIntroBody),
        AppTourStep.anchor(TourIds.primary,
            title: l.tourReviewSendTitle, body: l.tourReviewSendBody),
      ]);

  static final customerConfirmation =
      AppTourDef('customer.confirmation', (l) => [
            AppTourStep.intro(
                title: l.tourConfirmIntroTitle, body: l.tourConfirmIntroBody),
            AppTourStep.anchor(TourIds.primary,
                title: l.tourConfirmViewTitle, body: l.tourConfirmViewBody),
          ]);

  static final customerBookings = AppTourDef('customer.bookings', (l) => [
        AppTourStep.intro(
            title: l.tourBookingsIntroTitle, body: l.tourBookingsIntroBody),
        AppTourStep.anchor(TourIds.tabs,
            title: l.tourBookingsTabsTitle, body: l.tourBookingsTabsBody),
      ]);

  static final customerBookingDetail =
      AppTourDef('customer.bookingDetail', (l) => [
            AppTourStep.intro(
                title: l.tourBookingDetailIntroTitle,
                body: l.tourBookingDetailIntroBody),
            AppTourStep.anchor(TourIds.secondary,
                title: l.tourBookingDetailVenueTitle,
                body: l.tourBookingDetailVenueBody),
            AppTourStep.anchor(TourIds.cancel,
                title: l.tourBookingDetailCancelTitle,
                body: l.tourBookingDetailCancelBody),
          ]);

  static final customerNotifications =
      AppTourDef('customer.notifications', (l) => [
            AppTourStep.intro(
                title: l.tourNotifIntroTitle, body: l.tourNotifIntroBody),
            _markAll(l),
          ]);

  static AppTourStep _markAll(AppLocalizations l) => AppTourStep.anchor(
        TourIds.markAll,
        title: l.tourNotifMarkTitle,
        body: l.tourNotifMarkBody,
      );

  static final customerProfile = AppTourDef('customer.profile', (l) => [
        AppTourStep.intro(
            title: l.tourProfileIntroTitle, body: l.tourProfileIntroBody),
        AppTourStep.anchor(TourIds.edit,
            title: l.tourProfileEditTitle, body: l.tourProfileEditBody),
        _language(l),
      ]);

  static final customerEditProfile = AppTourDef('customer.editProfile', (l) => [
        AppTourStep.anchor(TourIds.name,
            title: l.tourRegisterNameTitle, body: l.tourRegisterNameBody),
        AppTourStep.anchor(TourIds.phone,
            title: l.tourRegisterPhoneTitle, body: l.tourEditPhoneBody),
        _save(l),
      ]);

  static final customerChangePassword =
      AppTourDef('customer.changePassword', (l) => [
            AppTourStep.anchor(TourIds.password,
                title: l.tourPasswordCurrentTitle,
                body: l.tourPasswordCurrentBody),
            AppTourStep.anchor(TourIds.newPassword,
                title: l.tourPasswordNewTitle, body: l.tourPasswordNewBody),
            _save(l),
          ]);

  // --- Shop admin -------------------------------------------------------------

  static final shopAdminDashboard = AppTourDef('shop.dashboard', (l) => [
        AppTourStep.anchor(TourIds.stats,
            title: l.tourShopStatsTitle, body: l.tourShopStatsBody),
        AppTourStep.anchor(TourIds.bell,
            title: l.tourShopBellTitle, body: l.tourShopBellBody),
        AppTourStep.tab(1,
            title: l.tourShopBookingsTitle, body: l.tourShopBookingsBody),
        AppTourStep.tab(2,
            title: l.tourShopStadiumsTitle, body: l.tourShopStadiumsBody),
        AppTourStep.tab(3,
            title: l.navCustomers, body: l.tourShopCustomersBody),
        AppTourStep.tab(4,
            title: l.navSettings, body: l.tourShopSettingsBody),
      ]);

  static List<AppTourStep> _staffBookings(AppLocalizations l) => [
        AppTourStep.anchor(TourIds.stadiumFilter,
            title: l.tourStaffStadiumFilterTitle,
            body: l.tourStaffStadiumFilterBody),
        AppTourStep.anchor(TourIds.filters,
            title: l.tourStaffFiltersTitle, body: l.tourStaffFiltersBody),
        AppTourStep.anchor(TourIds.block,
            title: l.tourStaffBlockTitle, body: l.tourStaffBlockBody),
      ];

  static List<AppTourStep> _staffBookingDetail(AppLocalizations l) => [
        AppTourStep.intro(
            title: l.tourStaffDetailIntroTitle,
            body: l.tourStaffDetailIntroBody),
        AppTourStep.anchor(TourIds.confirm,
            title: l.tourStaffConfirmTitle, body: l.tourStaffConfirmBody),
        AppTourStep.anchor(TourIds.payment,
            title: l.tourStaffPaymentTitle, body: l.tourStaffPaymentBody),
        AppTourStep.anchor(TourIds.reject,
            title: l.tourStaffRejectTitle, body: l.tourStaffRejectBody),
        AppTourStep.anchor(TourIds.blacklist,
            title: l.tourBlacklistActionTitle,
            body: l.tourBlacklistActionBody),
      ];

  static AppTourStep _customerSearch(AppLocalizations l) => AppTourStep.anchor(
        TourIds.search,
        title: l.tourCustomerSearchTitle,
        body: l.tourCustomerSearchBody,
      );

  static final shopAdminBookings =
      AppTourDef('shop.bookings', _staffBookings);

  static final shopAdminBookingDetail =
      AppTourDef('shop.bookingDetail', _staffBookingDetail);

  static final shopAdminCustomers = AppTourDef('shop.customers', (l) => [
        AppTourStep.intro(
            title: l.navCustomers, body: l.tourShopCustomersIntroBody),
        _customerSearch(l),
      ]);

  static final shopAdminCustomerDetail =
      AppTourDef('shop.customerDetail', (l) => [
            AppTourStep.intro(
                title: l.tourCustomerDetailIntroTitle,
                body: l.tourCustomerDetailIntroBody),
            AppTourStep.anchor(TourIds.blacklist,
                title: l.tourBlacklistActionTitle,
                body: l.tourBlacklistActionBody),
          ]);

  static final shopAdminNotifications =
      AppTourDef('shop.notifications', (l) => [
            AppTourStep.intro(
                title: l.tourNotifIntroTitle, body: l.tourNotifShopIntroBody),
            _markAll(l),
          ]);

  static final shopAdminSettings = AppTourDef('shop.settings', (l) => [
        AppTourStep.intro(
            title: l.tourShopSettingsIntroTitle,
            body: l.tourShopSettingsIntroBody),
      ]);

  static final shopAdminShopProfile = AppTourDef('shop.shopProfile', (l) => [
        AppTourStep.intro(
            title: l.tourShopProfileIntroTitle,
            body: l.tourShopProfileIntroBody),
        AppTourStep.anchor(TourIds.edit,
            title: l.tourShopProfileEditTitle,
            body: l.tourShopProfileEditBody),
      ]);

  static final shopAdminStadiums = AppTourDef('shop.stadiums', (l) => [
        AppTourStep.intro(
            title: l.tourStadiumsIntroTitle, body: l.tourStadiumsIntroBody),
        AppTourStep.anchor(TourIds.fab,
            title: l.tourStadiumsAddTitle, body: l.tourStadiumsAddBody),
      ]);

  static final shopAdminStadiumDetail =
      AppTourDef('shop.stadiumDetail', (l) => [
            AppTourStep.anchor(TourIds.edit,
                title: l.tourStadiumEditTitle, body: l.tourStadiumEditBody),
            AppTourStep.anchor(TourIds.fab,
                title: l.tourStadiumAddCourtTitle,
                body: l.tourStadiumAddCourtBody),
          ]);

  static final shopAdminStadiumForm = AppTourDef('shop.stadiumForm', (l) => [
        AppTourStep.anchor(TourIds.name,
            title: l.tourStadiumFormNameTitle,
            body: l.tourStadiumFormNameBody),
        AppTourStep.anchor(TourIds.location,
            title: l.tourStadiumFormMapTitle, body: l.tourStadiumFormMapBody),
        AppTourStep.anchor(TourIds.hours,
            title: l.tourStadiumFormHoursTitle,
            body: l.tourStadiumFormHoursBody),
        AppTourStep.anchor(TourIds.facilities,
            title: l.tourStadiumFormFacilitiesTitle,
            body: l.tourStadiumFormFacilitiesBody),
        _save(l),
      ]);

  static final shopAdminCourtDetail = AppTourDef('shop.courtDetail', (l) => [
        AppTourStep.intro(
            title: l.tourCourtIntroTitle, body: l.tourCourtIntroBody),
        AppTourStep.anchor(TourIds.edit,
            title: l.tourCourtEditTitle, body: l.tourCourtEditBody),
      ]);

  static final shopAdminCourtForm = AppTourDef('shop.courtForm', (l) => [
        AppTourStep.anchor(TourIds.name,
            title: l.tourCourtFormNameTitle, body: l.tourCourtFormNameBody),
        AppTourStep.anchor(TourIds.price,
            title: l.tourCourtFormPriceTitle, body: l.tourCourtFormPriceBody),
        AppTourStep.anchor(TourIds.slotLength,
            title: l.tourCourtFormSlotTitle, body: l.tourCourtFormSlotBody),
        _save(l),
      ]);

  static final shopAdminBlockedSlots = AppTourDef('shop.blockedSlots', (l) => [
        AppTourStep.intro(
            title: l.tourBlockedIntroTitle, body: l.tourBlockedIntroBody),
        AppTourStep.anchor(TourIds.fab,
            title: l.tourStaffBlockTitle, body: l.tourBlockedAddBody),
      ]);

  static final shopAdminBlockedSlotForm =
      AppTourDef('shop.blockedSlotForm', (l) => [
            AppTourStep.anchor(TourIds.where,
                title: l.tourBlockFormWhereTitle,
                body: l.tourBlockFormWhereBody),
            AppTourStep.anchor(TourIds.primary,
                title: l.tourStaffBlockTitle,
                body: l.tourBlockFormButtonBody),
          ]);

  static final shopAdminBlacklist = AppTourDef('shop.blacklist', (l) => [
        AppTourStep.intro(
            title: l.tourBlacklistIntroTitle,
            body: l.tourBlacklistIntroBody),
      ]);

  static final shopAdminLocationPicker =
      AppTourDef('shop.locationPicker', (l) => [
            AppTourStep.anchor(TourIds.map,
                title: l.tourMapTitle, body: l.tourMapBody),
            AppTourStep.anchor(TourIds.primary,
                title: l.tourMapUseTitle, body: l.tourMapUseBody),
          ]);

  // --- Superadmin -------------------------------------------------------------

  static final superadminDashboard = AppTourDef('admin.dashboard', (l) => [
        AppTourStep.anchor(TourIds.stats,
            title: l.tourAdminStatsTitle, body: l.tourAdminStatsBody),
        AppTourStep.tab(1, title: l.navShops, body: l.tourAdminShopsBody),
        AppTourStep.tab(2,
            title: l.tourAdminBookingsTitle, body: l.tourAdminBookingsBody),
        AppTourStep.tab(3,
            title: l.navCustomers, body: l.tourAdminCustomersBody),
        AppTourStep.tab(4,
            title: l.navSettings, body: l.tourAdminSettingsBody),
      ]);

  static final superadminShops = AppTourDef('admin.shops', (l) => [
        AppTourStep.anchor(TourIds.segments,
            title: l.tourShopsSegmentsTitle, body: l.tourShopsSegmentsBody),
        AppTourStep.anchor(TourIds.fab,
            title: l.tourShopsAddTitle, body: l.tourShopsAddBody),
      ]);

  static final superadminShopDetail = AppTourDef('admin.shopDetail', (l) => [
        AppTourStep.anchor(TourIds.edit,
            title: l.tourShopDetailEditTitle,
            body: l.tourShopDetailEditBody),
        AppTourStep.anchor(TourIds.status,
            title: l.tourShopDetailStatusTitle,
            body: l.tourShopDetailStatusBody),
        AppTourStep.anchor(TourIds.admins,
            title: l.tourShopDetailAdminsTitle,
            body: l.tourShopDetailAdminsBody),
      ]);

  static final superadminShopForm = AppTourDef('admin.shopForm', (l) => [
        AppTourStep.anchor(TourIds.name,
            title: l.tourShopFormNameTitle, body: l.tourShopFormNameBody),
        AppTourStep.anchor(TourIds.owner,
            title: l.tourShopFormOwnerTitle, body: l.tourShopFormOwnerBody),
        _save(l),
      ]);

  static final superadminShopAdmins = AppTourDef('admin.shopAdmins', (l) => [
        AppTourStep.intro(
            title: l.tourShopAdminsIntroTitle,
            body: l.tourShopAdminsIntroBody),
        AppTourStep.anchor(TourIds.fab,
            title: l.tourShopAdminsAddTitle, body: l.tourShopAdminsAddBody),
      ]);

  static final superadminInviteShopAdmin =
      AppTourDef('admin.inviteShopAdmin', (l) => [
            AppTourStep.anchor(TourIds.email,
                title: l.tourInviteEmailTitle, body: l.tourInviteEmailBody),
            AppTourStep.anchor(TourIds.secondary,
                title: l.tourInviteFindTitle, body: l.tourInviteFindBody),
          ]);

  static final superadminAnnouncements =
      AppTourDef('admin.announcements', (l) => [
            AppTourStep.intro(
                title: l.tourAnnouncementsIntroTitle,
                body: l.tourAnnouncementsIntroBody),
            AppTourStep.anchor(TourIds.fab,
                title: l.tourAnnouncementsAddTitle,
                body: l.tourAnnouncementsAddBody),
          ]);

  static final superadminNewAnnouncement =
      AppTourDef('admin.newAnnouncement', (l) => [
            AppTourStep.anchor(TourIds.audience,
                title: l.tourAnnounceAudienceTitle,
                body: l.tourAnnounceAudienceBody),
            AppTourStep.anchor(TourIds.primary,
                title: l.tourAnnounceSendTitle,
                body: l.tourAnnounceSendBody),
          ]);

  static final superadminBookings =
      AppTourDef('admin.bookings', _staffBookings);

  static final superadminBookingDetail =
      AppTourDef('admin.bookingDetail', _staffBookingDetail);

  static final superadminCustomers = AppTourDef('admin.customers', (l) => [
        AppTourStep.intro(
            title: l.navCustomers, body: l.tourAdminCustomersIntroBody),
        _customerSearch(l),
      ]);

  static final superadminCustomerDetail =
      AppTourDef('admin.customerDetail', (l) => [
            AppTourStep.intro(
                title: l.tourCustomerDetailIntroTitle,
                body: l.tourAdminCustomerDetailBody),
          ]);

  static final superadminSettings = AppTourDef('admin.settings', (l) => [
        AppTourStep.intro(
            title: l.navSettings, body: l.tourAdminSettingsIntroBody),
      ]);
}
