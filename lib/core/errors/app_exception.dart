import '../constants/account_copy.dart';

/// Application error hierarchy (master notes §23).
///
/// Every error that reaches providers/UI is an [AppException]. [message] is
/// always friendly, fixed copy — raw Firebase/platform text is kept only in
/// [cause] for logging and must never be shown to users.
sealed class AppException implements Exception {
  const AppException({this.cause, this.stackTrace});

  /// Original error, for logging/crash reporting only. Never display.
  final Object? cause;
  final StackTrace? stackTrace;

  /// User-facing message.
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

// --- Auth / account -------------------------------------------------------

/// Session missing or expired; the user must log in again.
final class AuthenticationException extends AppException {
  const AuthenticationException({super.cause, super.stackTrace});
  @override
  String get message => 'Please log in again to continue.';
}

/// Wrong email/password. Never reveals which one was wrong.
final class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException({super.cause, super.stackTrace});
  @override
  String get message => 'Email or password is incorrect.';
}

final class InvalidEmailException extends AppException {
  const InvalidEmailException({super.cause, super.stackTrace});
  @override
  String get message => 'Enter a valid email address.';
}

final class EmailAlreadyInUseException extends AppException {
  const EmailAlreadyInUseException({super.cause, super.stackTrace});
  @override
  String get message =>
      'An account with this email already exists. Log in instead?';
}

final class WeakPasswordException extends AppException {
  const WeakPasswordException({super.cause, super.stackTrace});
  @override
  String get message => 'Use at least 8 characters.';
}

final class TooManyRequestsException extends AppException {
  const TooManyRequestsException({super.cause, super.stackTrace});
  @override
  String get message => 'Too many attempts. Try again in a few minutes.';
}

final class AccountDisabledException extends AppException {
  const AccountDisabledException({super.cause, super.stackTrace});
  @override
  String get message => AccountCopy.disabledMessage;
}

/// Re-authentication failed because the current password was wrong
/// (change-password flow only; login uses [InvalidCredentialsException]).
final class IncorrectPasswordException extends AppException {
  const IncorrectPasswordException({super.cause, super.stackTrace});
  @override
  String get message => 'Your current password is incorrect.';
}

/// Signed in, but the `users/{uid}` profile did not resolve in time
/// (e.g. offline).
final class AccountSetupTimeoutException extends AppException {
  const AccountSetupTimeoutException({super.cause, super.stackTrace});
  @override
  String get message =>
      "Your account didn't finish loading. Check your connection and try again.";
}

/// `users/{uid}.role` is missing or not one of the three platform roles.
/// Treated as not authorized — never mapped to a default role.
final class UnauthorizedRoleException extends AppException {
  const UnauthorizedRoleException({super.cause, super.stackTrace});
  @override
  String get message =>
      "This account doesn't have access to the app. Contact support.";
}

// --- Access / transport ---------------------------------------------------

final class PermissionDeniedException extends AppException {
  const PermissionDeniedException({super.cause, super.stackTrace});
  @override
  String get message => "You don't have permission to do that.";
}

final class NetworkException extends AppException {
  const NetworkException({super.cause, super.stackTrace});
  @override
  String get message => "You're offline. Check your connection and try again.";
}

final class NotFoundException extends AppException {
  const NotFoundException({super.cause, super.stackTrace});
  @override
  String get message => "We couldn't find what you were looking for.";
}

/// The device location is off, or the user refused to share it.
final class LocationUnavailableException extends AppException {
  const LocationUnavailableException({super.cause, super.stackTrace});
  @override
  String get message =>
      'Turn on location and allow access to sort courts by distance.';
}

// --- Venue admin ----------------------------------------------------------

/// A shop / stadium / court save that firestore.rules would refuse for its
/// content (caught client-side before the round trip). Forms validate the
/// same limits, so users normally never see this.
final class InvalidVenueDetailsException extends AppException {
  const InvalidVenueDetailsException({super.cause, super.stackTrace});
  @override
  String get message =>
      "Some details aren't valid. Check the form and try again.";
}

/// Superadmin tried to make someone a shop admin who can't be one here
/// (another superadmin, or no account with that email).
final class ShopAdminAssignmentException extends AppException {
  const ShopAdminAssignmentException({super.cause, super.stackTrace});
  @override
  String get message => "This account can't be made a shop admin.";
}

// --- Booking domain -------------------------------------------------------

/// The requested time overlaps an existing blocking booking.
final class BookingConflictException extends AppException {
  const BookingConflictException({super.cause, super.stackTrace});
  @override
  String get message =>
      'That time was just booked by someone else. Pick another time.';
}

final class CourtUnavailableException extends AppException {
  const CourtUnavailableException({super.cause, super.stackTrace});
  @override
  String get message => "This court isn't available for booking right now.";
}

final class StadiumUnavailableException extends AppException {
  const StadiumUnavailableException({super.cause, super.stackTrace});
  @override
  String get message => "This stadium isn't available for booking right now.";
}

/// The shop blacklisted this customer (e.g. repeated no-shows): no new
/// bookings there. Other shops are unaffected.
final class CustomerBlacklistedException extends AppException {
  const CustomerBlacklistedException({super.cause, super.stackTrace});

  @override
  String get message =>
      "This venue isn't taking bookings from your account. Contact the venue.";
}

/// Shop suspended, unlisted or inactive — no new bookings.
final class ShopUnavailableException extends AppException {
  const ShopUnavailableException({super.cause, super.stackTrace});
  @override
  String get message => "This venue isn't taking bookings right now.";
}

final class InvalidBookingTimeException extends AppException {
  const InvalidBookingTimeException({super.cause, super.stackTrace});
  @override
  String get message =>
      "That time can't be booked. Check the opening hours and try another time.";
}

/// More slots than `BookingPolicy.maxSlotsPerBooking` in one booking or
/// one blocked-slot doc (firestore.rules cap).
final class BookingTooLongException extends AppException {
  const BookingTooLongException({super.cause, super.stackTrace});
  @override
  String get message => 'You can book up to 4 slots at a time.';
}

/// Booking needs a name on the profile (the rules copy it into the booking
/// so the venue knows who is coming).
final class ProfileIncompleteException extends AppException {
  const ProfileIncompleteException({super.cause, super.stackTrace});
  @override
  String get message => 'Add your name in Profile before booking.';
}

/// The booking is no longer in a state that allows this change (e.g.
/// cancelling after it started, confirming a cancelled booking).
final class InvalidBookingChangeException extends AppException {
  const InvalidBookingChangeException({super.cause, super.stackTrace});
  @override
  String get message => "This booking can't be changed that way anymore.";
}

final class InvalidDateException extends AppException {
  const InvalidDateException({super.cause, super.stackTrace});
  @override
  String get message => "That date can't be booked. Choose another date.";
}

// --- Fallbacks ------------------------------------------------------------

/// A backend (Firebase) failure with no more specific mapping.
final class ServerException extends AppException {
  const ServerException({super.cause, super.stackTrace});
  @override
  String get message => 'Something went wrong on our side. Please try again.';
}

final class UnknownException extends AppException {
  const UnknownException({super.cause, super.stackTrace});
  @override
  String get message => 'Something went wrong. Please try again.';
}
