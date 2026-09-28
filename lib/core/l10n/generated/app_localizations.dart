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

  /// No description provided for @homeReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to play?'**
  String get homeReady;

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

  /// No description provided for @homeNoGames.
  ///
  /// In en, this message translates to:
  /// **'No games booked. Pick a court below.'**
  String get homeNoGames;

  /// No description provided for @homePopular.
  ///
  /// In en, this message translates to:
  /// **'Popular near you'**
  String get homePopular;

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
