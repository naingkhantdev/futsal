import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/domain_enums.dart';
import '../../core/utils/time_range.dart';

part 'stadium_vo.freezed.dart';

/// A futsal venue (`stadiums/{stadiumId}`).
///
/// [isPublished] and [minHourlyPrice] are client-maintained denormalisations
/// (Spark plan: no triggers); display/discovery only. Bookings re-check the
/// shop, stadium and court in firestore.rules.
/// Opening hours are minutes from local midnight in [timeZone].
@freezed
class StadiumVO with _$StadiumVO {
  const StadiumVO._();

  const factory StadiumVO({
    required String id,
    required String shopId,
    required String name,
    String? description,
    String? address,
    String? township,
    String? city,
    double? latitude,
    double? longitude,
    @Default(<String>[]) List<String> images,
    @Default(<Facility>[]) List<Facility> facilities,
    required int openMinute,
    required int closeMinute,
    required String timeZone,
    required bool isActive,
    required bool isPublished,

    /// Int MMK; `null` when the stadium has no active priced court.
    int? minHourlyPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StadiumVO;

  TimeRange get openingHours => TimeRange(openMinute, closeMinute);

  bool get hasValidOpeningHours =>
      SlotRules.isValidOpeningHours(openMinute, closeMinute);

  String? get coverImage => images.isEmpty ? null : images.first;

  bool get hasLocation => latitude != null && longitude != null;
}
