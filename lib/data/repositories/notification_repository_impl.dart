import '../../core/constants/domain_enums.dart';
import '../../core/errors/error_guard.dart';
import '../data_agents/notification_data_agent.dart';
import '../vos/notification_vo.dart';
import 'mappers/notification_mapper.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationDataAgent notificationDataAgent,
  }) : _notifications = notificationDataAgent;

  final NotificationDataAgent _notifications;

  /// Firestore batch limit is 500 writes; stay well below it.
  static const int _maxBatch = 100;

  @override
  Stream<List<NotificationVO>> watchInbox(
    NotificationAudience audience,
    String recipientId,
  ) {
    return mapStreamErrors(
      _notifications
          .watchInbox(audience, recipientId)
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Future<void> markRead(List<String> notificationIds) {
    return guardAppException(() async {
      for (var i = 0; i < notificationIds.length; i += _maxBatch) {
        final end = (i + _maxBatch).clamp(0, notificationIds.length);
        await _notifications.markRead(notificationIds.sublist(i, end));
      }
    });
  }
}
