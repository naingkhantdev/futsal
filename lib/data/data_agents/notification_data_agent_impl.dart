import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/notifications_collection.dart';
import '../requests/notification_requests.dart';
import '../responses/notification_response.dart';
import 'notification_data_agent.dart';

class NotificationDataAgentImpl implements NotificationDataAgent {
  NotificationDataAgentImpl(this._notifications);

  final NotificationsCollection _notifications;

  @override
  Stream<List<NotificationResponse>> watchInbox(
    NotificationAudience audience,
    String recipientId,
  ) {
    return _notifications
        .watchInbox(audience: audience.name, recipientId: recipientId)
        .map(
          (query) => [
            for (final doc in query.docs)
              if (NotificationResponse.tryFromFirestore(doc.id, doc.data())
                  case final r?)
                r,
          ],
        );
  }

  @override
  Future<void> create(NotificationCreateRequest request) =>
      _notifications.create(request.id, request.toFirestore());

  @override
  Future<void> markRead(Iterable<String> notificationIds) =>
      _notifications.markRead(notificationIds);
}

final notificationDataAgentProvider = Provider<NotificationDataAgent>(
  (ref) => NotificationDataAgentImpl(ref.watch(notificationsCollectionProvider)),
);
