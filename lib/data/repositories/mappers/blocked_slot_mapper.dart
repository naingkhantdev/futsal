import '../../responses/blocked_slot_response.dart';
import '../../vos/blocked_slot_vo.dart';

extension BlockedSlotResponseMapper on BlockedSlotResponse {
  BlockedSlotVO toVO() => BlockedSlotVO(
        id: id,
        shopId: shopId,
        stadiumId: stadiumId,
        courtId: courtId,
        date: date,
        startMinute: startMinute,
        endMinute: endMinute,
        slotMinutes: slotMinutes,
        startAt: startAt,
        endAt: endAt,
        reason: reason,
        note: note,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
