import 'package:flutter/foundation.dart';

import '../../core/constants/booking_policy.dart';
import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/blocked_slot_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `blocked_slots/{blockedSlotId}` (admin-written, validated
/// by firestore.rules). An unknown `reason` reads as
/// [BlockedSlotReason.other]; a missing `slotMinutes` as the default (60).
@immutable
class BlockedSlotResponse {
  const BlockedSlotResponse({
    required this.id,
    required this.shopId,
    required this.stadiumId,
    required this.courtId,
    required this.date,
    required this.startMinute,
    required this.endMinute,
    required this.reason,
    this.slotMinutes = BookingPolicy.defaultSlotMinutes,
    this.note,
    this.startAt,
    this.endAt,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory BlockedSlotResponse.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    String str(String key) => FirestoreRead.string(data[key]) ?? '';
    final slot = FirestoreRead.integer(data[BlockedSlotFields.slotMinutes]);
    return BlockedSlotResponse(
      id: id,
      shopId: str(BlockedSlotFields.shopId),
      stadiumId: str(BlockedSlotFields.stadiumId),
      courtId: str(BlockedSlotFields.courtId),
      date: str(BlockedSlotFields.date),
      startMinute:
          FirestoreRead.integer(data[BlockedSlotFields.startMinute]) ?? 0,
      endMinute: FirestoreRead.integer(data[BlockedSlotFields.endMinute]) ?? 0,
      slotMinutes:
          slot != null && slot > 0 && slot <= BookingPolicy.minutesPerDay
              ? slot
              : BookingPolicy.defaultSlotMinutes,
      startAt: FirestoreRead.date(data[BlockedSlotFields.startAt]),
      endAt: FirestoreRead.date(data[BlockedSlotFields.endAt]),
      reason: BlockedSlotReason.tryParse(
            FirestoreRead.string(data[BlockedSlotFields.reason]),
          ) ??
          BlockedSlotReason.other,
      note: FirestoreRead.string(data[BlockedSlotFields.note]),
      createdBy: FirestoreRead.string(data[BlockedSlotFields.createdBy]),
      createdAt: FirestoreRead.date(data[BlockedSlotFields.createdAt]),
      updatedAt: FirestoreRead.date(data[BlockedSlotFields.updatedAt]),
    );
  }

  final String id;
  final String shopId;
  final String stadiumId;
  final String courtId;

  /// `yyyy-MM-dd`, stadium local time.
  final String date;
  final int startMinute;
  final int endMinute;

  /// Court slot length when blocked; locates the block's slot docs.
  final int slotMinutes;
  final DateTime? startAt;
  final DateTime? endAt;
  final BlockedSlotReason reason;
  final String? note;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
