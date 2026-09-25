import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/booking_policy.dart';
import '../../core/constants/domain_enums.dart';
import '../../core/utils/time_range.dart';

part 'blocked_slot_vo.freezed.dart';

/// A blocked court time range (`blocked_slots/{blockedSlotId}`).
/// Same date/minute representation as `BookingVO`. Admin-written (with its
/// slot lock docs); at most `BookingPolicy.maxSlotsPerBooking` slots.
@freezed
class BlockedSlotVO with _$BlockedSlotVO {
  const BlockedSlotVO._();

  const factory BlockedSlotVO({
    required String id,
    required String shopId,
    required String stadiumId,
    required String courtId,
    required String date,
    required int startMinute,
    required int endMinute,
    @Default(BookingPolicy.defaultSlotMinutes) int slotMinutes,
    DateTime? startAt,
    DateTime? endAt,
    required BlockedSlotReason reason,
    String? note,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BlockedSlotVO;

  TimeRange get timeRange => TimeRange(startMinute, endMinute);
}
