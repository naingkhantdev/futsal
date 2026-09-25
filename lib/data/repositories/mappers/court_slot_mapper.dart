import '../../responses/court_slot_response.dart';
import '../../vos/court_availability_vo.dart';

extension CourtSlotResponseMapper on CourtSlotResponse {
  BusySlotVO toVO() => BusySlotVO(
        slotId: id,
        startMinute: startMinute,
        endMinute: endMinute,
        kind: kind,
        refId: refId,
      );
}

extension CourtSlotListMapper on List<CourtSlotResponse> {
  /// Busy slots of one court-day, sorted by start minute.
  CourtAvailabilityVO toAvailability({
    required String stadiumId,
    required String courtId,
    required String date,
  }) {
    final busy = [for (final s in this) s.toVO()]
      ..sort((a, b) => a.startMinute.compareTo(b.startMinute));
    return CourtAvailabilityVO(
      stadiumId: stadiumId,
      courtId: courtId,
      date: date,
      busy: busy,
    );
  }
}
