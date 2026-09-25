import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/money.dart';
import '../../core/utils/time_range.dart';

part 'court_vo.freezed.dart';

/// A bookable court (`stadiums/{stadiumId}/courts/{courtId}`).
///
/// Slot and price helpers mirror firestore.rules, which re-check both on
/// every booking.
@freezed
class CourtVO with _$CourtVO {
  const CourtVO._();

  const factory CourtVO({
    required String id,
    required String shopId,
    required String stadiumId,
    required String name,
    String? description,
    String? surfaceType,
    int? capacity,

    /// Int MMK per hour; `null` when unset or malformed (not bookable).
    int? hourlyPrice,
    required String currency,
    required int slotMinutes,
    @Default(<String>[]) List<String> images,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CourtVO;

  bool get hasPrice => hourlyPrice != null;

  /// Slots of this court within the stadium's opening hours.
  List<TimeRange> slots({required int openMinute, required int closeMinute}) =>
      SlotRules.generateSlots(
        openMinute: openMinute,
        closeMinute: closeMinute,
        slotMinutes: slotMinutes,
      );

  /// Preview price for [minutes]; `null` when unpriced or [minutes] is not a
  /// whole number of slots.
  int? previewPrice(int minutes) {
    final price = hourlyPrice;
    if (price == null) return null;
    return Money.totalPrice(
      hourlyPrice: price,
      minutes: minutes,
      slotMinutes: slotMinutes,
    );
  }
}
