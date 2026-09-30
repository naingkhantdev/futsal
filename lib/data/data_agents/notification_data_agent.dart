import '../../core/constants/domain_enums.dart';
import '../requests/notification_requests.dart';
import '../responses/notification_response.dart';

/// `notifications` access as typed Responses / Requests. CUSTOMER or SHOP
/// scope (enforced by firestore.rules). Throws raw Firebase errors;
/// repositories map them to `AppException`.
abstract interface class NotificationDataAgent {
  /// Newest first. Docs of unknown type are skipped.
  Stream<List<NotificationResponse>> watchInbox(
    NotificationAudience audience,
    String recipientId,
  );

  Future<void> create(NotificationCreateRequest request);

  Future<void> markRead(Iterable<String> notificationIds);
}
