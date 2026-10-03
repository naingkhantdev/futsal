import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/player_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `players/{uid}`. `null` from [tryFromFirestore] when the
/// position or skill level is unknown (e.g. written by a newer app version).
@immutable
class PlayerResponse {
  const PlayerResponse({
    required this.uid,
    required this.displayName,
    required this.position,
    required this.skillLevel,
    this.bio,
    this.updatedAt,
  });

  static PlayerResponse? tryFromFirestore(
    String uid,
    Map<String, dynamic> data,
  ) {
    final position = PlayerPosition.tryParse(
      FirestoreRead.string(data[PlayerFields.position]),
    );
    final skill = SkillLevel.tryParse(
      FirestoreRead.string(data[PlayerFields.skillLevel]),
    );
    if (position == null || skill == null) return null;
    return PlayerResponse(
      uid: uid,
      displayName: FirestoreRead.string(data[PlayerFields.displayName]) ?? '',
      position: position,
      skillLevel: skill,
      bio: FirestoreRead.string(data[PlayerFields.bio]),
      updatedAt: FirestoreRead.date(data[PlayerFields.updatedAt]),
    );
  }

  final String uid;
  final String displayName;
  final PlayerPosition position;
  final SkillLevel skillLevel;
  final String? bio;
  final DateTime? updatedAt;
}
