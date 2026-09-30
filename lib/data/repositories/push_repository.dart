import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../data_agents/push_data_agent_impl.dart';
import '../vos/push_message_vo.dart';
import 'push_repository_impl.dart';

/// Push notifications (FCM). Every method throws / emits only
/// `AppException`.
///
/// Spark plan: receive only. Pushes are sent from the Firebase console to
/// the topics in `PushTopics`; booking events reach users as in-app
/// notifications (`NotificationRepository`) instead.
abstract interface class PushRepository {
  /// Asks for permission (first time only) and subscribes this install to
  /// `all`, the role's topic and, for a shop admin, the shop's topic.
  /// Other roles' topics are dropped. Safe to call on every sign-in.
  Future<void> enableFor({required UserRole role, String? shopId});

  /// Drops every subscription (sign-out).
  Future<void> disable();

  Stream<PushMessageVO> get foregroundMessages;

  /// Pushes the user tapped while the app ran in the background.
  Stream<PushMessageVO> get openedMessages;

  /// The push that launched the app, if any.
  Future<PushMessageVO?> initialMessage();
}

final pushRepositoryProvider = Provider<PushRepository>(
  (ref) => PushRepositoryImpl(pushDataAgent: ref.watch(pushDataAgentProvider)),
);
