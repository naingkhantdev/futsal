import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/domain_enums.dart';
import '../../core/utils/time_range.dart';

part 'court_availability_vo.freezed.dart';

/// One occupied slot (a slot lock doc; no customer data).
@freezed
class BusySlotVO with _$BusySlotVO {
  const BusySlotVO._();

  const factory BusySlotVO({
    /// Slot lock doc id (`SlotKey.of(date, startMinute)`).
    required String slotId,
    required int startMinute,
    required int endMinute,
    required BusyKind kind,

    /// Booking id or blocked-slot id.
    String? refId,
  }) = _BusySlotVO;

  TimeRange get range => TimeRange(startMinute, endMinute);
}

/// Occupied slots of one court on one local date, from
/// `stadiums/{sid}/courts/{cid}/slots` (`where date == date`).
///
/// No docs means nothing is busy ([CourtAvailabilityVO.empty]). For display
/// only: firestore.rules refuse any booking that touches a taken slot.
@freezed
class CourtAvailabilityVO with _$CourtAvailabilityVO {
  const CourtAvailabilityVO._();

  const factory CourtAvailabilityVO({
    required String stadiumId,
    required String courtId,
    required String date,

    /// Sorted by start minute.
    @Default(<BusySlotVO>[]) List<BusySlotVO> busy,
  }) = _CourtAvailabilityVO;

  factory CourtAvailabilityVO.empty({
    required String stadiumId,
    required String courtId,
    required String date,
  }) =>
      CourtAvailabilityVO(stadiumId: stadiumId, courtId: courtId, date: date);

  /// Busy slots overlapping [range].
  List<BusySlotVO> overlapping(TimeRange range) =>
      busy.where((b) => b.range.overlaps(range)).toList();

  bool isFree(TimeRange range) => !busy.any((b) => b.range.overlaps(range));

  /// Why [range] is unavailable, or `null` when free. `blocked` wins over
  /// `booked` when both overlap.
  BusyKind? busyKindFor(TimeRange range) {
    BusyKind? result;
    for (final b in busy) {
      if (!b.range.overlaps(range)) continue;
      if (b.kind == BusyKind.blocked) return BusyKind.blocked;
      result = b.kind;
    }
    return result;
  }
}
