import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/notification_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `notifications/{id}`. `null` from [tryFromFirestore] when
/// the type or audience is unknown (e.g. written by a newer app version),
/// so old apps skip it instead of showing a wrong message.
@immutable
class NotificationResponse {
  const NotificationResponse({
    required this.id,
    required this.audience,
    required this.recipientId,
    required this.shopId,
    required this.bookingId,
    required this.type,
    required this.customerNameSnapshot,
    required this.stadiumNameSnapshot,
    required this.courtNameSnapshot,
    required this.bookingDate,
    required this.startMinute,
    required this.endMinute,
    required this.isRead,
    this.actorId,
    this.reason,
    this.createdAt,
  });

  static NotificationResponse? tryFromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final audience = NotificationAudience.tryParse(
      FirestoreRead.string(data[NotificationFields.audience]),
    );
    final type = NotificationType.tryParse(
      FirestoreRead.string(data[NotificationFields.type]),
    );
    if (audience == null || type == null) return null;
    return NotificationResponse(
      id: id,
      audience: audience,
      recipientId:
          FirestoreRead.string(data[NotificationFields.recipientId]) ?? '',
      shopId: FirestoreRead.string(data[NotificationFields.shopId]) ?? '',
      bookingId: FirestoreRead.string(data[NotificationFields.bookingId]) ?? '',
      type: type,
      actorId: FirestoreRead.string(data[NotificationFields.actorId]),
      customerNameSnapshot: FirestoreRead.string(
            data[NotificationFields.customerNameSnapshot],
          ) ??
          '',
      stadiumNameSnapshot: FirestoreRead.string(
            data[NotificationFields.stadiumNameSnapshot],
          ) ??
          '',
      courtNameSnapshot:
          FirestoreRead.string(data[NotificationFields.courtNameSnapshot]) ??
              '',
      bookingDate:
          FirestoreRead.string(data[NotificationFields.bookingDate]) ?? '',
      startMinute:
          FirestoreRead.integer(data[NotificationFields.startMinute]) ?? 0,
      endMinute: FirestoreRead.integer(data[NotificationFields.endMinute]) ?? 0,
      reason: FirestoreRead.string(data[NotificationFields.reason]),
      isRead: FirestoreRead.flag(data[NotificationFields.isRead]),
      createdAt: FirestoreRead.date(data[NotificationFields.createdAt]),
    );
  }

  final String id;
  final NotificationAudience audience;
  final String recipientId;
  final String shopId;
  final String bookingId;
  final NotificationType type;
  final String? actorId;
  final String customerNameSnapshot;
  final String stadiumNameSnapshot;
  final String courtNameSnapshot;
  final String bookingDate;
  final int startMinute;
  final int endMinute;
  final String? reason;
  final bool isRead;

  /// `null` for a moment after a local write (pending server timestamp).
  final DateTime? createdAt;
}
