/// Shop blacklist limits. MIRRORED in firestore.rules
/// (`validBlacklistEntry`); change both together.
abstract final class BlacklistPolicy {
  /// Longest optional note an admin can add.
  static const int noteMaxLength = 200;
}
