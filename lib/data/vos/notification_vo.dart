import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/domain_enums.dart';

part 'notification_vo.freezed.dart';

/// An in-app notification about one booking event. CUSTOMER scope
/// (confirmed / rejected) or SHOP scope (requested / cancelled). Title and
/// body are built from [type] in the UI, so they follow the app language.
@freezed
class NotificationVO with _$NotificationVO {
  const factory NotificationVO({
    required String id,
    required NotificationAudience audience,
    required String shopId,
    required String bookingId,
    required NotificationType type,
    required String customerName,
    required String stadiumName,
    required String courtName,
    required String bookingDate,
    required int startMinute,
    required int endMinute,
    String? reason,
    required bool isRead,
    DateTime? createdAt,
  }) = _NotificationVO;
}
