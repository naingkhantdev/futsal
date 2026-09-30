import '../../responses/notification_response.dart';
import '../../vos/notification_vo.dart';

extension NotificationResponseMapper on NotificationResponse {
  NotificationVO toVO() => NotificationVO(
        id: id,
        audience: audience,
        shopId: shopId,
        bookingId: bookingId,
        type: type,
        customerName: customerNameSnapshot,
        stadiumName: stadiumNameSnapshot,
        courtName: courtNameSnapshot,
        bookingDate: bookingDate,
        startMinute: startMinute,
        endMinute: endMinute,
        reason: reason,
        isRead: isRead,
        createdAt: createdAt,
      );
}
