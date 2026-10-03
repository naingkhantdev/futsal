import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/booking_policy.dart';
import '../../core/constants/cancellation_policy.dart';
import '../../core/constants/domain_enums.dart';
import '../../core/utils/time_range.dart';

part 'booking_vo.freezed.dart';

/// A booking (`bookings/{bookingId}`). Written through `BookingRepository`
/// only; every write is validated by firestore.rules.
///
/// [bookingDate] (`yyyy-MM-dd`) and the minutes are stadium-local;
/// [startAt]/[endAt] are the same range as UTC instants.
@freezed
class BookingVO with _$BookingVO {
  const BookingVO._();

  const factory BookingVO({
    required String id,
    required String shopId,
    required String customerId,
    required String stadiumId,
    required String courtId,
    required String bookingDate,
    required int startMinute,
    required int endMinute,

    /// Court slot length at booking time (locates the slot lock docs).
    @Default(BookingPolicy.defaultSlotMinutes) int slotMinutes,
    DateTime? startAt,
    DateTime? endAt,

    /// Int MMK.
    required int pricePerHour,
    required int totalPrice,
    required String currency,
    required BookingStatus status,
    required PaymentStatus paymentStatus,
    required String customerNameSnapshot,
    String? customerPhoneSnapshot,
    required String stadiumNameSnapshot,
    required String courtNameSnapshot,

    /// The venue's free-cancellation window when booked (`null` = none).
    int? freeCancelHours,
    DateTime? cancelledAt,
    String? cancelReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BookingVO;

  TimeRange get timeRange => TimeRange(startMinute, endMinute);

  int get durationMinutes => endMinute - startMinute;

  /// Whether this booking occupies its court time ([BookingPolicy]).
  bool get blocksAvailability => BookingPolicy.blocksAvailability(status);

  RefundState get refundState => CancellationPolicy.refundStateOf(
        status: status,
        paymentStatus: paymentStatus,
        startAt: startAt,
        cancelledAt: cancelledAt,
        freeCancelHours: freeCancelHours,
      );

  /// Whether cancelling at [now] is inside the free-cancellation window.
  /// `null` when the booking carries no policy.
  bool? cancelsFreeAt(DateTime now) {
    final hours = freeCancelHours;
    final start = startAt;
    if (hours == null || start == null) return null;
    return !now.isAfter(CancellationPolicy.freeCancelDeadline(start, hours));
  }

  /// Pending/confirmed and not yet started at [now].
  bool isUpcoming(DateTime now) {
    final start = startAt;
    return start != null && blocksAvailability && start.isAfter(now);
  }
}
