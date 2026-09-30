import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/messaging/messaging_service.dart';
import '../responses/push_message_response.dart';
import 'push_data_agent.dart';

class PushDataAgentImpl implements PushDataAgent {
  PushDataAgentImpl(this._messaging);

  final MessagingService _messaging;

  @override
  bool get supportsTopics => _messaging.supportsTopics;

  @override
  Future<bool> requestPermission() => _messaging.requestPermission();

  @override
  Future<void> subscribe(String topic) => _messaging.subscribe(topic);

  @override
  Future<void> unsubscribe(String topic) => _messaging.unsubscribe(topic);

  @override
  Future<void> reset() => _messaging.deleteToken();

  @override
  Stream<PushMessageResponse> get foregroundMessages =>
      _messaging.onForegroundMessage.map(_toResponse);

  @override
  Stream<PushMessageResponse> get openedMessages =>
      _messaging.onMessageOpenedApp.map(_toResponse);

  @override
  Future<PushMessageResponse?> initialMessage() async {
    final message = await _messaging.getInitialMessage();
    return message == null ? null : _toResponse(message);
  }

  static PushMessageResponse _toResponse(RemoteMessage m) =>
      PushMessageResponse.fromParts(
        title: m.notification?.title,
        body: m.notification?.body,
        data: m.data,
      );
}

final pushDataAgentProvider = Provider<PushDataAgent>(
  (ref) => PushDataAgentImpl(ref.watch(messagingServiceProvider)),
);
