/// Field names of `notifications/{bookingId}_{type}`. Written by the client
/// right after a booking event (Spark plan: no Cloud Functions); the rules
/// check every field against the booking, so the content can't be faked.
/// Only `isRead` / `readAt` change afterwards.
abstract final class NotificationFields {
  /// `NotificationAudience` wire value.
  static const String audience = 'audience';

  /// Customer uid (audience customer) or shopId (audience shop).
  static const String recipientId = 'recipientId';
  static const String shopId = 'shopId';
  static const String bookingId = 'bookingId';

  /// `NotificationType` wire value.
  static const String type = 'type';

  /// Uid of the user whose action created it.
  static const String actorId = 'actorId';

  /// Copies of the booking's snapshots (rules require equality).
  static const String customerNameSnapshot = 'customerNameSnapshot';
  static const String stadiumNameSnapshot = 'stadiumNameSnapshot';
  static const String courtNameSnapshot = 'courtNameSnapshot';
  static const String bookingDate = 'bookingDate';
  static const String startMinute = 'startMinute';
  static const String endMinute = 'endMinute';

  /// The booking's `cancelReason` (or null).
  static const String reason = 'reason';
  static const String isRead = 'isRead';
  static const String createdAt = 'createdAt';
  static const String readAt = 'readAt';
}
