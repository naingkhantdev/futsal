import '../responses/push_message_response.dart';

/// FCM access (permission, topics, incoming messages) as typed Responses.
/// Throws raw Firebase errors; the repository maps them.
abstract interface class PushDataAgent {
  bool get supportsTopics;

  Future<bool> requestPermission();

  Future<void> subscribe(String topic);

  Future<void> unsubscribe(String topic);

  /// Removes every topic subscription of this install.
  Future<void> reset();

  Stream<PushMessageResponse> get foregroundMessages;

  Stream<PushMessageResponse> get openedMessages;

  Future<PushMessageResponse?> initialMessage();
}
