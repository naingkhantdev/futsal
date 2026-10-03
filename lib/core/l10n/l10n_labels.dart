import '../constants/cancellation_policy.dart';
import '../constants/domain_enums.dart';
import '../errors/app_exception.dart';
import '../utils/validators.dart';
import 'l10n.dart';

/// Localized copy for domain values and errors. The English getters in
/// `domain_labels.dart` / `status_visuals.dart` / `AppException.message`
/// stay as the fallback for screens that are not translated yet.

extension BookingStatusL10n on BookingStatus {
  String labelIn(AppLocalizations l) => switch (this) {
        BookingStatus.pending => l.bookingPending,
        BookingStatus.confirmed => l.bookingConfirmed,
        BookingStatus.rejected => l.bookingRejected,
        BookingStatus.cancelled => l.bookingCancelled,
        BookingStatus.completed => l.bookingCompleted,
      };
}

extension PaymentStatusL10n on PaymentStatus {
  String labelIn(AppLocalizations l) => switch (this) {
        PaymentStatus.unpaid => l.paymentUnpaid,
        PaymentStatus.pending => l.paymentPending,
        PaymentStatus.paid => l.paymentPaid,
        PaymentStatus.refunded => l.paymentRefunded,
      };
}

extension ShopStatusL10n on ShopStatus {
  String labelIn(AppLocalizations l) => switch (this) {
        ShopStatus.pending => l.shopPendingReview,
        ShopStatus.active => l.shopActive,
        ShopStatus.suspended => l.shopSuspended,
        ShopStatus.rejected => l.shopRejected,
        ShopStatus.inactive => l.shopInactive,
      };
}

extension UserRoleL10n on UserRole {
  String labelIn(AppLocalizations l) => switch (this) {
        UserRole.superadmin => l.rolePlatformAdmin,
        UserRole.shopAdmin => l.roleShopAdmin,
        UserRole.customer => l.roleCustomer,
      };
}

extension FacilityL10n on Facility {
  String labelIn(AppLocalizations l) => switch (this) {
        Facility.parking => l.facilityParking,
        Facility.shower => l.facilityShower,
        Facility.changingRoom => l.facilityChangingRoom,
        Facility.drinkingWater => l.facilityDrinkingWater,
        Facility.floodLights => l.facilityFloodLights,
        Facility.seating => l.facilitySeating,
        Facility.restroom => l.facilityRestroom,
        Facility.cafe => l.facilityCafe,
        Facility.equipmentRental => l.facilityEquipmentRental,
      };
}

extension BlockedSlotReasonL10n on BlockedSlotReason {
  String labelIn(AppLocalizations l) => switch (this) {
        BlockedSlotReason.maintenance => l.reasonMaintenance,
        BlockedSlotReason.privateEvent => l.reasonPrivateEvent,
        BlockedSlotReason.cleaning => l.reasonCleaning,
        BlockedSlotReason.tournament => l.reasonTournament,
        BlockedSlotReason.temporaryClosure => l.reasonTemporaryClosure,
        BlockedSlotReason.other => l.reasonOther,
      };
}

/// Short chip label for a free-cancellation window ("Until start",
/// "24 h before").
String cancelWindowLabel(AppLocalizations l, int hours) =>
    hours == 0 ? l.cancelWindowUntilStart : l.cancelWindowHours(hours);

/// Customer-facing sentence for a venue's policy (`null` = none stated).
String cancelPolicySummary(AppLocalizations l, int? hours) => switch (hours) {
      null => l.cancelPolicyNone,
      0 => l.cancelPolicyFreeUntilStart,
      final h => l.cancelPolicyFreeHours(h),
    };

extension RefundStateL10n on RefundState {
  /// `null` for [RefundState.none] (nothing to show).
  String? labelIn(AppLocalizations l) => switch (this) {
        RefundState.none => null,
        RefundState.nothingPaid => l.refundNothingPaid,
        RefundState.due => l.refundDue,
        RefundState.notEligible => l.refundNotEligible,
        RefundState.askVenue => l.refundAskVenue,
        RefundState.refunded => l.refundRefunded,
      };
}

extension CourtSurfaceL10n on CourtSurface {
  String labelIn(AppLocalizations l) => switch (this) {
        CourtSurface.artificialTurf => l.surfaceArtificialTurf,
        CourtSurface.sportsTile => l.surfaceSportsTile,
        CourtSurface.rubber => l.surfaceRubber,
        CourtSurface.wood => l.surfaceWood,
        CourtSurface.concrete => l.surfaceConcrete,
      };
}

/// A court's `surfaceType` for display: the translated label for a known
/// surface, older free text as-is, `null` when unset.
String? surfaceText(AppLocalizations l, String? surfaceType) =>
    CourtSurface.tryParse(surfaceType)?.labelIn(l) ?? surfaceType;

