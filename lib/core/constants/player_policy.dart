/// Player card limits. MIRRORED in firestore.rules (`validPlayer`); change
/// both together.
abstract final class PlayerPolicy {
  /// Longest optional "about me" text.
  static const int bioMaxLength = 200;
}
