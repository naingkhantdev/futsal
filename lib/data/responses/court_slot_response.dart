import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/court_slot_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for one slot lock doc
/// (`stadiums/{sid}/courts/{cid}/slots/{slotId}`; no customer data).
///
/// Fail closed: an unknown `kind` reads as [BusyKind.blocked] (the time stays
/// busy either way). A doc without usable minutes yields `null` from
/// [tryFromFirestore] and is skipped.
@immutable
class CourtSlotResponse {
  const CourtSlotResponse({
    required this.id,
    required this.shopId,
    required this.stadiumId,
    required this.courtId,
    required this.date,
    required this.startMinute,
    required this.endMinute,
    required this.kind,
    this.refId,
    this.createdBy,
    this.createdAt,
  });

  /// Ids fall back to the doc path when the body lacks them.
  static CourtSlotResponse? tryFromFirestore(
    String id,
    Map<String, dynamic> data, {
    required String stadiumId,
    required String courtId,
  }) {
    final start = FirestoreRead.integer(data[CourtSlotFields.startMinute]);
    final end = FirestoreRead.integer(data[CourtSlotFields.endMinute]);
    if (start == null || end == null) return null;
    return CourtSlotResponse(
      id: id,
      shopId: FirestoreRead.string(data[CourtSlotFields.shopId]) ?? '',
      stadiumId:
          FirestoreRead.string(data[CourtSlotFields.stadiumId]) ?? stadiumId,
      courtId: FirestoreRead.string(data[CourtSlotFields.courtId]) ?? courtId,
      date: FirestoreRead.string(data[CourtSlotFields.date]) ?? '',
      startMinute: start,
      endMinute: end,
      kind: BusyKind.tryParse(
            FirestoreRead.string(data[CourtSlotFields.kind]),
          ) ??
          BusyKind.blocked,
      refId: FirestoreRead.string(data[CourtSlotFields.refId]),
      createdBy: FirestoreRead.string(data[CourtSlotFields.createdBy]),
      createdAt: FirestoreRead.date(data[CourtSlotFields.createdAt]),
    );
  }

  final String id;
  final String shopId;
  final String stadiumId;
  final String courtId;

  /// `yyyy-MM-dd`, stadium local.
  final String date;
  final int startMinute;
  final int endMinute;
  final BusyKind kind;

  /// Booking id or blocked-slot id.
  final String? refId;
  final String? createdBy;
  final DateTime? createdAt;
}
