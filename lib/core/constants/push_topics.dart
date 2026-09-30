import 'domain_enums.dart';

/// FCM topic names. Pick these as the target of a Firebase console campaign
/// (Messaging → New campaign → Notifications → Target: Topic).
///
/// Anyone can subscribe to a topic, but only the console (or a server)
/// can send to it, so never put private data in a topic push.
abstract final class PushTopics {
  /// Every signed-in user.
  static const String all = 'all';

  /// `role_customer`, `role_shopAdmin`, `role_superadmin`.
  static String role(UserRole role) => 'role_${role.name}';

  /// Admins of one shop: `shop_{shopId}`.
  static String shop(String shopId) => 'shop_$shopId';
}
