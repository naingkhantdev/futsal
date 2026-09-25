import '../../../core/constants/domain_enums.dart';
import '../../responses/user_response.dart';
import '../../vos/user_vo.dart';

extension UserResponseMapper on UserResponse {
  UserVO toVO() => UserVO(
        id: id,
        name: name,
        email: email,
        phone: phone,
        profileImage: profileImage,
        // Display-only mirror; unknown strings become null, never a default.
        role: UserRole.tryParse(role),
        shopId: shopId,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
