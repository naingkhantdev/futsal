import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get splashTagline => 'Book your court in seconds';

  @override
  String get splashSettingUp => 'Setting up your account…';

  @override
  String get splashLoadingAccount => 'Loading your account';

  @override
  String get splashLoadError => 'We couldn\'t load your account';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSaveChanges => 'Save changes';

  @override
  String get commonDiscard => 'Discard';

  @override
  String get commonKeepEditing => 'Keep editing';

  @override
  String get commonDiscardTitle => 'Discard changes?';

  @override
  String get commonNotAdded => 'Not added';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Choose the app language';

  @override
  String get languageMyanmar => 'မြန်မာ';

  @override
  String get languageEnglish => 'English';

  @override
  String get demoBanner => 'Sample data · preview only, changes are not saved';

  @override
  String previewOnly(String action) {
    return '$action · preview only, nothing was saved';
  }

  @override
  String get logOut => 'Log out';

  @override
  String get logOutConfirmTitle => 'Log out?';

  @override
  String get logOutConfirmMessage => 'You\'ll need to log in again to use the app.';

  @override
  String get stayLoggedIn => 'Stay logged in';

  @override
  String get signOut => 'Sign out';

  @override
  String get accountUnavailableTitle => 'Account unavailable';

  @override
  String get accountDisabledMessage => 'Your account has been disabled. Contact support if you think this is a mistake.';

  @override
  String get accountMissingShopMessage => 'Your shop access isn\'t set up yet. Contact the platform team.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get searchHint => 'Search';

  @override
  String get errorOfflineTitle => 'You\'re offline';

  @override
  String get errorNoAccessTitle => 'You don\'t have access';

  @override
  String get errorNotFoundTitle => 'Not found';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errAuthentication => 'Please log in again to continue.';

  @override
  String get errInvalidCredentials => 'Email or password is incorrect.';

  @override
  String get errInvalidEmail => 'Enter a valid email address.';

  @override
  String get errEmailInUse => 'An account with this email already exists. Log in instead?';

  @override
  String get errWeakPassword => 'Use at least 8 characters.';

  @override
  String get errTooManyRequests => 'Too many attempts. Try again in a few minutes.';

  @override
  String get errIncorrectPassword => 'Your current password is incorrect.';

  @override
  String get errSetupTimeout => 'Your account didn\'t finish loading. Check your connection and try again.';

  @override
  String get errUnauthorizedRole => 'This account doesn\'t have access to the app. Contact support.';

  @override
  String get errPermissionDenied => 'You don\'t have permission to do that.';

  @override
  String get errNetwork => 'You\'re offline. Check your connection and try again.';

  @override
  String get errNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get errInvalidVenueDetails => 'Some details aren\'t valid. Check the form and try again.';

  @override
  String get errShopAdminAssignment => 'This account can\'t be made a shop admin.';

  @override
  String get errBookingConflict => 'That time was just booked by someone else. Pick another time.';

  @override
  String get errCourtUnavailable => 'This court isn\'t available for booking right now.';

  @override
  String get errStadiumUnavailable => 'This stadium isn\'t available for booking right now.';

  @override
  String get errShopUnavailable => 'This venue isn\'t taking bookings right now.';

  @override
  String get errInvalidBookingTime => 'That time can\'t be booked. Check the opening hours and try another time.';

  @override
  String get errBookingTooLong => 'You can book up to 4 slots at a time.';

  @override
  String get errProfileIncomplete => 'Add your name in Profile before booking.';

  @override
  String get errInvalidBookingChange => 'This booking can\'t be changed that way anymore.';

  @override
  String get errInvalidDate => 'That date can\'t be booked. Choose another date.';

  @override
  String get errServer => 'Something went wrong on our side. Please try again.';

  @override
  String get errUnknown => 'Something went wrong. Please try again.';

  @override
  String get valNameRequired => 'Enter your name';

  @override
  String get valNameTooLong => 'Use 80 characters or fewer';

  @override
  String get valEmailRequired => 'Enter your email';

  @override
  String get valEmailInvalid => 'Enter a valid email address';

  @override
  String get valPhoneInvalid => 'Enter a valid phone number';

  @override
  String get valPasswordRequired => 'Enter your password';

  @override
  String get valPasswordTooShort => 'Use at least 8 characters';

  @override
  String get valCurrentPasswordRequired => 'Enter your current password';

  @override
  String get valPasswordSame => 'Choose a password different from your current one';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navProfile => 'Profile';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navStadiums => 'Stadiums';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navSettings => 'Settings';

  @override
  String get navShops => 'Shops';

  @override
  String navBadgeNew(String label, int count) {
    return '$label, $count new';
  }

  @override
  String get bookingPending => 'Pending';

  @override
  String get bookingConfirmed => 'Confirmed';

  @override
  String get bookingRejected => 'Rejected';

  @override
  String get bookingCancelled => 'Cancelled';

  @override
  String get bookingCompleted => 'Completed';

  @override
  String get paymentUnpaid => 'Unpaid';

  @override
  String get paymentPending => 'Payment pending';

  @override
  String get paymentPaid => 'Paid';

  @override
  String get paymentRefunded => 'Refunded';

  @override
  String get shopPendingReview => 'Pending review';

  @override
  String get shopActive => 'Active';

  @override
  String get shopSuspended => 'Suspended';

  @override
  String get shopRejected => 'Rejected';

  @override
  String get shopInactive => 'Inactive';

  @override
  String get shopListed => 'Listed';

  @override
  String get shopUnlisted => 'Unlisted';

  @override
  String get bookingStatusPrefix => 'Booking status';

  @override
  String get paymentStatusPrefix => 'Payment status';

  @override
  String get facilityParking => 'Parking';

  @override
  String get facilityShower => 'Shower';

  @override
  String get facilityChangingRoom => 'Changing room';

  @override
  String get facilityDrinkingWater => 'Drinking water';

  @override
  String get facilityFloodLights => 'Flood lights';

  @override
  String get facilitySeating => 'Seating';

  @override
  String get facilityRestroom => 'Restroom';

  @override
  String get facilityCafe => 'Cafe';

  @override
  String get facilityEquipmentRental => 'Equipment rental';

  @override
  String get reasonMaintenance => 'Maintenance';

  @override
  String get reasonPrivateEvent => 'Private event';

  @override
  String get reasonCleaning => 'Cleaning';

  @override
  String get reasonTournament => 'Tournament';

  @override
  String get reasonTemporaryClosure => 'Temporary closure';

  @override
  String get reasonOther => 'Other';

  @override
  String get slotAvailable => 'Available';

  @override
  String get slotSelected => 'Selected';

  @override
  String get slotBooked => 'Booked';

  @override
  String get slotBlocked => 'Blocked';

  @override
  String get slotClosed => 'Closed';

  @override
  String get slotUnavailable => 'Unavailable';

  @override
  String get dayToday => 'Today';

  @override
  String get dayTomorrow => 'Tomorrow';

  @override
  String get dayYesterday => 'Yesterday';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get durationOneHour => '1 hour';

  @override
  String durationHours(String hours) {
    return '$hours hours';
  }

  @override
  String get agoJustNow => 'Just now';

  @override
  String agoMinutes(int count) {
    return '$count min ago';
  }

  @override
  String agoHours(int count) {
    return '$count h ago';
  }

  @override
  String agoDays(int count) {
    return '$count d ago';
  }

  @override
  String get loginHeadline => 'Welcome back';

  @override
  String get loginSubtitle => 'Log in to book your next game.';

  @override
  String get emailLabel => 'Email';

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get loginButton => 'Log in';

  @override
  String get newHere => 'New here?';

  @override
  String get createAccountLink => 'Create an account';

  @override
  String get registerHeadline => 'Create your account';

  @override
  String get registerSubtitle => 'Book futsal courts in a few taps.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get phoneOptionalLabel => 'Phone (optional)';

  @override
  String get phoneHelper => 'Venues use this to reach you about bookings';

  @override
  String get passwordHelper => 'At least 8 characters';

  @override
  String get termsNote => 'By continuing you agree to the Terms and Privacy Policy.';

  @override
  String get venueOwnerNote => 'Own a futsal venue? Shop accounts are set up by our team — contact us to join.';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get forgotHeadline => 'Reset your password';

  @override
  String get forgotSubtitle => 'Enter your email and we\'ll send you a reset link.';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get backToLogin => 'Back to log in';

  @override
  String get resetSentHeadline => 'Check your email';

  @override
  String resetSentMessage(String email) {
    return 'If an account exists for $email, a reset link is on its way.';
  }

  @override
  String get resetResent => 'Reset link sent again';

  @override
  String get resend => 'Resend';

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get profilePhone => 'Phone';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get changePassword => 'Change password';

  @override
  String get addYourName => 'Add your name';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get profileDiscardMessage => 'Your edits to your profile won\'t be saved.';

  @override
  String get emailCantChange => 'Email can\'t be changed here';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get updatePassword => 'Update password';

  @override
  String get loadingProfile => 'Loading your profile';

  @override
  String get profileNotReadyTitle => 'Your profile isn\'t ready yet';

  @override
  String get profileNotReadyMessage => 'This is taking longer than usual. Check your connection and try again.';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeSearchHint => 'Search stadiums or townships';

  @override
  String get homeNextGame => 'Your next game';

  @override
  String get homeAllBookings => 'All bookings';

  @override
  String get exploreEmptyTitle => 'No stadiums found';

  @override
  String get exploreEmptyMessage => 'Try another name or remove a filter.';

  @override
  String priceFromPerHour(String price) {
    return 'From $price/hr';
  }

  @override
  String pricePerHour(String price) {
    return '$price/hr';
  }

  @override
  String pricePerHourLong(String price) {
    return '$price / hour';
  }

  @override
  String get priceOnRequest => 'Price on request';

  @override
  String get priceFrom => 'From';

  @override
  String get bookACourt => 'Book a court';

  @override
  String openDaily(String hours) {
    return 'Open $hours daily';
  }

  @override
  String byShop(String shop) {
    return 'by $shop';
  }

  @override
  String get facilitiesTitle => 'Facilities';

  @override
  String get courtsTitle => 'Courts';

  @override
  String upToPlayers(int count) {
    return 'Up to $count players';
  }

  @override
  String slotLengthLabel(int minutes) {
    return '$minutes-min slots';
  }

  @override
  String get courtLabel => 'Court';

  @override
  String get dayLabel => 'Day';

  @override
  String get pickStartTime => 'Pick a start time';

  @override
  String slotRules(int max, int minutes, String price) {
    return 'Up to $max consecutive $minutes-min slots · $price/hr';
  }

  @override
  String get reviewTitle => 'Review booking';

  @override
  String get reviewNothingTitle => 'Nothing to review';

  @override
  String get reviewNothingMessage => 'Pick a court and a time first.';

  @override
  String get reviewPickTime => 'Pick a time';

  @override
  String requestBookingButton(String total) {
    return 'Request booking · $total';
  }

  @override
  String get bookingRequestAction => 'Booking request';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get totalLabel => 'Total';

  @override
  String get payAtVenueNote => 'Pay at the venue. The shop confirms your request, usually within a few hours.';

  @override
  String get confirmTitle => 'Booking requested';

  @override
  String confirmMessage(String stadium) {
    return 'We\'ll notify you as soon as $stadium confirms.';
  }

  @override
  String get totalPayAtVenue => 'Total · pay at the venue';

  @override
  String get viewBooking => 'View booking';

  @override
  String get backToHome => 'Back to home';

  @override
  String tabUpcoming(int count) {
    return 'Upcoming ($count)';
  }

  @override
  String tabPast(int count) {
    return 'Past ($count)';
  }

  @override
  String get emptyUpcomingTitle => 'No upcoming games';

  @override
  String get emptyUpcomingMessage => 'Book a court and it shows up here.';

  @override
  String get emptyPastTitle => 'No past bookings';

  @override
  String get emptyPastMessage => 'Games you have played appear here.';

  @override
  String allStadiums(int count) {
    return 'All stadiums ($count)';
  }

  @override
  String get bookingTitle => 'Booking';

  @override
  String get viewVenue => 'View venue';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get cancelBookingTitle => 'Cancel this booking?';

  @override
  String get cancelBookingMessage => 'The court will be released for others.';

  @override
  String get keepIt => 'Keep it';

  @override
  String reasonLabel(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get venueLabel => 'Venue';

  @override
  String get shopLabel => 'Shop';

  @override
  String get noPhone => 'No phone number';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get markAllReadAction => 'Mark all as read';

  @override
  String get unreadPrefix => 'Unread.';

  @override
  String get formDiscardMessage => 'Your changes won\'t be saved.';

  @override
  String get formFixFields => 'Fix the highlighted fields';

  @override
  String get notFoundRemoved => 'It may have been removed.';

  @override
  String get addressOptional => 'Address (optional)';

  @override
  String get townshipOptional => 'Township (optional)';

  @override
  String get cityOptional => 'City (optional)';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get openForBookings => 'Open for bookings';

  @override
  String valMaxChars(int max) {
    return 'Use $max characters or fewer';
  }

  @override
  String get valPriceRequired => 'Enter the price per hour';

  @override
  String get valPriceDigits => 'Use whole kyat, digits only';

  @override
  String valPriceMax(int max) {
    return 'Enter a price up to $max';
  }

  @override
  String valCapacityRange(int max) {
    return 'Enter a number from 1 to $max';
  }

  @override
  String get stadiumNew => 'New stadium';

  @override
  String get stadiumEdit => 'Edit stadium';

  @override
  String get stadiumNotFound => 'Stadium not found';

  @override
  String get stadiumNameLabel => 'Stadium name';

  @override
  String get stadiumNameRequired => 'Enter the stadium name';

  @override
  String get stadiumAdded => 'Stadium added. Now add its courts.';

  @override
  String get stadiumUpdated => 'Stadium updated';

  @override
  String get openingHoursTitle => 'Opening hours';

  @override
  String get opensLabel => 'Opens';

  @override
  String get closesLabel => 'Closes';

  @override
  String get openingHoursNote => 'Stadiums open on the hour. Changing hours never moves or cancels existing bookings.';

  @override
  String get stadiumOpenSubtitle => 'When off, customers can\'t see or book this stadium.';

  @override
  String get addStadium => 'Add stadium';

  @override
  String get courtNew => 'New court';

  @override
  String get courtEdit => 'Edit court';

  @override
  String get courtNotFound => 'Court not found';

  @override
  String get courtNameLabel => 'Court name';

  @override
  String get courtNameRequired => 'Enter a court name, e.g. \"Court 1\"';

  @override
  String get courtAdded => 'Court added';

  @override
  String get courtUpdated => 'Court updated';

  @override
  String pricePerHourLabel(String currency) {
    return 'Price per hour ($currency)';
  }

  @override
  String get priceHelper => 'Whole kyat. Existing bookings keep the price they were made at.';

  @override
  String get slotLengthTitle => 'Slot length';

  @override
  String slotLengthNote(int max) {
    return 'Customers book 1–$max slots at a time. This can\'t be changed after the court is created.';
  }

  @override
  String slotLengthFixed(int minutes) {
    return '$minutes-minute slots. Fixed when the court was created so existing bookings can\'t overlap new ones.';
  }

  @override
  String get playersOptional => 'Players (optional)';

  @override
  String get playersHint => 'e.g. 10';

  @override
  String get surfaceOptional => 'Surface (optional)';

  @override
  String get surfaceHint => 'e.g. Artificial turf';

  @override
  String get courtOpenSubtitle => 'When off, customers can\'t see or book this court. Existing bookings stay.';

  @override
  String get addCourt => 'Add court';

  @override
  String get shopNew => 'New shop';

  @override
  String get shopEdit => 'Edit shop';

  @override
  String get shopNotFound => 'Shop not found';

  @override
  String get shopNameLabel => 'Shop name';

  @override
  String get shopNameRequired => 'Enter the shop name';

  @override
  String get shopCreated => 'Shop created. Review it to approve.';

  @override
  String get shopUpdated => 'Shop updated';

  @override
  String get shopNewNote => 'New shops start as \"Pending review\" and stay hidden from customers until you approve them.';

  @override
  String get shopPhoneHelper => 'Shown to customers';

  @override
  String get ownerPrivateTitle => 'Owner (private)';

  @override
  String get ownerPrivateNote => 'Only you and this shop\'s admins can see these.';

  @override
  String get ownerNameOptional => 'Owner name (optional)';

  @override
  String get ownerPhoneOptional => 'Owner phone (optional)';

  @override
  String get createShop => 'Create shop';

  @override
  String get addShopAdminTitle => 'Add shop admin';

  @override
  String get inviteIntro => 'Ask the shop owner to sign up in the app with their email first. Then find their account here.';

  @override
  String get accountEmailLabel => 'Account email';

  @override
  String get findAccount => 'Find account';

  @override
  String noAccountForEmail(String email) {
    return 'No account uses $email. Ask them to sign up with this email, then try again.';
  }

  @override
  String nowShopAdmin(String name) {
    return '$name is now a shop admin';
  }

  @override
  String get cantChangeOwnRole => 'You can\'t change your own role.';

  @override
  String get platformAdminCantBeShopAdmin => 'Platform admins can\'t be shop admins. Change their role first.';

  @override
  String get alreadyAdminHere => 'Already an admin of this shop.';

  @override
  String get managesOtherShop => 'This account manages another shop. Adding it here removes it from that shop.';

  @override
  String get roleUnknownFix => 'This account\'s role is unknown. Fix it in the console.';

  @override
  String currentRole(String role) {
    return 'Current role: $role';
  }

  @override
  String get roleUnknown => 'Unknown';

  @override
  String get accountDisabledTag => 'account disabled';

  @override
  String get makeShopAdmin => 'Make shop admin';

  @override
  String get rolePlatformAdmin => 'Platform admin';

  @override
  String get roleShopAdmin => 'Shop admin';

  @override
  String get roleCustomer => 'Customer';

  @override
  String get blockTimeTitle => 'Block time';

  @override
  String get stadiumLabel => 'Stadium';

  @override
  String get fromLabel => 'From';

  @override
  String get slotsLabel => 'Slots';

  @override
  String get reasonFieldLabel => 'Reason';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get newAnnouncementTitle => 'New announcement';

  @override
  String sendTo(String audience) {
    return 'Send to $audience';
  }

  @override
  String get sendAnnouncementAction => 'Send announcement';

  @override
  String get audienceLabel => 'Audience';

  @override
  String get titleLabel => 'Title';

  @override
  String get messageLabel => 'Message';

  @override
  String get audienceEveryone => 'Everyone';

  @override
  String get audienceCustomers => 'Customers';

  @override
  String get audienceShopAdmins => 'Shop admins';

  @override
  String get errBlacklisted => 'This venue isn\'t taking bookings from your account. Contact the venue.';

  @override
  String get blacklistTitle => 'Blacklist';

  @override
  String get blacklistSubtitle => 'Customers who can\'t book at your shop';

  @override
  String get blacklistIntro => 'Blacklisted customers can\'t make new bookings at your shop. Their existing bookings stay, and they can still book at other shops.';

  @override
  String get blacklistEmptyTitle => 'No one is blacklisted';

  @override
  String get blacklistEmptyMessage => 'Blacklist a customer from their profile, or from a booking they didn\'t show up for.';

  @override
  String get blacklistAdd => 'Add to blacklist';

  @override
  String get blacklistNoShowAction => 'Didn\'t show up · blacklist';

  @override
  String get blacklistRemove => 'Remove from blacklist';

  @override
  String blacklistRemoveTitle(String name) {
    return 'Remove $name from the blacklist?';
  }

  @override
  String get blacklistRemoveMessage => 'They\'ll be able to book at your shop again.';

  @override
  String get blacklistRemoveConfirm => 'Remove';

  @override
  String get blacklistKeep => 'Keep';

  @override
  String blacklistSheetTitle(String name) {
    return 'Blacklist $name';
  }

  @override
  String get blacklistSheetMessage => 'They won\'t be able to make new bookings at your shop. Existing bookings stay.';

  @override
  String get blacklistReasonNoShow => 'Didn\'t show up';

  @override
  String get blacklistConfirm => 'Blacklist';

  @override
  String blacklistAdded(String name) {
    return '$name is blacklisted';
  }

  @override
  String blacklistRemoved(String name) {
    return '$name can book again';
  }

  @override
  String get blacklistedBadge => 'Blacklisted';

  @override
  String blacklistedOn(String date) {
    return 'Blacklisted $date';
  }

  @override
  String get stadiumsEmptyTitle => 'Add your first stadium';

  @override
  String get stadiumsEmptyMessage => 'Set its opening hours, then add the courts customers can book.';

  @override
  String get staffFilterUpcoming => 'Upcoming';

  @override
  String get staffFilterPast => 'Past';

  @override
  String get staffFilterAll => 'All';

  @override
  String get staffNoBookingsTitle => 'No bookings here';

  @override
  String get staffTryAnotherFilter => 'Try another filter.';

  @override
  String get markPaymentPending => 'Mark payment pending';

  @override
  String get markAsPaid => 'Mark as paid';

  @override
  String get markAsRefunded => 'Mark as refunded';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get markAsCompleted => 'Mark as completed';

  @override
  String get rejectBooking => 'Reject booking';

  @override
  String get rejectBookingTitle => 'Reject this booking?';

  @override
  String get rejectBookingMessage => 'The customer is notified and the slots are released.';

  @override
  String get rejectAction => 'Reject';

  @override
  String get keepBooking => 'Keep booking';

  @override
  String get searchNameOrPhone => 'Search by name or phone';

  @override
  String get noCustomersFound => 'No customers found';

  @override
  String bookingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bookings',
      one: '1 booking',
    );
    return '$_temp0';
  }

  @override
  String lastPlayedOn(String date) {
    return 'last played $date';
  }

  @override
  String joinedOn(String date) {
    return 'Joined $date';
  }

  @override
  String get statusDisabled => 'Disabled';

  @override
  String get accountPrefix => 'Account';

  @override
  String get mmkOnPlatform => 'MMK on the platform';

  @override
  String get mmkAtYourShop => 'MMK at your shop';

  @override
  String get bookingHistory => 'Booking history';

  @override
  String get noBookingsYet => 'No bookings yet';

  @override
  String totalPaidAmount(String amount) {
    return 'Total paid: $amount';
  }

  @override
  String get settingsShopProfile => 'Shop profile';

  @override
  String get settingsShopProfileSub => 'Name, contact and address';

  @override
  String get blockedTimesTitle => 'Blocked times';

  @override
  String get blockedTimesSub => 'Maintenance, events, closures';

  @override
  String get stadiumsAndCourts => 'Stadiums & courts';

  @override
  String get editShopProfile => 'Edit shop profile';

  @override
  String get commonEdit => 'Edit';

  @override
  String get shopStatusPrefix => 'Shop status';

  @override
  String get listingPrefix => 'Listing';

  @override
  String get addressLabel => 'Address';

  @override
  String get statusManagedByPlatform => 'Status and listing are managed by the platform team.';

  @override
  String get visibilityUnlisted => 'Your shop is unlisted, so customers can\'t see or book it.';

  @override
  String get visibilityPending => 'Your shop is waiting for approval. Set up stadiums and courts now; customers see them once it is approved.';

  @override
  String get visibilitySuspended => 'Your shop is suspended. Customers can\'t see or book it. Contact the platform team.';

  @override
  String get visibilityInactive => 'Your shop isn\'t active. Customers can\'t see or book it.';

  @override
  String get venueActive => 'Active';

  @override
  String get venueInactive => 'Inactive';

  @override
  String get visibleToCustomers => 'Visible to customers';

  @override
  String get hiddenLabel => 'Hidden';

  @override
  String get discoveryPrefix => 'Discovery';

  @override
  String get bookableLabel => 'Bookable';

  @override
  String get noneListed => 'None listed';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get noCourtsYet => 'No courts yet';

  @override
  String get noCourtsMessage => 'Add a court with its price and slot length so customers can book it.';

  @override
  String get noPrice => 'No price';

  @override
  String get noPriceSet => 'No price set';

  @override
  String get pricePerHourTitle => 'Price per hour';

  @override
  String slotMinutesValue(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get playersLabel => 'Players';

  @override
  String get surfaceLabel => 'Surface';

  @override
  String get blockCourtSub => 'Close this court for maintenance, events and more';

  @override
  String get blockedTimesNote => 'Blocked times cannot be booked by customers.';

  @override
  String get removeBlock => 'Remove block';

  @override
  String venueCounts(int stadiums, int courts) {
    return '$stadiums stadiums · $courts courts';
  }

  @override
  String get statBookingsFooter => 'bookings';

  @override
  String get statNeedReply => 'need a reply';

  @override
  String get statCollected => 'Collected';

  @override
  String get statMmkFromPaid => 'MMK from paid bookings';

  @override
  String get statBookedWithYou => 'booked with you';

  @override
  String get needsYourReply => 'Needs your reply';

  @override
  String get allCaughtUp => 'All caught up';

  @override
  String get allCaughtUpMessage => 'New booking requests show up here.';

  @override
  String get todaysSchedule => 'Today\'s schedule';

  @override
  String get noGamesToday => 'No games today';

  @override
  String get locationLabel => 'Location';

  @override
  String get shopAdminsSub => 'Who can manage this shop';

  @override
  String get explainPending => 'Waiting for review. Hidden from customers; its admins can already set up stadiums and courts.';

  @override
  String get explainLive => 'Live: customers can find and book it.';

  @override
  String get explainUnlisted => 'Approved but unlisted: hidden from customers, no new bookings.';

  @override
  String get explainSuspended => 'Suspended: hidden from customers, no new bookings. Existing bookings stay as they are.';

  @override
  String get explainRejected => 'Rejected: hidden from customers.';

  @override
  String get explainInactive => 'Inactive: hidden from customers, no new bookings.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRemove => 'Remove';

  @override
  String get approveAndList => 'Approve and list';

  @override
  String get shopApprovedListed => 'Shop approved and listed';

  @override
  String get reactivateAction => 'Reactivate';

  @override
  String get shopReactivated => 'Shop reactivated';

  @override
  String get deactivateShop => 'Deactivate shop';

  @override
  String get shopDeactivated => 'Shop deactivated';

  @override
  String get deactivateShopTitle => 'Deactivate this shop?';

  @override
  String get deactivateShopMessage => 'It will be hidden from customers and take no new bookings. You can reactivate it later.';

  @override
  String get deactivateAction => 'Deactivate';

  @override
  String get shopRejectedDone => 'Shop rejected';

  @override
  String get rejectShopTitle => 'Reject this shop?';

  @override
  String get rejectShopMessage => 'It stays hidden from customers. You can still approve it later.';

  @override
  String get listedForCustomers => 'Listed for customers';

  @override
  String get listedForCustomersSub => 'When off, the shop is hidden and takes no new bookings.';

  @override
  String get shopListedDone => 'Shop listed';

  @override
  String get shopUnlistedDone => 'Shop unlisted';

  @override
  String get suspendAction => 'Suspend';

  @override
  String get shopSuspendedDone => 'Shop suspended';

  @override
  String get suspendShopTitle => 'Suspend this shop?';

  @override
  String get suspendShopMessage => 'Customers stop seeing it and it takes no new bookings. Existing bookings are not cancelled.';

  @override
  String get ownerNameLabel => 'Owner name';

  @override
  String get ownerPhoneLabel => 'Owner phone';

  @override
  String get suspensionReason => 'Suspension reason';

  @override
  String get nothingToReview => 'Nothing to review';

  @override
  String get nothingToReviewMessage => 'New shops appear here until you approve or reject them.';

  @override
  String get noShopsYet => 'No shops yet';

  @override
  String get noShopsMessage => 'Create the first shop, then assign its admin.';

  @override
  String shopAdminsOf(String shop) {
    return '$shop admins';
  }

  @override
  String get addAdmin => 'Add admin';

  @override
  String get noAdminsYet => 'No admins yet';

  @override
  String get noAdminsMessage => 'Add the person who runs this shop. They need a customer account first.';

  @override
  String get accountDisabledBadge => 'Account disabled';

  @override
  String get removeAdmin => 'Remove admin';

  @override
  String get removeAdminTitle => 'Remove this admin?';

  @override
  String removeAdminMessage(String name) {
    return '$name loses access to the shop right away and becomes a customer.';
  }

  @override
  String get adminRemoved => 'Admin removed';

  @override
  String shopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shops',
      one: '1 shop',
    );
    return '$_temp0';
  }

  @override
  String platformSummary(int active, int pending) {
    return '$active active · $pending waiting for review';
  }

  @override
  String get activeShops => 'Active shops';

  @override
  String ofTotal(int total) {
    return 'of $total';
  }

  @override
  String get toReview => 'To review';

  @override
  String get newShopsFooter => 'new shops';

  @override
  String get lastTwoWeeks => 'last 2 weeks';

  @override
  String get waitingForReview => 'Waiting for review';

  @override
  String get reviewAction => 'Review';

  @override
  String get latestBookings => 'Latest bookings';

  @override
  String get disableAccount => 'Disable account';

  @override
  String disableUserTitle(String name) {
    return 'Disable $name?';
  }

  @override
  String get disableUserMessage => 'They are signed out and cannot book until you enable the account again.';

  @override
  String get disableAction => 'Disable';

  @override
  String get keepActive => 'Keep active';

  @override
  String get enableAccount => 'Enable account';

  @override
  String get announcementsTitle => 'Announcements';

  @override
  String get announcementsSub => 'Messages to customers and shops';

  @override
  String get shopsPendingReview => 'Shops pending review';

  @override
  String get newShort => 'New';

  @override
  String get sentToPrefix => 'Sent to';

  @override
  String homeOpenSlots(String day) {
    return 'Open times · $day';
  }

  @override
  String get homeNoOpenSlots => 'Fully booked this day';

  @override
  String bookSlotAt(String court, String time) {
    return 'Book $court at $time';
  }

  @override
  String get mapDirections => 'Directions';

  @override
  String get mapOpenInGoogleMaps => 'Open in Google Maps';

  @override
  String get mapOpenFailed => 'Couldn\'t open Google Maps';

  @override
  String mapPinSemantics(String name) {
    return 'Map showing $name. Opens Google Maps';
  }

  @override
  String get locationNotSet => 'No map location yet';

  @override
  String get locationPickOnMap => 'Pick on map';

  @override
  String get locationChangeOnMap => 'Change on map';

  @override
  String get locationClear => 'Remove location';

  @override
  String get pickLocationTitle => 'Pin your venue';

  @override
  String get pickLocationHint => 'Move the map until the pin sits on your venue.';

  @override
  String get useThisLocation => 'Use this location';

  @override
  String get notifBookingRequestedTitle => 'New booking request';

  @override
  String get notifBookingCancelledTitle => 'Booking cancelled by customer';

  @override
  String get notifBookingConfirmedTitle => 'Booking confirmed';

  @override
  String get notifBookingRejectedTitle => 'Booking declined';

  @override
  String notifReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptyMessage => 'You\'ll see here when a shop confirms or declines your booking.';

  @override
  String get notificationsEmptyMessageShop => 'New booking requests and cancellations will show up here.';

  @override
  String get notificationsOpen => 'Open notifications';

  @override
  String get notificationView => 'View';

  @override
  String get tourSkip => 'Skip';

  @override
  String get tourNext => 'Next';

  @override
  String get tourBack => 'Back';

  @override
  String get tourDone => 'Got it';

  @override
  String tourStepOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String get tourReplay => 'App tour';

  @override
  String get tourReplaySub => 'See how the app works again';

  @override
  String get tourCustSearchTitle => 'Find a venue';

  @override
  String get tourCustSearchBody => 'Search by venue name or township to see courts near you.';

  @override
  String get tourCustDayTitle => 'Pick a day';

  @override
  String get tourCustDayBody => 'Choose the day you want to play. The open times below follow it.';

  @override
  String get tourCustVenuesTitle => 'Book in one tap';

  @override
  String get tourCustVenuesBody => 'Tap an open time to go straight to booking that court.';

  @override
  String get tourCustBookingsTitle => 'Your bookings';

  @override
  String get tourCustBookingsBody => 'See upcoming games and their status, or cancel if plans change.';

  @override
  String get tourCustNotifTitle => 'Stay updated';

  @override
  String get tourCustNotifBody => 'You\'ll be told here when the shop confirms or declines your booking.';

  @override
  String get tourCustProfileTitle => 'Profile & language';

  @override
  String get tourCustProfileBody => 'Edit your details, switch between Myanmar and English, or replay this tour.';

  @override
  String get tourShopStatsTitle => 'Today at a glance';

  @override
  String get tourShopStatsBody => 'Today\'s bookings, requests waiting for you and paid revenue.';

  @override
  String get tourShopBellTitle => 'Booking alerts';

  @override
  String get tourShopBellBody => 'New requests and cancellations arrive here. The badge shows how many are unread.';

  @override
  String get tourShopBookingsTitle => 'Manage bookings';

  @override
  String get tourShopBookingsBody => 'Confirm or decline requests and record payments.';

  @override
  String get tourShopStadiumsTitle => 'Stadiums & courts';

  @override
  String get tourShopStadiumsBody => 'Add venues, opening hours, courts and hourly prices.';

  @override
  String get tourShopCustomersBody => 'See who books with you and their booking history.';

  @override
  String get tourShopSettingsBody => 'Shop profile, blocked times, the blacklist and this tour.';

  @override
  String get tourHelp => 'How to use this page';

  @override
  String get tourSaveTitle => 'Save';

  @override
  String get tourSaveBody => 'Tap here when you\'re done. Nothing is saved until you do.';

  @override
  String get tourLoginEmailTitle => 'Your email';

  @override
  String get tourLoginEmailBody => 'Sign in with the email and password you registered with.';

  @override
  String get tourLoginForgotTitle => 'Forgot your password?';

  @override
  String get tourLoginForgotBody => 'Tap here and we\'ll email you a link to set a new one.';

  @override
  String get tourLoginRegisterTitle => 'New here?';

  @override
  String get tourLoginRegisterBody => 'Create a free account in about a minute.';

  @override
  String get tourLanguageTitle => 'Language';

  @override
  String get tourLanguageBody => 'Switch between Myanmar and English at any time.';

  @override
  String get tourRegisterNameTitle => 'Your name';

  @override
  String get tourRegisterNameBody => 'Shops see this name on your bookings.';

  @override
  String get tourRegisterPhoneTitle => 'Phone (optional)';

  @override
  String get tourRegisterPhoneBody => 'Lets the shop call you about your booking.';

  @override
  String get tourRegisterButtonTitle => 'Create your account';

  @override
  String get tourRegisterButtonBody => 'Tap when done. You can change your details later in Profile.';

  @override
  String get tourForgotEmailTitle => 'Reset your password';

  @override
  String get tourForgotEmailBody => 'Enter your account email.';

  @override
  String get tourForgotButtonTitle => 'Send the link';

  @override
  String get tourForgotButtonBody => 'Then check your inbox (and spam folder) and follow the link.';

  @override
  String get tourExploreSearchTitle => 'Search venues';

  @override
  String get tourExploreSearchBody => 'Type a venue name or township.';

  @override
  String get tourExploreFiltersTitle => 'Filter by facilities';

  @override
  String get tourExploreFiltersBody => 'Tap what you need, like parking or showers. Tap again to remove.';

  @override
  String get tourStadiumIntroTitle => 'Venue details';

  @override
  String get tourStadiumIntroBody => 'Opening hours, prices, facilities, location and the courts of this venue.';

  @override
  String get tourStadiumCourtsTitle => 'Pick a court';

  @override
  String get tourStadiumCourtsBody => 'Tap a court to see its free times.';

  @override
  String get tourStadiumBookTitle => 'Book a court';

  @override
  String get tourStadiumBookBody => 'Or tap here to choose the court, day and time.';

  @override
  String get tourSlotsCourtTitle => 'Choose a court';

  @override
  String get tourSlotsCourtBody => 'Each court can have its own price.';

  @override
  String get tourSlotsDayTitle => 'Choose a day';

  @override
  String get tourSlotsDayBody => 'You can book up to 30 days ahead.';

  @override
  String get tourSlotsGridTitle => 'Pick your time';

  @override
  String get tourSlotsGridBody => 'Tap a start time, then the next free slots to play longer. Grey slots are booked or blocked.';

  @override
  String get tourSlotsContinueTitle => 'Continue';

  @override
  String get tourSlotsContinueBody => 'Check the time and price, then send your request.';

  @override
  String get tourReviewIntroTitle => 'Check your booking';

  @override
  String get tourReviewIntroBody => 'Make sure the venue, date, time and price are right.';

  @override
  String get tourReviewSendTitle => 'Send your request';

  @override
  String get tourReviewSendBody => 'The shop confirms or declines it and we notify you. You pay at the venue.';

  @override
  String get tourConfirmIntroTitle => 'Request sent';

  @override
  String get tourConfirmIntroBody => 'Your booking is pending until the shop confirms it. You\'ll get a notification.';

  @override
  String get tourConfirmViewTitle => 'View your booking';

  @override
  String get tourConfirmViewBody => 'Check its status and details any time.';

  @override
  String get tourBookingsIntroTitle => 'Booking status';

  @override
  String get tourBookingsIntroBody => 'Pending: waiting for the shop. Confirmed: see you there. Declined or cancelled: the time is free again.';

  @override
  String get tourBookingsTabsTitle => 'Upcoming and past';

  @override
  String get tourBookingsTabsBody => 'Switch between games to come and games already played.';

  @override
  String get tourBookingDetailIntroTitle => 'Your booking';

  @override
  String get tourBookingDetailIntroBody => 'Status, time, court and price of this booking.';

  @override
  String get tourBookingDetailVenueTitle => 'Venue';

  @override
  String get tourBookingDetailVenueBody => 'Open the venue page for its location and directions.';

  @override
  String get tourBookingDetailCancelTitle => 'Cancel';

  @override
  String get tourBookingDetailCancelBody => 'Plans changed? Cancel before the start time so someone else can play.';

  @override
  String get tourNotifIntroTitle => 'Your notifications';

  @override
  String get tourNotifIntroBody => 'Booking updates appear here. Tap one to open that booking.';

  @override
  String get tourNotifShopIntroBody => 'New booking requests and cancellations appear here. Tap one to open that booking.';

  @override
  String get tourNotifMarkTitle => 'Mark all read';

  @override
  String get tourNotifMarkBody => 'Clears the unread dots in one tap.';

  @override
  String get tourProfileIntroTitle => 'Your profile';

  @override
  String get tourProfileIntroBody => 'Your name, email and phone, as shops see them.';

  @override
  String get tourProfileEditTitle => 'Edit profile';

  @override
  String get tourProfileEditBody => 'Change your name or phone number.';

  @override
  String get tourEditPhoneBody => 'Add a number so the shop can reach you about a booking.';

  @override
  String get tourPasswordCurrentTitle => 'Current password';

  @override
  String get tourPasswordCurrentBody => 'For your safety, enter the password you use now.';

  @override
  String get tourPasswordNewTitle => 'New password';

  @override
  String get tourPasswordNewBody => 'Use at least 8 characters, and not one from another app.';

  @override
  String get tourStaffStadiumFilterTitle => 'Filter by stadium';

  @override
  String get tourStaffStadiumFilterBody => 'Show bookings of one stadium only.';

  @override
  String get tourStaffFiltersTitle => 'Filter the list';

  @override
  String get tourStaffFiltersBody => 'Pending means waiting for a decision. Switch to upcoming, past or all bookings.';

  @override
  String get tourStaffBlockTitle => 'Block time';

  @override
  String get tourStaffBlockBody => 'Close a court for maintenance or a private event so nobody can book it.';

  @override
  String get tourStaffDetailIntroTitle => 'Booking';

  @override
  String get tourStaffDetailIntroBody => 'Customer, time, court, price and payment. Tap the customer to see their history.';

  @override
  String get tourStaffConfirmTitle => 'Confirm';

  @override
  String get tourStaffConfirmBody => 'Accept the request. The customer gets a notification.';

  @override
  String get tourStaffPaymentTitle => 'Payment';

  @override
  String get tourStaffPaymentBody => 'Record the payment step by step: pending, then paid.';

  @override
  String get tourStaffRejectTitle => 'Decline';

  @override
  String get tourStaffRejectBody => 'Frees the time for others. The customer is notified.';

  @override
  String get tourShopCustomersIntroBody => 'Everyone who has booked at your shop. Tap a name for details.';

  @override
  String get tourCustomerSearchTitle => 'Find a customer';

  @override
  String get tourCustomerSearchBody => 'Search by name or phone number.';

  @override
  String get tourCustomerDetailIntroTitle => 'Customer';

  @override
  String get tourCustomerDetailIntroBody => 'Contact details and booking history.';

  @override
  String get tourBlacklistActionTitle => 'Blacklist';

  @override
  String get tourBlacklistActionBody => 'Stops repeat no-shows from booking at your shop. Other shops aren\'t affected.';

  @override
  String get tourShopSettingsIntroTitle => 'Settings';

  @override
  String get tourShopSettingsIntroBody => 'Shop profile, blocked times, blacklist and stadiums in one place.';

  @override
  String get tourShopProfileIntroTitle => 'Shop profile';

  @override
  String get tourShopProfileIntroBody => 'How your shop appears to customers.';

  @override
  String get tourShopProfileEditTitle => 'Edit';

  @override
  String get tourShopProfileEditBody => 'Update the name, phone and address.';

  @override
  String get tourStadiumsIntroTitle => 'Your stadiums';

  @override
  String get tourStadiumsIntroBody => 'Each stadium has its own opening hours and courts. Tap one to manage it.';

  @override
  String get tourStadiumsAddTitle => 'Add a stadium';

  @override
  String get tourStadiumsAddBody => 'Start here: add your venue, then its courts.';

  @override
  String get tourStadiumEditTitle => 'Edit stadium';

  @override
  String get tourStadiumEditBody => 'Change the name, address, opening hours and facilities.';

  @override
  String get tourStadiumAddCourtTitle => 'Add a court';

  @override
  String get tourStadiumAddCourtBody => 'Each court has its own price and slot length.';

  @override
  String get tourStadiumFormNameTitle => 'Stadium name';

  @override
  String get tourStadiumFormNameBody => 'The name customers see and search for.';

  @override
  String get tourStadiumFormMapTitle => 'Map location';

  @override
  String get tourStadiumFormMapBody => 'Pin the venue so customers get directions.';

  @override
  String get tourStadiumFormHoursTitle => 'Opening hours';

  @override
  String get tourStadiumFormHoursBody => 'Customers can only book inside these hours.';

  @override
  String get tourStadiumFormFacilitiesTitle => 'Facilities';

  @override
  String get tourStadiumFormFacilitiesBody => 'Tick what you offer. Customers filter venues by these.';

  @override
  String get tourCourtIntroTitle => 'Court';

  @override
  String get tourCourtIntroBody => 'Price, slot length and whether customers can book this court.';

  @override
  String get tourCourtEditTitle => 'Edit court';

  @override
  String get tourCourtEditBody => 'Change the name or price, or turn bookings off.';

  @override
  String get tourCourtFormNameTitle => 'Court name';

  @override
  String get tourCourtFormNameBody => 'For example “Court A” or “Indoor pitch”.';

  @override
  String get tourCourtFormPriceTitle => 'Hourly price';

  @override
  String get tourCourtFormPriceBody => 'In kyat per hour. The booking price is worked out from it.';

  @override
  String get tourCourtFormSlotTitle => 'Slot length';

  @override
  String get tourCourtFormSlotBody => '30 or 60 minutes. It can\'t be changed later, so choose carefully.';

  @override
  String get tourBlockedIntroTitle => 'Blocked times';

  @override
  String get tourBlockedIntroBody => 'Times you closed. Customers can\'t book them.';

  @override
  String get tourBlockedAddBody => 'Close a court for maintenance, cleaning or an event.';

  @override
  String get tourBlockFormWhereTitle => 'Where';

  @override
  String get tourBlockFormWhereBody => 'Choose the stadium, then the court to close.';

  @override
  String get tourBlockFormButtonBody => 'Booked times can\'t be blocked. Decline that booking first.';

  @override
  String get tourBlacklistIntroTitle => 'Blacklist';

  @override
  String get tourBlacklistIntroBody => 'Customers here can\'t make new bookings at your shop. Tap the remove icon to allow them again.';

  @override
  String get tourMapTitle => 'Move the map';

  @override
  String get tourMapBody => 'Drag until the pin sits on your venue. Pinch to zoom.';

  @override
  String get tourMapUseTitle => 'Use this location';

  @override
  String get tourMapUseBody => 'Saves the pin to the stadium form.';

  @override
  String get consolePlatform => 'Platform';

  @override
  String get consoleStatus => 'Status';

  @override
  String get consoleSearchShops => 'Search shops';

  @override
  String get consoleStatusListing => 'Status & listing';

  @override
  String get consoleActions => 'Actions';

  @override
  String get consoleActivity => 'Activity';

  @override
  String get consoleContact => 'Contact';

  @override
  String get consolePayment => 'Payment';

  @override
  String get consoleWhen => 'When';

  @override
  String get consolePreferences => 'Preferences';

  @override
  String get consoleActive => 'Active';

  @override
  String get consoleUpcoming => 'Upcoming';

  @override
  String get consoleSent => 'Sent';

  @override
  String get consoleOverview => 'Overview';

  @override
  String get consoleSearchBookings => 'Search customer or stadium';

  @override
  String get consoleAllShops => 'All shops';

  @override
  String get consoleRole => 'Role';

  @override
  String get consoleNoMatches => 'Nothing matches';

  @override
  String get shopLocationHint => 'Pick the shop on Google Map. The address fills in from the pin.';

  @override
  String get shopLocationFinding => 'Finding the address…';

  @override
  String get shopLocationNoAddress => 'Couldn\'t find a street address for this pin. The pin is still saved and directions will work.';

  @override
  String get stadiumLocationHint => 'Pick the stadium on Google Map. The address fills in from the pin.';

  @override
  String get pickLocationNoAddress => 'No address found here — the pin still works for directions.';
}
