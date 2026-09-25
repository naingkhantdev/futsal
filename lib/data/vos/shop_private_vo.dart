import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_private_vo.freezed.dart';

/// Admin-only shop details (`shops/{shopId}/private/details`).
/// Readable by the superadmin and that shop's admins only.
@freezed
class ShopPrivateVO with _$ShopPrivateVO {
  const factory ShopPrivateVO({
    required String shopId,
    String? ownerName,
    String? ownerPhone,
    @Default(<String>[]) List<String> adminIds,
    String? approvedBy,
    DateTime? suspendedAt,
    String? suspendedReason,
    DateTime? updatedAt,
  }) = _ShopPrivateVO;
}