extension PlayerPositionL10n on PlayerPosition {
  String labelIn(AppLocalizations l) => switch (this) {
        PlayerPosition.goalkeeper => l.positionGoalkeeper,
        PlayerPosition.defender => l.positionDefender,
        PlayerPosition.midfielder => l.positionMidfielder,
        PlayerPosition.forward => l.positionForward,
        PlayerPosition.anywhere => l.positionAnywhere,
      };
}

extension SkillLevelL10n on SkillLevel {
  String labelIn(AppLocalizations l) => switch (this) {
        SkillLevel.beginner => l.skillBeginner,
        SkillLevel.casual => l.skillCasual,
        SkillLevel.intermediate => l.skillIntermediate,
        SkillLevel.advanced => l.skillAdvanced,
      };
}

extension AppExceptionL10n on AppException {
  /// Friendly, translated message for any [AppException].
  String messageIn(AppLocalizations l) => switch (this) {
        AuthenticationException() => l.errAuthentication,
        InvalidCredentialsException() => l.errInvalidCredentials,
        InvalidEmailException() => l.errInvalidEmail,
        EmailAlreadyInUseException() => l.errEmailInUse,
        WeakPasswordException() => l.errWeakPassword,
        TooManyRequestsException() => l.errTooManyRequests,
        AccountDisabledException() => l.accountDisabledMessage,
        IncorrectPasswordException() => l.errIncorrectPassword,
        AccountSetupTimeoutException() => l.errSetupTimeout,
        UnauthorizedRoleException() => l.errUnauthorizedRole,
        PermissionDeniedException() => l.errPermissionDenied,
        NetworkException() => l.errNetwork,
        NotFoundException() => l.errNotFound,
        LocationUnavailableException() => l.errLocationUnavailable,
        InvalidVenueDetailsException() => l.errInvalidVenueDetails,
        ShopAdminAssignmentException() => l.errShopAdminAssignment,
        BookingConflictException() => l.errBookingConflict,
        CourtUnavailableException() => l.errCourtUnavailable,
        StadiumUnavailableException() => l.errStadiumUnavailable,
        ShopUnavailableException() => l.errShopUnavailable,
        CustomerBlacklistedException() => l.errBlacklisted,
        InvalidBookingTimeException() => l.errInvalidBookingTime,
        BookingTooLongException() => l.errBookingTooLong,
        ProfileIncompleteException() => l.errProfileIncomplete,
        InvalidBookingChangeException() => l.errInvalidBookingChange,
        InvalidDateException() => l.errInvalidDate,
        ServerException() => l.errServer,
        UnknownException() => l.errUnknown,
      };
}

final RegExp _maxChars = RegExp(r'^Use (\d+) characters or fewer$');
final RegExp _priceMax = RegExp(r'^Enter a price up to (\d+)$');
final RegExp _capacityRange = RegExp(r'^Enter a number from 1 to (\d+)$');

/// Translates an [AppValidators] / [VenueValidators] message. Validators
/// return fixed English strings (unit-tested as such); form fields pass them
/// through here before display. Unknown messages (already translated, e.g.
/// a screen's own "Enter the stadium name") are returned unchanged.
String localizeValidation(AppLocalizations l, String message) {
  final withValue = switch (message) {
    _ when _maxChars.hasMatch(message) =>
      l.valMaxChars(int.parse(_maxChars.firstMatch(message)!.group(1)!)),
    _ when _priceMax.hasMatch(message) =>
      l.valPriceMax(int.parse(_priceMax.firstMatch(message)!.group(1)!)),
    _ when _capacityRange.hasMatch(message) => l.valCapacityRange(
        int.parse(_capacityRange.firstMatch(message)!.group(1)!),
      ),
    _ => null,
  };
  return withValue ?? _localizeFixed(l, message);
}

String _localizeFixed(AppLocalizations l, String message) =>
    switch (message) {
      'Enter the price per hour' => l.valPriceRequired,
      'Use whole kyat, digits only' => l.valPriceDigits,
      ValidationMessages.nameRequired => l.valNameRequired,
      ValidationMessages.nameTooLong => l.valNameTooLong,
      ValidationMessages.emailRequired => l.valEmailRequired,
      ValidationMessages.emailInvalid => l.valEmailInvalid,
      ValidationMessages.phoneInvalid => l.valPhoneInvalid,
      ValidationMessages.passwordRequired => l.valPasswordRequired,
      ValidationMessages.passwordTooShort => l.valPasswordTooShort,
      ValidationMessages.currentPasswordRequired => l.valCurrentPasswordRequired,
      ValidationMessages.passwordUnchanged => l.valPasswordSame,
      _ => message,
    };
