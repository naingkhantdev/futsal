import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/domain_enums.dart';

part 'player_profile_vo.freezed.dart';

/// A public player card (`players/{uid}`). CUSTOMER (self) scope: only the
/// owner writes it; any active user can read it (match invites, find a
/// game). Holds no contact details.
@freezed
class PlayerProfileVO with _$PlayerProfileVO {
  const factory PlayerProfileVO({
    required String uid,
    required String displayName,
    required PlayerPosition position,
    required SkillLevel skillLevel,
    String? bio,
    DateTime? updatedAt,
  }) = _PlayerProfileVO;

  const PlayerProfileVO._();

  bool get hasBio => bio != null && bio!.trim().isNotEmpty;
}
