import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/domain_enums.dart';

part 'shop_vo.freezed.dart';

/// Public shop profile (`shops/{shopId}`).
///
/// [status] and [isListed] are set by the superadmin only;
/// [isVisibleToCustomers] is for display — firestore.rules decide access.
@freezed
class ShopVO with _$ShopVO {
  const ShopVO._();

  const factory ShopVO({
    required String id,
    required String name,
    String? slug,
    String? description,
    String? logo,
    String? coverImage,
    String? phone,
    String? email,
    String? address,
    String? township,
    String? city,
    double? latitude,
    double? longitude,
    required ShopStatus status,
    required bool isListed,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ShopVO;

  /// Active and listed: shown in discovery and open for new bookings.
  bool get isVisibleToCustomers => status == ShopStatus.active && isListed;
}
