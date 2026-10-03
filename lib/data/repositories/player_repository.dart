import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../data_agents/auth_data_agent_impl.dart';
import '../data_agents/player_data_agent_impl.dart';
import '../data_agents/user_data_agent_impl.dart';
import '../vos/player_profile_vo.dart';
import 'player_repository_impl.dart';

/// CUSTOMER (self) scope: public player cards (`players/{uid}`). No
/// `shopId`, so no shop can be affected. Every method throws / emits only
/// `AppException`. Any active user can read a card; only its owner writes
/// it (firestore.rules `validPlayer`).
abstract interface class PlayerRepository {
  /// `null` while [uid] has no card.
  Stream<PlayerProfileVO?> watch(String uid);

  /// Creates or replaces the signed-in user's card. The display name is
  /// copied from `users/{uid}.name` (the rules require them to match), so
  /// this throws `ProfileIncompleteException` while the profile has no name.
  Future<void> saveMine({
    required PlayerPosition position,
    required SkillLevel skillLevel,
    String? bio,
  });

  /// Re-copies the account name onto the user's card, if they have one.
  /// Best effort: call after the name changes.
  Future<void> syncMyDisplayName();
}

final playerRepositoryProvider = Provider<PlayerRepository>(
  (ref) => PlayerRepositoryImpl(
    playerDataAgent: ref.watch(playerDataAgentProvider),
    userDataAgent: ref.watch(userDataAgentProvider),
    authDataAgent: ref.watch(authDataAgentProvider),
  ),
);
