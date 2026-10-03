import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/player_fields.dart';
import '../../firebase/firestore/players_collection.dart';
import '../responses/player_response.dart';
import 'player_data_agent.dart';

class PlayerDataAgentImpl implements PlayerDataAgent {
  PlayerDataAgentImpl(this._players);

  final PlayersCollection _players;

  @override
  Stream<PlayerResponse?> watch(String uid) {
    return _players.watch(uid).map((snap) {
      final data = snap.data();
      return data == null ? null : PlayerResponse.tryFromFirestore(uid, data);
    });
  }

  @override
  Future<void> save({
    required String uid,
    required String displayName,
    required PlayerPosition position,
    required SkillLevel skillLevel,
    String? bio,
  }) {
    // Exactly the shape firestore.rules `validPlayer` accepts.
    return _players.save(uid, {
      PlayerFields.displayName: displayName,
      PlayerFields.position: position.name,
      PlayerFields.skillLevel: skillLevel.name,
      if (bio != null) PlayerFields.bio: bio,
    });
  }
}

final playerDataAgentProvider = Provider<PlayerDataAgent>(
  (ref) => PlayerDataAgentImpl(ref.watch(playersCollectionProvider)),
);
