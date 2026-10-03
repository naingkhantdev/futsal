import '../../core/constants/domain_enums.dart';
import '../responses/player_response.dart';

/// `players` access as typed Responses. Throws raw Firebase errors;
/// repositories map them. firestore.rules decide which writes succeed.
abstract interface class PlayerDataAgent {
  /// `null` while the user has no player card.
  Stream<PlayerResponse?> watch(String uid);

  /// Creates or replaces [uid]'s card.
  Future<void> save({
    required String uid,
    required String displayName,
    required PlayerPosition position,
    required SkillLevel skillLevel,
    String? bio,
  });
}
