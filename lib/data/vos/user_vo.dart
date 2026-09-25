import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/domain_enums.dart';

part 'user_vo.freezed.dart';

/// Signed-in user's profile (`users/{uid}`), as used by UI/providers.
///
/// [role], [shopId] and [isActive] are the role fields firestore.rules
/// authorize against; only a superadmin can change them (`UserRepository`).
/// The user edits only [name] and [phone]; [profileImage] upload arrives in
/// Phase 13.
@freezed
class UserVO with _$UserVO {
  const UserVO._();

  const factory UserVO({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? profileImage,
    UserRole? role,
    String? shopId,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserVO;

  bool get hasName => name.trim().isNotEmpty;

  bool get hasPhone => phone != null && phone!.trim().isNotEmpty;
}
