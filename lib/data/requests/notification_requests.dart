import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/firestore_paths.dart';
import '../../firebase/firestore/notification_fields.dart';
import '../vos/booking_vo.dart';

/// A new `notifications/{bookingId}_{type}` doc. Every field mirrors the
/// booking as it is AFTER the event; firestore.rules compare them with the
/// stored booking. `createdAt` is stamped by the data layer.
@immutable
class NotificationCreateRequest {
  const NotificationCreateRequest({
    required this.type,
    required this.recipientId,
    required this.shopId,
    required this.bookingId,
    required this.actorId,
    required this.customerNameSnapshot,
    required this.stadiumNameSnapshot,
    required this.courtNameSnapshot,
    required this.bookingDate,
    required this.startMinute,
    required this.endMinute,
    this.reason,
  });

  /// [booking] is the booking before the change; [reason] is the
  /// `cancelReason` the change wrote (cancel / reject), else null.
  factory NotificationCreateRequest.forBooking({
    required NotificationType type,
    required BookingVO booking,
    required String actorId,
    String? reason,
  }) {
    return NotificationCreateRequest(
      type: type,
      recipientId: type.audience == NotificationAudience.shop
          ? booking.shopId
          : booking.customerId,
      shopId: booking.shopId,
      bookingId: booking.id,
      actorId: actorId,
      customerNameSnapshot: booking.customerNameSnapshot,
      stadiumNameSnapshot: booking.stadiumNameSnapshot,
      courtNameSnapshot: booking.courtNameSnapshot,
      bookingDate: booking.bookingDate,
      startMinute: booking.startMinute,
      endMinute: booking.endMinute,
      reason: reason,
    );
  }

  final NotificationType type;
  final String recipientId;
  final String shopId;
  final String bookingId;
  final String actorId;
  final String customerNameSnapshot;
  final String stadiumNameSnapshot;
  final String courtNameSnapshot;
  final String bookingDate;
  final int startMinute;
  final int endMinute;
  final String? reason;

  String get id => FirestorePaths.notificationId(bookingId, type.name);

  /// Every key the rules require (`notificationKeys()`) except `createdAt`.
  Map<String, Object?> toFirestore() => {
        NotificationFields.audience: type.audience.name,
        NotificationFields.recipientId: recipientId,
        NotificationFields.shopId: shopId,
        NotificationFields.bookingId: bookingId,
        NotificationFields.type: type.name,
        NotificationFields.actorId: actorId,
        NotificationFields.customerNameSnapshot: customerNameSnapshot,
        NotificationFields.stadiumNameSnapshot: stadiumNameSnapshot,
        NotificationFields.courtNameSnapshot: courtNameSnapshot,
        NotificationFields.bookingDate: bookingDate,
        NotificationFields.startMinute: startMinute,
        NotificationFields.endMinute: endMinute,
        NotificationFields.reason: reason,
        NotificationFields.isRead: false,
      };
}
