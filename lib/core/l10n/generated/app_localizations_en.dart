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
  String get homeReady => 'Ready to play?';

  @override
  String get homeSearchHint => 'Search stadiums or townships';

  @override
  String get homeNextGame => 'Your next game';

  @override
  String get homeAllBookings => 'All bookings';

  @override
  String get homeNoGames => 'No games booked. Pick a court below.';

  @override
  String get homePopular => 'Popular near you';

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
}
