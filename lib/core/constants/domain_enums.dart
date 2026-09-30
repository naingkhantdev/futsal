/// Domain enums shared by every layer.
///
/// Lives in `core/` (the lowest layer) so that `core/widgets` status mappings,
/// `core/router` role checks and the Phase 3 VOs in `data/vos` can all import
/// it without `core` depending on `data`. Enum `name`s are the exact wire
/// values stored in Firestore — do not rename them.
library;

/// Platform roles, stored in `users/{uid}.role`. Only a superadmin can change
/// a role (enforced by firestore.rules); the client value is for UX routing
/// only and never grants access by itself.
enum UserRole {
  superadmin,
  shopAdmin,
  customer;

  static UserRole? tryParse(String? value) => _parse(values, value);
}

/// Booking lifecycle status.
enum BookingStatus {
  pending,
  confirmed,
  rejected,
  cancelled,
  completed;

  static BookingStatus? tryParse(String? value) => _parse(values, value);
}

/// Payment status, tracked separately from [BookingStatus].
enum PaymentStatus {
  unpaid,
  pending,
  paid,
  refunded;

  static PaymentStatus? tryParse(String? value) => _parse(values, value);
}

/// Shop lifecycle status. Listing is a separate `isListed` flag.
enum ShopStatus {
  pending,
  active,
  suspended,
  rejected,
  inactive;

  static ShopStatus? tryParse(String? value) => _parse(values, value);
}

/// Stadium facility keys (master notes §7), stored in `stadiums.facilities`.
/// Unknown keys are dropped when parsing.
enum Facility {
  parking,
  shower,
  changingRoom,
  drinkingWater,
  floodLights,
  seating,
  restroom,
  cafe,
  equipmentRental;

  static Facility? tryParse(String? value) => _parse(values, value);
}

/// Why a court time range is blocked (master notes §15).
enum BlockedSlotReason {
  maintenance,
  privateEvent,
  cleaning,
  tournament,
  temporaryClosure,
  other;

  static BlockedSlotReason? tryParse(String? value) => _parse(values, value);
}

/// Why a shop blacklisted a customer (`shops/{id}/blacklist/{uid}.reason`).
/// Mirror: firestore.rules `validBlacklistEntry`.
enum BlacklistReason {
  noShow,
  other;

  static BlacklistReason? tryParse(String? value) => _parse(values, value);
}

/// What holds a slot lock doc (`stadiums/{id}/courts/{id}/slots/{slotId}`,
/// field `kind`): a booking or a blocked slot.
enum BusyKind {
  booked,
  blocked;

  static BusyKind? tryParse(String? value) => _parse(values, value);
}

/// Who a `notifications/{id}` doc is for (field `audience`): one customer
/// (`recipientId` = uid) or every admin of one shop (`recipientId` = shopId).
/// Mirror: firestore.rules `notifications`.
enum NotificationAudience {
  customer,
  shop;

  static NotificationAudience? tryParse(String? value) => _parse(values, value);
}

/// Booking event a notification reports (field `type`). Requested /
/// cancelled go to the shop (sent by the customer); confirmed / rejected go
/// to the customer (sent by staff). Mirror: firestore.rules
/// `notificationEventOk`.
enum NotificationType {
  bookingRequested,
  bookingCancelled,
  bookingConfirmed,
  bookingRejected;

  static NotificationType? tryParse(String? value) => _parse(values, value);

  NotificationAudience get audience => switch (this) {
        bookingRequested || bookingCancelled => NotificationAudience.shop,
        bookingConfirmed || bookingRejected => NotificationAudience.customer,
      };
}

/// Visual state of a bookable time slot (UI only, never persisted).
enum SlotState { available, selected, booked, blocked, unavailable }

T? _parse<T extends Enum>(List<T> values, String? value) {
  if (value == null) return null;
  for (final v in values) {
    if (v.name == value) return v;
  }
  return null;
}
