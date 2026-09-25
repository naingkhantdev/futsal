import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/time_range.dart';
import 'court_vo.dart';
import 'stadium_vo.dart';

part 'booking_draft.freezed.dart';

/// What the customer picked in the booking flow (Phase 8): a court of a
/// stadium, a local date and a contiguous range of slots.
///
/// `BookingRepository.createBooking` turns it into the booking + slot lock
/// docs, pre-computing price and times exactly as firestore.rules expect.
/// Nothing here is trusted: the rules re-read the court, stadium and shop.
@freezed
class BookingDraft with _$BookingDraft {
  const BookingDraft._();

  const factory BookingDraft({
    required StadiumVO stadium,
    required CourtVO court,

    /// `yyyy-MM-dd`, stadium local.
    required String date,
    required int startMinute,
    required int endMinute,
  }) = _BookingDraft;

  TimeRange get range => TimeRange(startMinute, endMinute);
}
