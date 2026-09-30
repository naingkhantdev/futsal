import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../data_agents/notification_data_agent_impl.dart';
import '../vos/notification_vo.dart';
import 'notification_repository_impl.dart';

/// In-app notifications. Every method throws / emits only `AppException`.
///
/// Spark plan: there is no server to send them, so the booking repository
/// writes one doc per booking event right after the booking change (best
/// effort; firestore.rules check it against the booking). CUSTOMER scope:
/// own inbox; SHOP scope: the admin's shop inbox, shared by its admins.
abstract interface class NotificationRepository {
  /// Newest first (latest 50). [recipientId] is the customer's uid for
  /// [NotificationAudience.customer], the shopId for
  /// [NotificationAudience.shop]; the rules refuse anyone else's inbox.
  Stream<List<NotificationVO>> watchInbox(
    NotificationAudience audience,
    String recipientId,
  );

  /// No-op for an empty list.
  Future<void> markRead(List<String> notificationIds);
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepositoryImpl(
    notificationDataAgent: ref.watch(notificationDataAgentProvider),
  ),
);
