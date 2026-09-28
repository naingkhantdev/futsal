import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/domain_enums.dart';

part 'blacklist_entry_vo.freezed.dart';

/// A customer blocked from new bookings at one shop
/// (`shops/{shopId}/blacklist/{customerId}`). SHOP scope; enforced by the
/// booking create rule. Existing bookings are not affected.
@freezed
class BlacklistEntryVO with _$BlacklistEntryVO {
  const factory BlacklistEntryVO({
    required String customerId,
    required String shopId,
    required String customerName,
    String? customerPhone,
    required BlacklistReason reason,
    String? note,
    String? createdBy,
    DateTime? createdAt,
  }) = _BlacklistEntryVO;
}
