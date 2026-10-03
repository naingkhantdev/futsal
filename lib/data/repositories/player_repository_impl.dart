import '../../core/constants/domain_enums.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../data_agents/auth_data_agent.dart';
import '../data_agents/player_data_agent.dart';
import '../data_agents/user_data_agent.dart';
import '../vos/player_profile_vo.dart';
import 'mappers/player_mapper.dart';
import 'player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl({
    required PlayerDataAgent playerDataAgent,
    required UserDataAgent userDataAgent,
    required AuthDataAgent authDataAgent,
  })  : _players = playerDataAgent,
        _users = userDataAgent,
        _auth = authDataAgent;

  final PlayerDataAgent _players;
  final UserDataAgent _users;
  final AuthDataAgent _auth;

  @override
  Stream<PlayerProfileVO?> watch(String uid) {
    return mapStreamErrors(_players.watch(uid).map((r) => r?.toVO()));
  }

  @override
  Future<void> saveMine({
    required PlayerPosition position,
    required SkillLevel skillLevel,
    String? bio,
  }) {
    return guardAppException(() async {
      final (uid, name) = await _myUidAndName();
      final trimmedBio = bio?.trim();
      await _players.save(
        uid: uid,
        displayName: name,
        position: position,
        skillLevel: skillLevel,
        bio: trimmedBio == null || trimmedBio.isEmpty ? null : trimmedBio,
      );
    });
  }

  @override
  Future<void> syncMyDisplayName() {
    return guardAppException(() async {
      final (uid, name) = await _myUidAndName();
      final card = await _players.watch(uid).first;
      if (card == null || card.displayName == name) return;
      await _players.save(
        uid: uid,
        displayName: name,
        position: card.position,
        skillLevel: card.skillLevel,
        bio: card.bio,
      );
    });
  }

  Future<(String, String)> _myUidAndName() async {
    final user = _auth.currentUser;
    if (user == null) throw const AuthenticationException();
    final profile = await _users.getUser(user.uid);
    // Sent untrimmed: the rules compare it with the stored name verbatim.
    final name = profile?.name ?? '';
    // Mirrors the rules' validName (2..80 chars).
    if (name.trim().length < 2) throw const ProfileIncompleteException();
    return (user.uid, name);
  }
}
