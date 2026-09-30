import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_options.dart';

/// Thin wrapper over Firebase Cloud Messaging. Errors propagate raw.
///
/// Spark plan: the app only RECEIVES pushes. They are sent from the
/// Firebase console (Messaging → campaigns) to topics; automatic
/// per-booking pushes need a server (Blaze + Cloud Functions).
class MessagingService {
  MessagingService(this._messaging);

  final FirebaseMessaging _messaging;

  /// Topics are not supported on web.
  bool get supportsTopics => !kIsWeb;

  /// Shows the OS prompt the first time (Android 13+, iOS). True when
  /// notifications are allowed (fully or provisionally).
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> subscribe(String topic) => _messaging.subscribeToTopic(topic);

  Future<void> unsubscribe(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  /// Drops this install's token, and with it every topic subscription
  /// (used on sign-out so the next user starts clean).
  Future<void> deleteToken() => _messaging.deleteToken();

  /// Messages received while the app is in the foreground (the OS shows
  /// nothing for those).
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  /// The user tapped a push while the app was in the background.
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// The push that launched the app from terminated, once.
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();
}

/// Runs in its own isolate for pushes received while the app is in the
/// background or terminated. Notification pushes are shown by the OS
/// without it; it only has to exist and initialize Firebase.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

final messagingServiceProvider = Provider<MessagingService>(
  (ref) => MessagingService(FirebaseMessaging.instance),
);
