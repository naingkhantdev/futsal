// Collection names moved to firestore_paths.dart; re-exported so existing
// imports keep working.
export 'firestore_paths.dart' show FirestoreCollections;

/// Field names of `users/{uid}` (master notes §6 + shopId).
///
/// This doc is THE source of truth for roles (Spark plan: no custom claims).
/// firestore.rules:
/// - self-create once, as `{role: 'customer', shopId: null, isActive: true}`
///   with `email == auth email`;
/// - self-update: [name], [phone], [profileImage], [updatedAt] only;
/// - superadmin (on other users only): [role], [shopId], [isActive],
///   [updatedAt].
abstract final class UserFields {
  static const String name = 'name';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String profileImage = 'profileImage';

  /// `UserRole` wire value. Authoritative (read by firestore.rules).
  static const String role = 'role';

  /// SHOP scope: the shop a shop admin manages; `null` for other roles.
  static const String shopId = 'shopId';
  static const String isActive = 'isActive';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}
