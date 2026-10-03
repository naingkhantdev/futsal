import '../../responses/player_response.dart';
import '../../vos/player_profile_vo.dart';

extension PlayerResponseMapper on PlayerResponse {
  PlayerProfileVO toVO() => PlayerProfileVO(
        uid: uid,
        displayName: displayName,
        position: position,
        skillLevel: skillLevel,
        bio: bio,
        updatedAt: updatedAt,
      );
}
