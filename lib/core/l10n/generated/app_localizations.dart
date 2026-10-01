import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my')
  ];

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Book your court in seconds'**
  String get splashTagline;

  /// No description provided for @splashSettingUp.
  ///
  /// In en, this message translates to:
  /// **'Setting up your account…'**
  String get splashSettingUp;

  /// No description provided for @splashLoadingAccount.
  ///
  /// In en, this message translates to:
  /// **'Loading your account'**
  String get splashLoadingAccount;

  /// No description provided for @splashLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your account'**
  String get splashLoadError;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get commonSaveChanges;

  /// No description provided for @commonDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get commonDiscard;

  /// No description provided for @commonKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get commonKeepEditing;

  /// No description provided for @commonDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get commonDiscardTitle;

  /// No description provided for @commonNotAdded.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get commonNotAdded;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language'**
  String get languageSubtitle;

  /// No description provided for @languageMyanmar.
  ///
  /// In en, this message translates to:
  /// **'မြန်မာ'**
  String get languageMyanmar;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @demoBanner.
  ///
  /// In en, this message translates to:
  /// **'Sample data · preview only, changes are not saved'**
  String get demoBanner;

  /// No description provided for @previewOnly.
  ///
  /// In en, this message translates to:
  /// **'{action} · preview only, nothing was saved'**
  String previewOnly(String action);

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutConfirmTitle;

  /// No description provided for @logOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to log in again to use the app.'**
  String get logOutConfirmMessage;

  /// No description provided for @stayLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Stay logged in'**
  String get stayLoggedIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @accountUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Account unavailable'**
  String get accountUnavailableTitle;

  /// No description provided for @accountDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled. Contact support if you think this is a mistake.'**
  String get accountDisabledMessage;

  /// No description provided for @accountMissingShopMessage.
  ///
  /// In en, this message translates to:
  /// **'Your shop access isn\'t set up yet. Contact the platform team.'**
  String get accountMissingShopMessage;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @errorOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get errorOfflineTitle;

  /// No description provided for @errorNoAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access'**
  String get errorNoAccessTitle;

  /// No description provided for @errorNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get errorNotFoundTitle;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Please log in again to continue.'**
  String get errAuthentication;

  /// No description provided for @errInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get errInvalidCredentials;

  /// No description provided for @errInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get errInvalidEmail;

  /// No description provided for @errEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Log in instead?'**
  String get errEmailInUse;

  /// No description provided for @errWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters.'**
  String get errWeakPassword;

  /// No description provided for @errTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in a few minutes.'**
  String get errTooManyRequests;

  /// No description provided for @errIncorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Your current password is incorrect.'**
  String get errIncorrectPassword;

  /// No description provided for @errSetupTimeout.
  ///
  /// In en, this message translates to:
  /// **'Your account didn\'t finish loading. Check your connection and try again.'**
  String get errSetupTimeout;

  /// No description provided for @errUnauthorizedRole.
  ///
  /// In en, this message translates to:
  /// **'This account doesn\'t have access to the app. Contact support.'**
  String get errUnauthorizedRole;

  /// No description provided for @errPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do that.'**
  String get errPermissionDenied;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Check your connection and try again.'**
  String get errNetwork;

  /// No description provided for @errNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find what you were looking for.'**
  String get errNotFound;

  /// No description provided for @errInvalidVenueDetails.
  ///
  /// In en, this message translates to:
  /// **'Some details aren\'t valid. Check the form and try again.'**
  String get errInvalidVenueDetails;

  /// No description provided for @errShopAdminAssignment.
  ///
  /// In en, this message translates to:
  /// **'This account can\'t be made a shop admin.'**
  String get errShopAdminAssignment;

  /// No description provided for @errBookingConflict.
  ///
  /// In en, this message translates to:
  /// **'That time was just booked by someone else. Pick another time.'**
  String get errBookingConflict;

  /// No description provided for @errCourtUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This court isn\'t available for booking right now.'**
  String get errCourtUnavailable;

  /// No description provided for @errStadiumUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This stadium isn\'t available for booking right now.'**
  String get errStadiumUnavailable;

  /// No description provided for @errShopUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This venue isn\'t taking bookings right now.'**
  String get errShopUnavailable;

  /// No description provided for @errInvalidBookingTime.
  ///
  /// In en, this message translates to:
  /// **'That time can\'t be booked. Check the opening hours and try another time.'**
  String get errInvalidBookingTime;

  /// No description provided for @errBookingTooLong.
  ///
  /// In en, this message translates to:
  /// **'You can book up to 4 slots at a time.'**
  String get errBookingTooLong;

  /// No description provided for @errProfileIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Add your name in Profile before booking.'**
  String get errProfileIncomplete;

  /// No description provided for @errInvalidBookingChange.
  ///
  /// In en, this message translates to:
  /// **'This booking can\'t be changed that way anymore.'**
  String get errInvalidBookingChange;

  /// No description provided for @errInvalidDate.
  ///
  /// In en, this message translates to:
  /// **'That date can\'t be booked. Choose another date.'**
  String get errInvalidDate;

  /// No description provided for @errServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again.'**
  String get errServer;

  /// No description provided for @errUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errUnknown;

  /// No description provided for @valNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get valNameRequired;

  /// No description provided for @valNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use 80 characters or fewer'**
  String get valNameTooLong;

  /// No description provided for @valEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get valEmailRequired;

  /// No description provided for @valEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get valEmailInvalid;

  /// No description provided for @valPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get valPhoneInvalid;

  /// No description provided for @valPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get valPasswordRequired;

  /// No description provided for @valPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get valPasswordTooShort;

  /// No description provided for @valCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get valCurrentPasswordRequired;

  /// No description provided for @valPasswordSame.
  ///
  /// In en, this message translates to:
  /// **'Choose a password different from your current one'**
  String get valPasswordSame;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navStadiums.
  ///
  /// In en, this message translates to:
  /// **'Stadiums'**
  String get navStadiums;

  /// No description provided for @navCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get navCustomers;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navShops.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get navShops;

  /// No description provided for @navBadgeNew.
  ///
  /// In en, this message translates to:
  /// **'{label}, {count} new'**
  String navBadgeNew(String label, int count);

  /// No description provided for @bookingPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingPending;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingConfirmed;

  /// No description provided for @bookingRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get bookingRejected;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingCancelled;

  /// No description provided for @bookingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingCompleted;

  /// No description provided for @paymentUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get paymentUnpaid;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get paymentPending;

  /// No description provided for @paymentPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentPaid;

  /// No description provided for @paymentRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get paymentRefunded;

  /// No description provided for @shopPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get shopPendingReview;

  /// No description provided for @shopActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get shopActive;

  /// No description provided for @shopSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get shopSuspended;

  /// No description provided for @shopRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get shopRejected;

  /// No description provided for @shopInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get shopInactive;

  /// No description provided for @shopListed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get shopListed;

  /// No description provided for @shopUnlisted.
  ///
  /// In en, this message translates to:
  /// **'Unlisted'**
  String get shopUnlisted;

  /// No description provided for @bookingStatusPrefix.
  ///
  /// In en, this message translates to:
  /// **'Booking status'**
  String get bookingStatusPrefix;

  /// No description provided for @paymentStatusPrefix.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get paymentStatusPrefix;

  /// No description provided for @facilityParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get facilityParking;

  /// No description provided for @facilityShower.
  ///
  /// In en, this message translates to:
  /// **'Shower'**
  String get facilityShower;

  /// No description provided for @facilityChangingRoom.
  ///
  /// In en, this message translates to:
  /// **'Changing room'**
  String get facilityChangingRoom;

  /// No description provided for @facilityDrinkingWater.
  ///
  /// In en, this message translates to:
  /// **'Drinking water'**
  String get facilityDrinkingWater;

  /// No description provided for @facilityFloodLights.
  ///
  /// In en, this message translates to:
  /// **'Flood lights'**
  String get facilityFloodLights;

  /// No description provided for @facilitySeating.
  ///
  /// In en, this message translates to:
  /// **'Seating'**
  String get facilitySeating;

  /// No description provided for @facilityRestroom.
  ///
  /// In en, this message translates to:
  /// **'Restroom'**
  String get facilityRestroom;

  /// No description provided for @facilityCafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get facilityCafe;

  /// No description provided for @facilityEquipmentRental.
  ///
  /// In en, this message translates to:
  /// **'Equipment rental'**
  String get facilityEquipmentRental;

  /// No description provided for @reasonMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get reasonMaintenance;

  /// No description provided for @reasonPrivateEvent.
  ///
  /// In en, this message translates to:
  /// **'Private event'**
  String get reasonPrivateEvent;

  /// No description provided for @reasonCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get reasonCleaning;

  /// No description provided for @reasonTournament.
  ///
  /// In en, this message translates to:
  /// **'Tournament'**
  String get reasonTournament;

  /// No description provided for @reasonTemporaryClosure.
  ///
  /// In en, this message translates to:
  /// **'Temporary closure'**
  String get reasonTemporaryClosure;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reasonOther;

  /// No description provided for @slotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get slotAvailable;

  /// No description provided for @slotSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get slotSelected;

  /// No description provided for @slotBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get slotBooked;

  /// No description provided for @slotBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get slotBlocked;

  /// No description provided for @slotClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get slotClosed;

  /// No description provided for @slotUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get slotUnavailable;

  /// No description provided for @dayToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dayToday;

  /// No description provided for @dayTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dayTomorrow;

  /// No description provided for @dayYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dayYesterday;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @durationOneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get durationOneHour;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours'**
  String durationHours(String hours);

  /// No description provided for @agoJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get agoJustNow;

  /// No description provided for @agoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String agoMinutes(int count);

  /// No description provided for @agoHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String agoHours(int count);

  /// No description provided for @agoDays.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String agoDays(int count);

  /// No description provided for @loginHeadline.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginHeadline;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to book your next game.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLink;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get newHere;

  /// No description provided for @createAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountLink;

  /// No description provided for @registerHeadline.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerHeadline;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book futsal courts in a few taps.'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @phoneOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptionalLabel;

  /// No description provided for @phoneHelper.
  ///
  /// In en, this message translates to:
  /// **'Venues use this to reach you about bookings'**
  String get phoneHelper;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordHelper;

  /// No description provided for @termsNote.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the Terms and Privacy Policy.'**
  String get termsNote;

  /// No description provided for @venueOwnerNote.
  ///
  /// In en, this message translates to:
  /// **'Own a futsal venue? Shop accounts are set up by our team — contact us to join.'**
  String get venueOwnerNote;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @forgotHeadline.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotHeadline;

  /// No description provided for @forgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link.'**
  String get forgotSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to log in'**
  String get backToLogin;

  /// No description provided for @resetSentHeadline.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get resetSentHeadline;

  /// No description provided for @resetSentMessage.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for {email}, a reset link is on its way.'**
  String resetSentMessage(String email);

  /// No description provided for @resetResent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent again'**
  String get resetResent;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @addYourName.
  ///
  /// In en, this message translates to:
  /// **'Add your name'**
  String get addYourName;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @profileDiscardMessage.
  ///
  /// In en, this message translates to:
  /// **'Your edits to your profile won\'t be saved.'**
  String get profileDiscardMessage;

  /// No description provided for @emailCantChange.
  ///
  /// In en, this message translates to:
  /// **'Email can\'t be changed here'**
  String get emailCantChange;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePassword;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading your profile'**
  String get loadingProfile;

  /// No description provided for @profileNotReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile isn\'t ready yet'**
  String get profileNotReadyTitle;

  /// No description provided for @profileNotReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'This is taking longer than usual. Check your connection and try again.'**
  String get profileNotReadyMessage;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search stadiums or townships'**
  String get homeSearchHint;

  /// No description provided for @homeNextGame.
  ///
  /// In en, this message translates to:
  /// **'Your next game'**
  String get homeNextGame;

  /// No description provided for @homeAllBookings.
  ///
  /// In en, this message translates to:
  /// **'All bookings'**
  String get homeAllBookings;

  /// No description provided for @exploreEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No stadiums found'**
  String get exploreEmptyTitle;

  /// No description provided for @exploreEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another name or remove a filter.'**
  String get exploreEmptyMessage;

  /// No description provided for @priceFromPerHour.
  ///
  /// In en, this message translates to:
  /// **'From {price}/hr'**
  String priceFromPerHour(String price);

  /// No description provided for @pricePerHour.
  ///
  /// In en, this message translates to:
  /// **'{price}/hr'**
  String pricePerHour(String price);

  /// No description provided for @pricePerHourLong.
  ///
  /// In en, this message translates to:
  /// **'{price} / hour'**
  String pricePerHourLong(String price);

  /// No description provided for @priceOnRequest.
  ///
  /// In en, this message translates to:
  /// **'Price on request'**
  String get priceOnRequest;

  /// No description provided for @priceFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get priceFrom;

  /// No description provided for @bookACourt.
  ///
  /// In en, this message translates to:
  /// **'Book a court'**
  String get bookACourt;

  /// No description provided for @openDaily.
  ///
  /// In en, this message translates to:
  /// **'Open {hours} daily'**
  String openDaily(String hours);

  /// No description provided for @byShop.
  ///
  /// In en, this message translates to:
  /// **'by {shop}'**
  String byShop(String shop);

  /// No description provided for @facilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilitiesTitle;

  /// No description provided for @courtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Courts'**
  String get courtsTitle;

  /// No description provided for @upToPlayers.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} players'**
  String upToPlayers(int count);

  /// No description provided for @slotLengthLabel.
  ///
  /// In en, this message translates to:
  /// **'{minutes}-min slots'**
  String slotLengthLabel(int minutes);

  /// No description provided for @courtLabel.
  ///
  /// In en, this message translates to:
  /// **'Court'**
  String get courtLabel;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLabel;

  /// No description provided for @pickStartTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a start time'**
  String get pickStartTime;

  /// No description provided for @slotRules.
  ///
  /// In en, this message translates to:
  /// **'Up to {max} consecutive {minutes}-min slots · {price}/hr'**
  String slotRules(int max, int minutes, String price);

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review booking'**
  String get reviewTitle;

  /// No description provided for @reviewNothingTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review'**
  String get reviewNothingTitle;

  /// No description provided for @reviewNothingMessage.
  ///
  /// In en, this message translates to:
  /// **'Pick a court and a time first.'**
  String get reviewNothingMessage;

  /// No description provided for @reviewPickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a time'**
  String get reviewPickTime;

  /// No description provided for @requestBookingButton.
  ///
  /// In en, this message translates to:
  /// **'Request booking · {total}'**
  String requestBookingButton(String total);

  /// No description provided for @bookingRequestAction.
  ///
  /// In en, this message translates to:
  /// **'Booking request'**
  String get bookingRequestAction;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @payAtVenueNote.
  ///
  /// In en, this message translates to:
  /// **'Pay at the venue. The shop confirms your request, usually within a few hours.'**
  String get payAtVenueNote;

  /// No description provided for @confirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking requested'**
  String get confirmTitle;

  /// No description provided for @confirmMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you as soon as {stadium} confirms.'**
  String confirmMessage(String stadium);

  /// No description provided for @totalPayAtVenue.
  ///
  /// In en, this message translates to:
  /// **'Total · pay at the venue'**
  String get totalPayAtVenue;

  /// No description provided for @viewBooking.
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get viewBooking;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming ({count})'**
  String tabUpcoming(int count);

  /// No description provided for @tabPast.
  ///
  /// In en, this message translates to:
  /// **'Past ({count})'**
  String tabPast(int count);

  /// No description provided for @emptyUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming games'**
  String get emptyUpcomingTitle;

  /// No description provided for @emptyUpcomingMessage.
  ///
  /// In en, this message translates to:
  /// **'Book a court and it shows up here.'**
  String get emptyUpcomingMessage;

  /// No description provided for @emptyPastTitle.
  ///
  /// In en, this message translates to:
  /// **'No past bookings'**
  String get emptyPastTitle;

  /// No description provided for @emptyPastMessage.
  ///
  /// In en, this message translates to:
  /// **'Games you have played appear here.'**
  String get emptyPastMessage;

  /// No description provided for @allStadiums.
  ///
  /// In en, this message translates to:
  /// **'All stadiums ({count})'**
  String allStadiums(int count);

  /// No description provided for @bookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get bookingTitle;

  /// No description provided for @viewVenue.
  ///
  /// In en, this message translates to:
  /// **'View venue'**
  String get viewVenue;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get cancelBookingTitle;

  /// No description provided for @cancelBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'The court will be released for others.'**
  String get cancelBookingMessage;

  /// No description provided for @keepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepIt;

  /// No description provided for @reasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String reasonLabel(String reason);

  /// No description provided for @venueLabel.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get venueLabel;

  /// No description provided for @shopLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopLabel;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhone;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @markAllReadAction.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllReadAction;

  /// No description provided for @unreadPrefix.
  ///
  /// In en, this message translates to:
  /// **'Unread.'**
  String get unreadPrefix;

  /// No description provided for @formDiscardMessage.
  ///
  /// In en, this message translates to:
  /// **'Your changes won\'t be saved.'**
  String get formDiscardMessage;

  /// No description provided for @formFixFields.
  ///
  /// In en, this message translates to:
  /// **'Fix the highlighted fields'**
  String get formFixFields;

  /// No description provided for @notFoundRemoved.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed.'**
  String get notFoundRemoved;

  /// No description provided for @addressOptional.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get addressOptional;

  /// No description provided for @townshipOptional.
  ///
  /// In en, this message translates to:
  /// **'Township (optional)'**
  String get townshipOptional;

  /// No description provided for @cityOptional.
  ///
  /// In en, this message translates to:
  /// **'City (optional)'**
  String get cityOptional;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// No description provided for @openForBookings.
  ///
  /// In en, this message translates to:
  /// **'Open for bookings'**
  String get openForBookings;

  /// No description provided for @valMaxChars.
  ///
  /// In en, this message translates to:
  /// **'Use {max} characters or fewer'**
  String valMaxChars(int max);

  /// No description provided for @valPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the price per hour'**
  String get valPriceRequired;

  /// No description provided for @valPriceDigits.
  ///
  /// In en, this message translates to:
  /// **'Use whole kyat, digits only'**
  String get valPriceDigits;

  /// No description provided for @valPriceMax.
  ///
  /// In en, this message translates to:
  /// **'Enter a price up to {max}'**
  String valPriceMax(int max);

  /// No description provided for @valCapacityRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 1 to {max}'**
  String valCapacityRange(int max);

  /// No description provided for @stadiumNew.
  ///
  /// In en, this message translates to:
  /// **'New stadium'**
  String get stadiumNew;

  /// No description provided for @stadiumEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit stadium'**
  String get stadiumEdit;

  /// No description provided for @stadiumNotFound.
  ///
  /// In en, this message translates to:
  /// **'Stadium not found'**
  String get stadiumNotFound;

  /// No description provided for @stadiumNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Stadium name'**
  String get stadiumNameLabel;

  /// No description provided for @stadiumNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the stadium name'**
  String get stadiumNameRequired;

  /// No description provided for @stadiumAdded.
  ///
  /// In en, this message translates to:
  /// **'Stadium added. Now add its courts.'**
  String get stadiumAdded;

  /// No description provided for @stadiumUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stadium updated'**
  String get stadiumUpdated;

  /// No description provided for @openingHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get openingHoursTitle;

  /// No description provided for @opensLabel.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get opensLabel;

  /// No description provided for @closesLabel.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get closesLabel;

  /// No description provided for @openingHoursNote.
  ///
  /// In en, this message translates to:
  /// **'Stadiums open on the hour. Changing hours never moves or cancels existing bookings.'**
  String get openingHoursNote;

  /// No description provided for @stadiumOpenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When off, customers can\'t see or book this stadium.'**
  String get stadiumOpenSubtitle;

  /// No description provided for @addStadium.
  ///
  /// In en, this message translates to:
  /// **'Add stadium'**
  String get addStadium;

  /// No description provided for @courtNew.
  ///
  /// In en, this message translates to:
  /// **'New court'**
  String get courtNew;

  /// No description provided for @courtEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit court'**
  String get courtEdit;

  /// No description provided for @courtNotFound.
  ///
  /// In en, this message translates to:
  /// **'Court not found'**
  String get courtNotFound;

  /// No description provided for @courtNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Court name'**
  String get courtNameLabel;

  /// No description provided for @courtNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a court name, e.g. \"Court 1\"'**
  String get courtNameRequired;

  /// No description provided for @courtAdded.
  ///
  /// In en, this message translates to:
  /// **'Court added'**
  String get courtAdded;

  /// No description provided for @courtUpdated.
  ///
  /// In en, this message translates to:
  /// **'Court updated'**
  String get courtUpdated;

  /// No description provided for @pricePerHourLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per hour ({currency})'**
  String pricePerHourLabel(String currency);

  /// No description provided for @priceHelper.
  ///
  /// In en, this message translates to:
  /// **'Whole kyat. Existing bookings keep the price they were made at.'**
  String get priceHelper;

  /// No description provided for @slotLengthTitle.
  ///
  /// In en, this message translates to:
  /// **'Slot length'**
  String get slotLengthTitle;

  /// No description provided for @slotLengthNote.
  ///
  /// In en, this message translates to:
  /// **'Customers book 1–{max} slots at a time. This can\'t be changed after the court is created.'**
  String slotLengthNote(int max);

  /// No description provided for @slotLengthFixed.
  ///
  /// In en, this message translates to:
  /// **'{minutes}-minute slots. Fixed when the court was created so existing bookings can\'t overlap new ones.'**
  String slotLengthFixed(int minutes);

  /// No description provided for @playersOptional.
  ///
  /// In en, this message translates to:
  /// **'Players (optional)'**
  String get playersOptional;

  /// No description provided for @playersHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get playersHint;

  /// No description provided for @surfaceOptional.
  ///
  /// In en, this message translates to:
  /// **'Surface (optional)'**
  String get surfaceOptional;

  /// No description provided for @surfaceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Artificial turf'**
  String get surfaceHint;

  /// No description provided for @courtOpenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When off, customers can\'t see or book this court. Existing bookings stay.'**
  String get courtOpenSubtitle;

  /// No description provided for @addCourt.
  ///
  /// In en, this message translates to:
  /// **'Add court'**
  String get addCourt;

  /// No description provided for @shopNew.
  ///
  /// In en, this message translates to:
  /// **'New shop'**
  String get shopNew;

  /// No description provided for @shopEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit shop'**
  String get shopEdit;

  /// No description provided for @shopNotFound.
  ///
  /// In en, this message translates to:
  /// **'Shop not found'**
  String get shopNotFound;

  /// No description provided for @shopNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get shopNameLabel;

  /// No description provided for @shopNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the shop name'**
  String get shopNameRequired;

  /// No description provided for @shopCreated.
  ///
  /// In en, this message translates to:
  /// **'Shop created. Review it to approve.'**
  String get shopCreated;

  /// No description provided for @shopUpdated.
  ///
  /// In en, this message translates to:
  /// **'Shop updated'**
  String get shopUpdated;

  /// No description provided for @shopNewNote.
  ///
  /// In en, this message translates to:
  /// **'New shops start as \"Pending review\" and stay hidden from customers until you approve them.'**
  String get shopNewNote;

  /// No description provided for @shopPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'Shown to customers'**
  String get shopPhoneHelper;

  /// No description provided for @ownerPrivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner (private)'**
  String get ownerPrivateTitle;

  /// No description provided for @ownerPrivateNote.
  ///
  /// In en, this message translates to:
  /// **'Only you and this shop\'s admins can see these.'**
  String get ownerPrivateNote;

  /// No description provided for @ownerNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Owner name (optional)'**
  String get ownerNameOptional;

  /// No description provided for @ownerPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Owner phone (optional)'**
  String get ownerPhoneOptional;

  /// No description provided for @createShop.
  ///
  /// In en, this message translates to:
  /// **'Create shop'**
  String get createShop;

  /// No description provided for @addShopAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Add shop admin'**
  String get addShopAdminTitle;

  /// No description provided for @inviteIntro.
  ///
  /// In en, this message translates to:
  /// **'Ask the shop owner to sign up in the app with their email first. Then find their account here.'**
  String get inviteIntro;

  /// No description provided for @accountEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Account email'**
  String get accountEmailLabel;

  /// No description provided for @findAccount.
  ///
  /// In en, this message translates to:
  /// **'Find account'**
  String get findAccount;

  /// No description provided for @noAccountForEmail.
  ///
  /// In en, this message translates to:
  /// **'No account uses {email}. Ask them to sign up with this email, then try again.'**
  String noAccountForEmail(String email);

  /// No description provided for @nowShopAdmin.
  ///
  /// In en, this message translates to:
  /// **'{name} is now a shop admin'**
  String nowShopAdmin(String name);

  /// No description provided for @cantChangeOwnRole.
  ///
  /// In en, this message translates to:
  /// **'You can\'t change your own role.'**
  String get cantChangeOwnRole;

  /// No description provided for @platformAdminCantBeShopAdmin.
  ///
  /// In en, this message translates to:
  /// **'Platform admins can\'t be shop admins. Change their role first.'**
  String get platformAdminCantBeShopAdmin;

  /// No description provided for @alreadyAdminHere.
  ///
  /// In en, this message translates to:
  /// **'Already an admin of this shop.'**
  String get alreadyAdminHere;

  /// No description provided for @managesOtherShop.
  ///
  /// In en, this message translates to:
  /// **'This account manages another shop. Adding it here removes it from that shop.'**
  String get managesOtherShop;

  /// No description provided for @roleUnknownFix.
  ///
  /// In en, this message translates to:
  /// **'This account\'s role is unknown. Fix it in the console.'**
  String get roleUnknownFix;

  /// No description provided for @currentRole.
  ///
  /// In en, this message translates to:
  /// **'Current role: {role}'**
  String currentRole(String role);

  /// No description provided for @roleUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get roleUnknown;

  /// No description provided for @accountDisabledTag.
  ///
  /// In en, this message translates to:
  /// **'account disabled'**
  String get accountDisabledTag;

  /// No description provided for @makeShopAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make shop admin'**
  String get makeShopAdmin;

  /// No description provided for @rolePlatformAdmin.
  ///
  /// In en, this message translates to:
  /// **'Platform admin'**
  String get rolePlatformAdmin;

  /// No description provided for @roleShopAdmin.
  ///
  /// In en, this message translates to:
  /// **'Shop admin'**
  String get roleShopAdmin;

  /// No description provided for @roleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleCustomer;

  /// No description provided for @blockTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Block time'**
  String get blockTimeTitle;

  /// No description provided for @stadiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Stadium'**
  String get stadiumLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @slotsLabel.
  ///
  /// In en, this message translates to:
  /// **'Slots'**
  String get slotsLabel;

  /// No description provided for @reasonFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reasonFieldLabel;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @newAnnouncementTitle.
  ///
  /// In en, this message translates to:
  /// **'New announcement'**
  String get newAnnouncementTitle;

  /// No description provided for @sendTo.
  ///
  /// In en, this message translates to:
  /// **'Send to {audience}'**
  String sendTo(String audience);

  /// No description provided for @sendAnnouncementAction.
  ///
  /// In en, this message translates to:
  /// **'Send announcement'**
  String get sendAnnouncementAction;

  /// No description provided for @audienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Audience'**
  String get audienceLabel;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @audienceEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get audienceEveryone;

  /// No description provided for @audienceCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get audienceCustomers;

  /// No description provided for @audienceShopAdmins.
  ///
  /// In en, this message translates to:
  /// **'Shop admins'**
  String get audienceShopAdmins;

  /// No description provided for @errBlacklisted.
  ///
  /// In en, this message translates to:
  /// **'This venue isn\'t taking bookings from your account. Contact the venue.'**
  String get errBlacklisted;

  /// No description provided for @blacklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Blacklist'**
  String get blacklistTitle;

  /// No description provided for @blacklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customers who can\'t book at your shop'**
  String get blacklistSubtitle;

  /// No description provided for @blacklistIntro.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted customers can\'t make new bookings at your shop. Their existing bookings stay, and they can still book at other shops.'**
  String get blacklistIntro;

  /// No description provided for @blacklistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No one is blacklisted'**
  String get blacklistEmptyTitle;

  /// No description provided for @blacklistEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Blacklist a customer from their profile, or from a booking they didn\'t show up for.'**
  String get blacklistEmptyMessage;

  /// No description provided for @blacklistAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to blacklist'**
  String get blacklistAdd;

  /// No description provided for @blacklistNoShowAction.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t show up · blacklist'**
  String get blacklistNoShowAction;

  /// No description provided for @blacklistRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from blacklist'**
  String get blacklistRemove;

  /// No description provided for @blacklistRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the blacklist?'**
  String blacklistRemoveTitle(String name);

  /// No description provided for @blacklistRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'They\'ll be able to book at your shop again.'**
  String get blacklistRemoveMessage;

  /// No description provided for @blacklistRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get blacklistRemoveConfirm;

  /// No description provided for @blacklistKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get blacklistKeep;

  /// No description provided for @blacklistSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Blacklist {name}'**
  String blacklistSheetTitle(String name);

  /// No description provided for @blacklistSheetMessage.
  ///
  /// In en, this message translates to:
  /// **'They won\'t be able to make new bookings at your shop. Existing bookings stay.'**
  String get blacklistSheetMessage;

  /// No description provided for @blacklistReasonNoShow.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t show up'**
  String get blacklistReasonNoShow;

  /// No description provided for @blacklistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Blacklist'**
  String get blacklistConfirm;

  /// No description provided for @blacklistAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} is blacklisted'**
  String blacklistAdded(String name);

  /// No description provided for @blacklistRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} can book again'**
  String blacklistRemoved(String name);

  /// No description provided for @blacklistedBadge.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted'**
  String get blacklistedBadge;

  /// No description provided for @blacklistedOn.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted {date}'**
  String blacklistedOn(String date);

  /// No description provided for @stadiumsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first stadium'**
  String get stadiumsEmptyTitle;

  /// No description provided for @stadiumsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Set its opening hours, then add the courts customers can book.'**
  String get stadiumsEmptyMessage;

  /// No description provided for @staffFilterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get staffFilterUpcoming;

  /// No description provided for @staffFilterPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get staffFilterPast;

  /// No description provided for @staffFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get staffFilterAll;

  /// No description provided for @staffNoBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'No bookings here'**
  String get staffNoBookingsTitle;

  /// No description provided for @staffTryAnotherFilter.
  ///
  /// In en, this message translates to:
  /// **'Try another filter.'**
  String get staffTryAnotherFilter;

  /// No description provided for @markPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Mark payment pending'**
  String get markPaymentPending;

  /// No description provided for @markAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markAsPaid;

  /// No description provided for @markAsRefunded.
  ///
  /// In en, this message translates to:
  /// **'Mark as refunded'**
  String get markAsRefunded;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get confirmBooking;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get markAsCompleted;

  /// No description provided for @rejectBooking.
  ///
  /// In en, this message translates to:
  /// **'Reject booking'**
  String get rejectBooking;

  /// No description provided for @rejectBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject this booking?'**
  String get rejectBookingTitle;

  /// No description provided for @rejectBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'The customer is notified and the slots are released.'**
  String get rejectBookingMessage;

  /// No description provided for @rejectAction.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectAction;

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep booking'**
  String get keepBooking;

  /// No description provided for @searchNameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone'**
  String get searchNameOrPhone;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @bookingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 booking} other{{count} bookings}}'**
  String bookingCount(int count);

  /// No description provided for @lastPlayedOn.
  ///
  /// In en, this message translates to:
  /// **'last played {date}'**
  String lastPlayedOn(String date);

  /// No description provided for @joinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String joinedOn(String date);

  /// No description provided for @statusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusDisabled;

  /// No description provided for @accountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountPrefix;

  /// No description provided for @mmkOnPlatform.
  ///
  /// In en, this message translates to:
  /// **'MMK on the platform'**
  String get mmkOnPlatform;

  /// No description provided for @mmkAtYourShop.
  ///
  /// In en, this message translates to:
  /// **'MMK at your shop'**
  String get mmkAtYourShop;

  /// No description provided for @bookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Booking history'**
  String get bookingHistory;

  /// No description provided for @noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get noBookingsYet;

  /// No description provided for @totalPaidAmount.
  ///
  /// In en, this message translates to:
  /// **'Total paid: {amount}'**
  String totalPaidAmount(String amount);

  /// No description provided for @settingsShopProfile.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get settingsShopProfile;

  /// No description provided for @settingsShopProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Name, contact and address'**
  String get settingsShopProfileSub;

  /// No description provided for @blockedTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked times'**
  String get blockedTimesTitle;

  /// No description provided for @blockedTimesSub.
  ///
  /// In en, this message translates to:
  /// **'Maintenance, events, closures'**
  String get blockedTimesSub;

  /// No description provided for @stadiumsAndCourts.
  ///
  /// In en, this message translates to:
  /// **'Stadiums & courts'**
  String get stadiumsAndCourts;

  /// No description provided for @editShopProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit shop profile'**
  String get editShopProfile;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @shopStatusPrefix.
  ///
  /// In en, this message translates to:
  /// **'Shop status'**
  String get shopStatusPrefix;

  /// No description provided for @listingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Listing'**
  String get listingPrefix;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @statusManagedByPlatform.
  ///
  /// In en, this message translates to:
  /// **'Status and listing are managed by the platform team.'**
  String get statusManagedByPlatform;

  /// No description provided for @visibilityUnlisted.
  ///
  /// In en, this message translates to:
  /// **'Your shop is unlisted, so customers can\'t see or book it.'**
  String get visibilityUnlisted;

  /// No description provided for @visibilityPending.
  ///
  /// In en, this message translates to:
  /// **'Your shop is waiting for approval. Set up stadiums and courts now; customers see them once it is approved.'**
  String get visibilityPending;

  /// No description provided for @visibilitySuspended.
  ///
  /// In en, this message translates to:
  /// **'Your shop is suspended. Customers can\'t see or book it. Contact the platform team.'**
  String get visibilitySuspended;

  /// No description provided for @visibilityInactive.
  ///
  /// In en, this message translates to:
  /// **'Your shop isn\'t active. Customers can\'t see or book it.'**
  String get visibilityInactive;

  /// No description provided for @venueActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get venueActive;

  /// No description provided for @venueInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get venueInactive;

  /// No description provided for @visibleToCustomers.
  ///
  /// In en, this message translates to:
  /// **'Visible to customers'**
  String get visibleToCustomers;

  /// No description provided for @hiddenLabel.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hiddenLabel;

  /// No description provided for @discoveryPrefix.
  ///
  /// In en, this message translates to:
  /// **'Discovery'**
  String get discoveryPrefix;

  /// No description provided for @bookableLabel.
  ///
  /// In en, this message translates to:
  /// **'Bookable'**
  String get bookableLabel;

  /// No description provided for @noneListed.
  ///
  /// In en, this message translates to:
  /// **'None listed'**
  String get noneListed;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @noCourtsYet.
  ///
  /// In en, this message translates to:
  /// **'No courts yet'**
  String get noCourtsYet;

  /// No description provided for @noCourtsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a court with its price and slot length so customers can book it.'**
  String get noCourtsMessage;

  /// No description provided for @noPrice.
  ///
  /// In en, this message translates to:
  /// **'No price'**
  String get noPrice;

  /// No description provided for @noPriceSet.
  ///
  /// In en, this message translates to:
  /// **'No price set'**
  String get noPriceSet;

  /// No description provided for @pricePerHourTitle.
  ///
  /// In en, this message translates to:
  /// **'Price per hour'**
  String get pricePerHourTitle;

  /// No description provided for @slotMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String slotMinutesValue(int minutes);

  /// No description provided for @playersLabel.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get playersLabel;

  /// No description provided for @surfaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get surfaceLabel;

  /// No description provided for @blockCourtSub.
  ///
  /// In en, this message translates to:
  /// **'Close this court for maintenance, events and more'**
  String get blockCourtSub;

  /// No description provided for @blockedTimesNote.
  ///
  /// In en, this message translates to:
  /// **'Blocked times cannot be booked by customers.'**
  String get blockedTimesNote;

  /// No description provided for @removeBlock.
  ///
  /// In en, this message translates to:
  /// **'Remove block'**
  String get removeBlock;

  /// No description provided for @venueCounts.
  ///
  /// In en, this message translates to:
  /// **'{stadiums} stadiums · {courts} courts'**
  String venueCounts(int stadiums, int courts);

  /// No description provided for @statBookingsFooter.
  ///
  /// In en, this message translates to:
  /// **'bookings'**
  String get statBookingsFooter;

  /// No description provided for @statNeedReply.
  ///
  /// In en, this message translates to:
  /// **'need a reply'**
  String get statNeedReply;

  /// No description provided for @statCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get statCollected;

  /// No description provided for @statMmkFromPaid.
  ///
  /// In en, this message translates to:
  /// **'MMK from paid bookings'**
  String get statMmkFromPaid;

  /// No description provided for @statBookedWithYou.
  ///
  /// In en, this message translates to:
  /// **'booked with you'**
  String get statBookedWithYou;

  /// No description provided for @needsYourReply.
  ///
  /// In en, this message translates to:
  /// **'Needs your reply'**
  String get needsYourReply;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get allCaughtUp;

  /// No description provided for @allCaughtUpMessage.
  ///
  /// In en, this message translates to:
  /// **'New booking requests show up here.'**
  String get allCaughtUpMessage;

  /// No description provided for @todaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedule'**
  String get todaysSchedule;

  /// No description provided for @noGamesToday.
  ///
  /// In en, this message translates to:
  /// **'No games today'**
  String get noGamesToday;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @shopAdminsSub.
  ///
  /// In en, this message translates to:
  /// **'Who can manage this shop'**
  String get shopAdminsSub;

  /// No description provided for @explainPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for review. Hidden from customers; its admins can already set up stadiums and courts.'**
  String get explainPending;

  /// No description provided for @explainLive.
  ///
  /// In en, this message translates to:
  /// **'Live: customers can find and book it.'**
  String get explainLive;

  /// No description provided for @explainUnlisted.
  ///
  /// In en, this message translates to:
  /// **'Approved but unlisted: hidden from customers, no new bookings.'**
  String get explainUnlisted;

  /// No description provided for @explainSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended: hidden from customers, no new bookings. Existing bookings stay as they are.'**
  String get explainSuspended;

  /// No description provided for @explainRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected: hidden from customers.'**
  String get explainRejected;

  /// No description provided for @explainInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive: hidden from customers, no new bookings.'**
  String get explainInactive;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @approveAndList.
  ///
  /// In en, this message translates to:
  /// **'Approve and list'**
  String get approveAndList;

  /// No description provided for @shopApprovedListed.
  ///
  /// In en, this message translates to:
  /// **'Shop approved and listed'**
  String get shopApprovedListed;

  /// No description provided for @reactivateAction.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivateAction;

  /// No description provided for @shopReactivated.
  ///
  /// In en, this message translates to:
  /// **'Shop reactivated'**
  String get shopReactivated;

  /// No description provided for @deactivateShop.
  ///
  /// In en, this message translates to:
  /// **'Deactivate shop'**
  String get deactivateShop;

  /// No description provided for @shopDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Shop deactivated'**
  String get shopDeactivated;

  /// No description provided for @deactivateShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate this shop?'**
  String get deactivateShopTitle;

  /// No description provided for @deactivateShopMessage.
  ///
  /// In en, this message translates to:
  /// **'It will be hidden from customers and take no new bookings. You can reactivate it later.'**
  String get deactivateShopMessage;

  /// No description provided for @deactivateAction.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivateAction;

  /// No description provided for @shopRejectedDone.
  ///
  /// In en, this message translates to:
  /// **'Shop rejected'**
  String get shopRejectedDone;

  /// No description provided for @rejectShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject this shop?'**
  String get rejectShopTitle;

  /// No description provided for @rejectShopMessage.
  ///
  /// In en, this message translates to:
  /// **'It stays hidden from customers. You can still approve it later.'**
  String get rejectShopMessage;

  /// No description provided for @listedForCustomers.
  ///
  /// In en, this message translates to:
  /// **'Listed for customers'**
  String get listedForCustomers;

  /// No description provided for @listedForCustomersSub.
  ///
  /// In en, this message translates to:
  /// **'When off, the shop is hidden and takes no new bookings.'**
  String get listedForCustomersSub;

  /// No description provided for @shopListedDone.
  ///
  /// In en, this message translates to:
  /// **'Shop listed'**
  String get shopListedDone;

  /// No description provided for @shopUnlistedDone.
  ///
  /// In en, this message translates to:
  /// **'Shop unlisted'**
  String get shopUnlistedDone;

  /// No description provided for @suspendAction.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get suspendAction;

  /// No description provided for @shopSuspendedDone.
  ///
  /// In en, this message translates to:
  /// **'Shop suspended'**
  String get shopSuspendedDone;

  /// No description provided for @suspendShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Suspend this shop?'**
  String get suspendShopTitle;

  /// No description provided for @suspendShopMessage.
  ///
  /// In en, this message translates to:
  /// **'Customers stop seeing it and it takes no new bookings. Existing bookings are not cancelled.'**
  String get suspendShopMessage;

  /// No description provided for @ownerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get ownerNameLabel;

  /// No description provided for @ownerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner phone'**
  String get ownerPhoneLabel;

  /// No description provided for @suspensionReason.
  ///
  /// In en, this message translates to:
  /// **'Suspension reason'**
  String get suspensionReason;

  /// No description provided for @nothingToReview.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review'**
  String get nothingToReview;

  /// No description provided for @nothingToReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'New shops appear here until you approve or reject them.'**
  String get nothingToReviewMessage;

  /// No description provided for @noShopsYet.
  ///
  /// In en, this message translates to:
  /// **'No shops yet'**
  String get noShopsYet;

  /// No description provided for @noShopsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create the first shop, then assign its admin.'**
  String get noShopsMessage;

  /// No description provided for @shopAdminsOf.
  ///
  /// In en, this message translates to:
  /// **'{shop} admins'**
  String shopAdminsOf(String shop);

  /// No description provided for @addAdmin.
  ///
  /// In en, this message translates to:
  /// **'Add admin'**
  String get addAdmin;

  /// No description provided for @noAdminsYet.
  ///
  /// In en, this message translates to:
  /// **'No admins yet'**
  String get noAdminsYet;

  /// No description provided for @noAdminsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the person who runs this shop. They need a customer account first.'**
  String get noAdminsMessage;

  /// No description provided for @accountDisabledBadge.
  ///
  /// In en, this message translates to:
  /// **'Account disabled'**
  String get accountDisabledBadge;

  /// No description provided for @removeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Remove admin'**
  String get removeAdmin;

  /// No description provided for @removeAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this admin?'**
  String get removeAdminTitle;

  /// No description provided for @removeAdminMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} loses access to the shop right away and becomes a customer.'**
  String removeAdminMessage(String name);

  /// No description provided for @adminRemoved.
  ///
  /// In en, this message translates to:
  /// **'Admin removed'**
  String get adminRemoved;

  /// No description provided for @shopCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 shop} other{{count} shops}}'**
  String shopCount(int count);

  /// No description provided for @platformSummary.
  ///
  /// In en, this message translates to:
  /// **'{active} active · {pending} waiting for review'**
  String platformSummary(int active, int pending);

  /// No description provided for @activeShops.
  ///
  /// In en, this message translates to:
  /// **'Active shops'**
  String get activeShops;

  /// No description provided for @ofTotal.
  ///
  /// In en, this message translates to:
  /// **'of {total}'**
  String ofTotal(int total);

  /// No description provided for @toReview.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get toReview;

  /// No description provided for @newShopsFooter.
  ///
  /// In en, this message translates to:
  /// **'new shops'**
  String get newShopsFooter;

  /// No description provided for @lastTwoWeeks.
  ///
  /// In en, this message translates to:
  /// **'last 2 weeks'**
  String get lastTwoWeeks;

  /// No description provided for @waitingForReview.
  ///
  /// In en, this message translates to:
  /// **'Waiting for review'**
  String get waitingForReview;

  /// No description provided for @reviewAction.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewAction;

  /// No description provided for @latestBookings.
  ///
  /// In en, this message translates to:
  /// **'Latest bookings'**
  String get latestBookings;

  /// No description provided for @disableAccount.
  ///
  /// In en, this message translates to:
  /// **'Disable account'**
  String get disableAccount;

  /// No description provided for @disableUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable {name}?'**
  String disableUserTitle(String name);

  /// No description provided for @disableUserMessage.
  ///
  /// In en, this message translates to:
  /// **'They are signed out and cannot book until you enable the account again.'**
  String get disableUserMessage;

  /// No description provided for @disableAction.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disableAction;

  /// No description provided for @keepActive.
  ///
  /// In en, this message translates to:
  /// **'Keep active'**
  String get keepActive;

  /// No description provided for @enableAccount.
  ///
  /// In en, this message translates to:
  /// **'Enable account'**
  String get enableAccount;

  /// No description provided for @announcementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcementsTitle;

  /// No description provided for @announcementsSub.
  ///
  /// In en, this message translates to:
  /// **'Messages to customers and shops'**
  String get announcementsSub;

  /// No description provided for @shopsPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Shops pending review'**
  String get shopsPendingReview;

  /// No description provided for @newShort.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newShort;

  /// No description provided for @sentToPrefix.
  ///
  /// In en, this message translates to:
  /// **'Sent to'**
  String get sentToPrefix;

  /// No description provided for @homeOpenSlots.
  ///
  /// In en, this message translates to:
  /// **'Open times · {day}'**
  String homeOpenSlots(String day);

  /// No description provided for @homeNoOpenSlots.
  ///
  /// In en, this message translates to:
  /// **'Fully booked this day'**
  String get homeNoOpenSlots;

  /// No description provided for @bookSlotAt.
  ///
  /// In en, this message translates to:
  /// **'Book {court} at {time}'**
  String bookSlotAt(String court, String time);

  /// No description provided for @mapDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get mapDirections;

  /// No description provided for @mapOpenInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get mapOpenInGoogleMaps;

  /// No description provided for @mapOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open Google Maps'**
  String get mapOpenFailed;

  /// No description provided for @mapPinSemantics.
  ///
  /// In en, this message translates to:
  /// **'Map showing {name}. Opens Google Maps'**
  String mapPinSemantics(String name);

  /// No description provided for @locationNotSet.
  ///
  /// In en, this message translates to:
  /// **'No map location yet'**
  String get locationNotSet;

  /// No description provided for @locationPickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get locationPickOnMap;

  /// No description provided for @locationChangeOnMap.
  ///
  /// In en, this message translates to:
  /// **'Change on map'**
  String get locationChangeOnMap;

  /// No description provided for @locationClear.
  ///
  /// In en, this message translates to:
  /// **'Remove location'**
  String get locationClear;

  /// No description provided for @pickLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pin your venue'**
  String get pickLocationTitle;

  /// No description provided for @pickLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Move the map until the pin sits on your venue.'**
  String get pickLocationHint;

  /// No description provided for @useThisLocation.
  ///
  /// In en, this message translates to:
  /// **'Use this location'**
  String get useThisLocation;

  /// No description provided for @notifBookingRequestedTitle.
  ///
  /// In en, this message translates to:
  /// **'New booking request'**
  String get notifBookingRequestedTitle;

  /// No description provided for @notifBookingCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled by customer'**
  String get notifBookingCancelledTitle;

  /// No description provided for @notifBookingConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get notifBookingConfirmedTitle;

  /// No description provided for @notifBookingRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking declined'**
  String get notifBookingRejectedTitle;

  /// No description provided for @notifReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String notifReason(String reason);

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see here when a shop confirms or declines your booking.'**
  String get notificationsEmptyMessage;

  /// No description provided for @notificationsEmptyMessageShop.
  ///
  /// In en, this message translates to:
  /// **'New booking requests and cancellations will show up here.'**
  String get notificationsEmptyMessageShop;

  /// No description provided for @notificationsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open notifications'**
  String get notificationsOpen;

  /// No description provided for @notificationView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get notificationView;

  /// No description provided for @tourSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSkip;

  /// No description provided for @tourNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNext;

  /// No description provided for @tourBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tourBack;

  /// No description provided for @tourDone.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get tourDone;

  /// No description provided for @tourStepOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String tourStepOf(int current, int total);

  /// No description provided for @tourReplay.
  ///
  /// In en, this message translates to:
  /// **'App tour'**
  String get tourReplay;

  /// No description provided for @tourReplaySub.
  ///
  /// In en, this message translates to:
  /// **'See how the app works again'**
  String get tourReplaySub;

  /// No description provided for @tourCustSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a venue'**
  String get tourCustSearchTitle;

  /// No description provided for @tourCustSearchBody.
  ///
  /// In en, this message translates to:
  /// **'Search by venue name or township to see courts near you.'**
  String get tourCustSearchBody;

  /// No description provided for @tourCustDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a day'**
  String get tourCustDayTitle;

  /// No description provided for @tourCustDayBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the day you want to play. The open times below follow it.'**
  String get tourCustDayBody;

  /// No description provided for @tourCustVenuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Book in one tap'**
  String get tourCustVenuesTitle;

  /// No description provided for @tourCustVenuesBody.
  ///
  /// In en, this message translates to:
  /// **'Tap an open time to go straight to booking that court.'**
  String get tourCustVenuesBody;

  /// No description provided for @tourCustBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bookings'**
  String get tourCustBookingsTitle;

  /// No description provided for @tourCustBookingsBody.
  ///
  /// In en, this message translates to:
  /// **'See upcoming games and their status, or cancel if plans change.'**
  String get tourCustBookingsBody;

  /// No description provided for @tourCustNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay updated'**
  String get tourCustNotifTitle;

  /// No description provided for @tourCustNotifBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be told here when the shop confirms or declines your booking.'**
  String get tourCustNotifBody;

  /// No description provided for @tourCustProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & language'**
  String get tourCustProfileTitle;

  /// No description provided for @tourCustProfileBody.
  ///
  /// In en, this message translates to:
  /// **'Edit your details, switch between Myanmar and English, or replay this tour.'**
  String get tourCustProfileBody;

  /// No description provided for @tourShopStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today at a glance'**
  String get tourShopStatsTitle;

  /// No description provided for @tourShopStatsBody.
  ///
  /// In en, this message translates to:
  /// **'Today\'s bookings, requests waiting for you and paid revenue.'**
  String get tourShopStatsBody;

  /// No description provided for @tourShopBellTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking alerts'**
  String get tourShopBellTitle;

  /// No description provided for @tourShopBellBody.
  ///
  /// In en, this message translates to:
  /// **'New requests and cancellations arrive here. The badge shows how many are unread.'**
  String get tourShopBellBody;

  /// No description provided for @tourShopBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage bookings'**
  String get tourShopBookingsTitle;

  /// No description provided for @tourShopBookingsBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm or decline requests and record payments.'**
  String get tourShopBookingsBody;

  /// No description provided for @tourShopStadiumsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stadiums & courts'**
  String get tourShopStadiumsTitle;

  /// No description provided for @tourShopStadiumsBody.
  ///
  /// In en, this message translates to:
  /// **'Add venues, opening hours, courts and hourly prices.'**
  String get tourShopStadiumsBody;

  /// No description provided for @tourShopCustomersBody.
  ///
  /// In en, this message translates to:
  /// **'See who books with you and their booking history.'**
  String get tourShopCustomersBody;

  /// No description provided for @tourShopSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Shop profile, blocked times, the blacklist and this tour.'**
  String get tourShopSettingsBody;

  /// No description provided for @tourHelp.
  ///
  /// In en, this message translates to:
  /// **'How to use this page'**
  String get tourHelp;

  /// No description provided for @tourSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get tourSaveTitle;

  /// No description provided for @tourSaveBody.
  ///
  /// In en, this message translates to:
  /// **'Tap here when you\'re done. Nothing is saved until you do.'**
  String get tourSaveBody;

  /// No description provided for @tourLoginEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get tourLoginEmailTitle;

  /// No description provided for @tourLoginEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the email and password you registered with.'**
  String get tourLoginEmailBody;

  /// No description provided for @tourLoginForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get tourLoginForgotTitle;

  /// No description provided for @tourLoginForgotBody.
  ///
  /// In en, this message translates to:
  /// **'Tap here and we\'ll email you a link to set a new one.'**
  String get tourLoginForgotBody;

  /// No description provided for @tourLoginRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get tourLoginRegisterTitle;

  /// No description provided for @tourLoginRegisterBody.
  ///
  /// In en, this message translates to:
  /// **'Create a free account in about a minute.'**
  String get tourLoginRegisterBody;

  /// No description provided for @tourLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get tourLanguageTitle;

  /// No description provided for @tourLanguageBody.
  ///
  /// In en, this message translates to:
  /// **'Switch between Myanmar and English at any time.'**
  String get tourLanguageBody;

  /// No description provided for @tourRegisterNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get tourRegisterNameTitle;

  /// No description provided for @tourRegisterNameBody.
  ///
  /// In en, this message translates to:
  /// **'Shops see this name on your bookings.'**
  String get tourRegisterNameBody;

  /// No description provided for @tourRegisterPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get tourRegisterPhoneTitle;

  /// No description provided for @tourRegisterPhoneBody.
  ///
  /// In en, this message translates to:
  /// **'Lets the shop call you about your booking.'**
  String get tourRegisterPhoneBody;

  /// No description provided for @tourRegisterButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get tourRegisterButtonTitle;

  /// No description provided for @tourRegisterButtonBody.
  ///
  /// In en, this message translates to:
  /// **'Tap when done. You can change your details later in Profile.'**
  String get tourRegisterButtonBody;

  /// No description provided for @tourForgotEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get tourForgotEmailTitle;

  /// No description provided for @tourForgotEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your account email.'**
  String get tourForgotEmailBody;

  /// No description provided for @tourForgotButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Send the link'**
  String get tourForgotButtonTitle;

  /// No description provided for @tourForgotButtonBody.
  ///
  /// In en, this message translates to:
  /// **'Then check your inbox (and spam folder) and follow the link.'**
  String get tourForgotButtonBody;

  /// No description provided for @tourExploreSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search venues'**
  String get tourExploreSearchTitle;

  /// No description provided for @tourExploreSearchBody.
  ///
  /// In en, this message translates to:
  /// **'Type a venue name or township.'**
  String get tourExploreSearchBody;

  /// No description provided for @tourExploreFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter by facilities'**
  String get tourExploreFiltersTitle;

  /// No description provided for @tourExploreFiltersBody.
  ///
  /// In en, this message translates to:
  /// **'Tap what you need, like parking or showers. Tap again to remove.'**
  String get tourExploreFiltersBody;

  /// No description provided for @tourStadiumIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Venue details'**
  String get tourStadiumIntroTitle;

  /// No description provided for @tourStadiumIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Opening hours, prices, facilities, location and the courts of this venue.'**
  String get tourStadiumIntroBody;

  /// No description provided for @tourStadiumCourtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a court'**
  String get tourStadiumCourtsTitle;

  /// No description provided for @tourStadiumCourtsBody.
  ///
  /// In en, this message translates to:
  /// **'Tap a court to see its free times.'**
  String get tourStadiumCourtsBody;

  /// No description provided for @tourStadiumBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book a court'**
  String get tourStadiumBookTitle;

  /// No description provided for @tourStadiumBookBody.
  ///
  /// In en, this message translates to:
  /// **'Or tap here to choose the court, day and time.'**
  String get tourStadiumBookBody;

  /// No description provided for @tourSlotsCourtTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a court'**
  String get tourSlotsCourtTitle;

  /// No description provided for @tourSlotsCourtBody.
  ///
  /// In en, this message translates to:
  /// **'Each court can have its own price.'**
  String get tourSlotsCourtBody;

  /// No description provided for @tourSlotsDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a day'**
  String get tourSlotsDayTitle;

  /// No description provided for @tourSlotsDayBody.
  ///
  /// In en, this message translates to:
  /// **'You can book up to 30 days ahead.'**
  String get tourSlotsDayBody;

  /// No description provided for @tourSlotsGridTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your time'**
  String get tourSlotsGridTitle;

  /// No description provided for @tourSlotsGridBody.
  ///
  /// In en, this message translates to:
  /// **'Tap a start time, then the next free slots to play longer. Grey slots are booked or blocked.'**
  String get tourSlotsGridBody;

  /// No description provided for @tourSlotsContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get tourSlotsContinueTitle;

  /// No description provided for @tourSlotsContinueBody.
  ///
  /// In en, this message translates to:
  /// **'Check the time and price, then send your request.'**
  String get tourSlotsContinueBody;

  /// No description provided for @tourReviewIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your booking'**
  String get tourReviewIntroTitle;

  /// No description provided for @tourReviewIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Make sure the venue, date, time and price are right.'**
  String get tourReviewIntroBody;

  /// No description provided for @tourReviewSendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send your request'**
  String get tourReviewSendTitle;

  /// No description provided for @tourReviewSendBody.
  ///
  /// In en, this message translates to:
  /// **'The shop confirms or declines it and we notify you. You pay at the venue.'**
  String get tourReviewSendBody;

  /// No description provided for @tourConfirmIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get tourConfirmIntroTitle;

  /// No description provided for @tourConfirmIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Your booking is pending until the shop confirms it. You\'ll get a notification.'**
  String get tourConfirmIntroBody;

  /// No description provided for @tourConfirmViewTitle.
  ///
  /// In en, this message translates to:
  /// **'View your booking'**
  String get tourConfirmViewTitle;

  /// No description provided for @tourConfirmViewBody.
  ///
  /// In en, this message translates to:
  /// **'Check its status and details any time.'**
  String get tourConfirmViewBody;

  /// No description provided for @tourBookingsIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking status'**
  String get tourBookingsIntroTitle;

  /// No description provided for @tourBookingsIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Pending: waiting for the shop. Confirmed: see you there. Declined or cancelled: the time is free again.'**
  String get tourBookingsIntroBody;

  /// No description provided for @tourBookingsTabsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming and past'**
  String get tourBookingsTabsTitle;

  /// No description provided for @tourBookingsTabsBody.
  ///
  /// In en, this message translates to:
  /// **'Switch between games to come and games already played.'**
  String get tourBookingsTabsBody;

  /// No description provided for @tourBookingDetailIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking'**
  String get tourBookingDetailIntroTitle;

  /// No description provided for @tourBookingDetailIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Status, time, court and price of this booking.'**
  String get tourBookingDetailIntroBody;

  /// No description provided for @tourBookingDetailVenueTitle.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get tourBookingDetailVenueTitle;

  /// No description provided for @tourBookingDetailVenueBody.
  ///
  /// In en, this message translates to:
  /// **'Open the venue page for its location and directions.'**
  String get tourBookingDetailVenueBody;

  /// No description provided for @tourBookingDetailCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tourBookingDetailCancelTitle;

  /// No description provided for @tourBookingDetailCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Plans changed? Cancel before the start time so someone else can play.'**
  String get tourBookingDetailCancelBody;

  /// No description provided for @tourNotifIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your notifications'**
  String get tourNotifIntroTitle;

  /// No description provided for @tourNotifIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Booking updates appear here. Tap one to open that booking.'**
  String get tourNotifIntroBody;

  /// No description provided for @tourNotifShopIntroBody.
  ///
  /// In en, this message translates to:
  /// **'New booking requests and cancellations appear here. Tap one to open that booking.'**
  String get tourNotifShopIntroBody;

  /// No description provided for @tourNotifMarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get tourNotifMarkTitle;

  /// No description provided for @tourNotifMarkBody.
  ///
  /// In en, this message translates to:
  /// **'Clears the unread dots in one tap.'**
  String get tourNotifMarkBody;

  /// No description provided for @tourProfileIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get tourProfileIntroTitle;

  /// No description provided for @tourProfileIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Your name, email and phone, as shops see them.'**
  String get tourProfileIntroBody;

  /// No description provided for @tourProfileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get tourProfileEditTitle;

  /// No description provided for @tourProfileEditBody.
  ///
  /// In en, this message translates to:
  /// **'Change your name or phone number.'**
  String get tourProfileEditBody;

  /// No description provided for @tourEditPhoneBody.
  ///
  /// In en, this message translates to:
  /// **'Add a number so the shop can reach you about a booking.'**
  String get tourEditPhoneBody;

  /// No description provided for @tourPasswordCurrentTitle.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get tourPasswordCurrentTitle;

  /// No description provided for @tourPasswordCurrentBody.
  ///
  /// In en, this message translates to:
  /// **'For your safety, enter the password you use now.'**
  String get tourPasswordCurrentBody;

  /// No description provided for @tourPasswordNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get tourPasswordNewTitle;

  /// No description provided for @tourPasswordNewBody.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters, and not one from another app.'**
  String get tourPasswordNewBody;

  /// No description provided for @tourStaffStadiumFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter by stadium'**
  String get tourStaffStadiumFilterTitle;

  /// No description provided for @tourStaffStadiumFilterBody.
  ///
  /// In en, this message translates to:
  /// **'Show bookings of one stadium only.'**
  String get tourStaffStadiumFilterBody;

  /// No description provided for @tourStaffFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter the list'**
  String get tourStaffFiltersTitle;

  /// No description provided for @tourStaffFiltersBody.
  ///
  /// In en, this message translates to:
  /// **'Pending means waiting for a decision. Switch to upcoming, past or all bookings.'**
  String get tourStaffFiltersBody;

  /// No description provided for @tourStaffBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Block time'**
  String get tourStaffBlockTitle;

  /// No description provided for @tourStaffBlockBody.
  ///
  /// In en, this message translates to:
  /// **'Close a court for maintenance or a private event so nobody can book it.'**
  String get tourStaffBlockBody;

  /// No description provided for @tourStaffDetailIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get tourStaffDetailIntroTitle;

  /// No description provided for @tourStaffDetailIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Customer, time, court, price and payment. Tap the customer to see their history.'**
  String get tourStaffDetailIntroBody;

  /// No description provided for @tourStaffConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get tourStaffConfirmTitle;

  /// No description provided for @tourStaffConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Accept the request. The customer gets a notification.'**
  String get tourStaffConfirmBody;

  /// No description provided for @tourStaffPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get tourStaffPaymentTitle;

  /// No description provided for @tourStaffPaymentBody.
  ///
  /// In en, this message translates to:
  /// **'Record the payment step by step: pending, then paid.'**
  String get tourStaffPaymentBody;

  /// No description provided for @tourStaffRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get tourStaffRejectTitle;

  /// No description provided for @tourStaffRejectBody.
  ///
  /// In en, this message translates to:
  /// **'Frees the time for others. The customer is notified.'**
  String get tourStaffRejectBody;

  /// No description provided for @tourShopCustomersIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Everyone who has booked at your shop. Tap a name for details.'**
  String get tourShopCustomersIntroBody;

  /// No description provided for @tourCustomerSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a customer'**
  String get tourCustomerSearchTitle;

  /// No description provided for @tourCustomerSearchBody.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone number.'**
  String get tourCustomerSearchBody;

  /// No description provided for @tourCustomerDetailIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get tourCustomerDetailIntroTitle;

  /// No description provided for @tourCustomerDetailIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Contact details and booking history.'**
  String get tourCustomerDetailIntroBody;

  /// No description provided for @tourBlacklistActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Blacklist'**
  String get tourBlacklistActionTitle;

  /// No description provided for @tourBlacklistActionBody.
  ///
  /// In en, this message translates to:
  /// **'Stops repeat no-shows from booking at your shop. Other shops aren\'t affected.'**
  String get tourBlacklistActionBody;

  /// No description provided for @tourShopSettingsIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tourShopSettingsIntroTitle;

  /// No description provided for @tourShopSettingsIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Shop profile, blocked times, blacklist and stadiums in one place.'**
  String get tourShopSettingsIntroBody;

  /// No description provided for @tourShopProfileIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get tourShopProfileIntroTitle;

  /// No description provided for @tourShopProfileIntroBody.
  ///
  /// In en, this message translates to:
  /// **'How your shop appears to customers.'**
  String get tourShopProfileIntroBody;

  /// No description provided for @tourShopProfileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get tourShopProfileEditTitle;

  /// No description provided for @tourShopProfileEditBody.
  ///
  /// In en, this message translates to:
  /// **'Update the name, phone and address.'**
  String get tourShopProfileEditBody;

  /// No description provided for @tourStadiumsIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your stadiums'**
  String get tourStadiumsIntroTitle;

  /// No description provided for @tourStadiumsIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Each stadium has its own opening hours and courts. Tap one to manage it.'**
  String get tourStadiumsIntroBody;

  /// No description provided for @tourStadiumsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a stadium'**
  String get tourStadiumsAddTitle;

  /// No description provided for @tourStadiumsAddBody.
  ///
  /// In en, this message translates to:
  /// **'Start here: add your venue, then its courts.'**
  String get tourStadiumsAddBody;

  /// No description provided for @tourStadiumEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit stadium'**
  String get tourStadiumEditTitle;

  /// No description provided for @tourStadiumEditBody.
  ///
  /// In en, this message translates to:
  /// **'Change the name, address, opening hours and facilities.'**
  String get tourStadiumEditBody;

  /// No description provided for @tourStadiumAddCourtTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a court'**
  String get tourStadiumAddCourtTitle;

  /// No description provided for @tourStadiumAddCourtBody.
  ///
  /// In en, this message translates to:
  /// **'Each court has its own price and slot length.'**
  String get tourStadiumAddCourtBody;

  /// No description provided for @tourStadiumFormNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Stadium name'**
  String get tourStadiumFormNameTitle;

  /// No description provided for @tourStadiumFormNameBody.
  ///
  /// In en, this message translates to:
  /// **'The name customers see and search for.'**
  String get tourStadiumFormNameBody;

  /// No description provided for @tourStadiumFormMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map location'**
  String get tourStadiumFormMapTitle;

  /// No description provided for @tourStadiumFormMapBody.
  ///
  /// In en, this message translates to:
  /// **'Pin the venue so customers get directions.'**
  String get tourStadiumFormMapBody;

  /// No description provided for @tourStadiumFormHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get tourStadiumFormHoursTitle;

  /// No description provided for @tourStadiumFormHoursBody.
  ///
  /// In en, this message translates to:
  /// **'Customers can only book inside these hours.'**
  String get tourStadiumFormHoursBody;

  /// No description provided for @tourStadiumFormFacilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get tourStadiumFormFacilitiesTitle;

  /// No description provided for @tourStadiumFormFacilitiesBody.
  ///
  /// In en, this message translates to:
  /// **'Tick what you offer. Customers filter venues by these.'**
  String get tourStadiumFormFacilitiesBody;

  /// No description provided for @tourCourtIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Court'**
  String get tourCourtIntroTitle;

  /// No description provided for @tourCourtIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Price, slot length and whether customers can book this court.'**
  String get tourCourtIntroBody;

  /// No description provided for @tourCourtEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit court'**
  String get tourCourtEditTitle;

  /// No description provided for @tourCourtEditBody.
  ///
  /// In en, this message translates to:
  /// **'Change the name or price, or turn bookings off.'**
  String get tourCourtEditBody;

  /// No description provided for @tourCourtFormNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Court name'**
  String get tourCourtFormNameTitle;

  /// No description provided for @tourCourtFormNameBody.
  ///
  /// In en, this message translates to:
  /// **'For example “Court A” or “Indoor pitch”.'**
  String get tourCourtFormNameBody;

  /// No description provided for @tourCourtFormPriceTitle.
  ///
  /// In en, this message translates to:
  /// **'Hourly price'**
  String get tourCourtFormPriceTitle;

  /// No description provided for @tourCourtFormPriceBody.
  ///
  /// In en, this message translates to:
  /// **'In kyat per hour. The booking price is worked out from it.'**
  String get tourCourtFormPriceBody;

  /// No description provided for @tourCourtFormSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Slot length'**
  String get tourCourtFormSlotTitle;

  /// No description provided for @tourCourtFormSlotBody.
  ///
  /// In en, this message translates to:
  /// **'30 or 60 minutes. It can\'t be changed later, so choose carefully.'**
  String get tourCourtFormSlotBody;

  /// No description provided for @tourBlockedIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked times'**
  String get tourBlockedIntroTitle;

  /// No description provided for @tourBlockedIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Times you closed. Customers can\'t book them.'**
  String get tourBlockedIntroBody;

  /// No description provided for @tourBlockedAddBody.
  ///
  /// In en, this message translates to:
  /// **'Close a court for maintenance, cleaning or an event.'**
  String get tourBlockedAddBody;

  /// No description provided for @tourBlockFormWhereTitle.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get tourBlockFormWhereTitle;

  /// No description provided for @tourBlockFormWhereBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the stadium, then the court to close.'**
  String get tourBlockFormWhereBody;

  /// No description provided for @tourBlockFormButtonBody.
  ///
  /// In en, this message translates to:
  /// **'Booked times can\'t be blocked. Decline that booking first.'**
  String get tourBlockFormButtonBody;

  /// No description provided for @tourBlacklistIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Blacklist'**
  String get tourBlacklistIntroTitle;

  /// No description provided for @tourBlacklistIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Customers here can\'t make new bookings at your shop. Tap the remove icon to allow them again.'**
  String get tourBlacklistIntroBody;

  /// No description provided for @tourMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Move the map'**
  String get tourMapTitle;

  /// No description provided for @tourMapBody.
  ///
  /// In en, this message translates to:
  /// **'Drag until the pin sits on your venue. Pinch to zoom.'**
  String get tourMapBody;

  /// No description provided for @tourMapUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Use this location'**
  String get tourMapUseTitle;

  /// No description provided for @tourMapUseBody.
  ///
  /// In en, this message translates to:
  /// **'Saves the pin to the stadium form.'**
  String get tourMapUseBody;

  /// No description provided for @consolePlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get consolePlatform;

  /// No description provided for @consoleStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get consoleStatus;

  /// No description provided for @consoleSearchShops.
  ///
  /// In en, this message translates to:
  /// **'Search shops'**
  String get consoleSearchShops;

  /// No description provided for @consoleStatusListing.
  ///
  /// In en, this message translates to:
  /// **'Status & listing'**
  String get consoleStatusListing;

  /// No description provided for @consoleActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get consoleActions;

  /// No description provided for @consoleActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get consoleActivity;

  /// No description provided for @consoleContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get consoleContact;

  /// No description provided for @consolePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get consolePayment;

  /// No description provided for @consoleWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get consoleWhen;

  /// No description provided for @consolePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get consolePreferences;

  /// No description provided for @consoleActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get consoleActive;

  /// No description provided for @consoleUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get consoleUpcoming;

  /// No description provided for @consoleSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get consoleSent;

  /// No description provided for @consoleOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get consoleOverview;

  /// No description provided for @consoleSearchBookings.
  ///
  /// In en, this message translates to:
  /// **'Search customer or stadium'**
  String get consoleSearchBookings;

  /// No description provided for @consoleAllShops.
  ///
  /// In en, this message translates to:
  /// **'All shops'**
  String get consoleAllShops;

  /// No description provided for @consoleRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get consoleRole;

  /// No description provided for @consoleNoMatches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches'**
  String get consoleNoMatches;

  /// No description provided for @shopLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the shop on Google Map. The address fills in from the pin.'**
  String get shopLocationHint;

  /// No description provided for @shopLocationFinding.
  ///
  /// In en, this message translates to:
  /// **'Finding the address…'**
  String get shopLocationFinding;

  /// No description provided for @shopLocationNoAddress.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find a street address for this pin. The pin is still saved and directions will work.'**
  String get shopLocationNoAddress;

  /// No description provided for @stadiumLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the stadium on Google Map. The address fills in from the pin.'**
  String get stadiumLocationHint;

  /// No description provided for @pickLocationNoAddress.
  ///
  /// In en, this message translates to:
  /// **'No address found here — the pin still works for directions.'**
  String get pickLocationNoAddress;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'my': return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
