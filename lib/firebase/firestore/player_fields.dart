/// Field names of `players/{uid}`. CUSTOMER (self) scope, no `shopId`:
/// written only by the owner, readable by every active user
/// (firestore.rules `validPlayer`).
abstract final class PlayerFields {
  /// Copy of `users/{uid}.name`; the rules require them to match on write.
  static const String displayName = 'displayName';

  /// `PlayerPosition` wire value.
  static const String position = 'position';

  /// `SkillLevel` wire value.
  static const String skillLevel = 'skillLevel';
  static const String bio = 'bio';
  static const String updatedAt = 'updatedAt';
}
