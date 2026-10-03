import 'package:flutter/foundation.dart';

import '../../core/constants/booking_policy.dart';
import '../../core/constants/cancellation_policy.dart';
import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/stadium_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `stadiums/{stadiumId}`.
///
/// Fail closed: missing `isActive` / `isPublished` read as `false`; missing
/// opening hours read as `0`/`0` (no bookable slots); unknown facility keys
/// are dropped; a fractional or missing `minHourlyPrice` reads as `null`.
@immutable
class StadiumResponse {
  const StadiumResponse({
    required this.id,
    required this.shopId,
    required this.name,
    required this.images,
    required this.facilities,
    required this.openMinute,
    required this.closeMinute,
    required this.timeZone,
    required this.isActive,
    required this.isPublished,
    this.description,
    this.address,
    this.township,
    this.city,
    this.latitude,
    this.longitude,
    this.minHourlyPrice,
    this.surfaces = const [],
    this.freeCancelHours,
    this.cancellationNote,
    this.createdAt,
    this.updatedAt,
  });

  factory StadiumResponse.fromFirestore(String id, Map<String, dynamic> data) {
    return StadiumResponse(
      id: id,
      shopId: FirestoreRead.string(data[StadiumFields.shopId]) ?? '',
      name: FirestoreRead.string(data[StadiumFields.name]) ?? '',
      description: FirestoreRead.string(data[StadiumFields.description]),
      address: FirestoreRead.string(data[StadiumFields.address]),
      township: FirestoreRead.string(data[StadiumFields.township]),
      city: FirestoreRead.string(data[StadiumFields.city]),
      latitude: FirestoreRead.decimal(data[StadiumFields.latitude]),
      longitude: FirestoreRead.decimal(data[StadiumFields.longitude]),
      images: FirestoreRead.strings(data[StadiumFields.images]),
      facilities: [
        for (final key in FirestoreRead.strings(data[StadiumFields.facilities]))
          if (Facility.tryParse(key) case final Facility f) f,
      ],
      openMinute: FirestoreRead.integer(data[StadiumFields.openMinute]) ?? 0,
      closeMinute: FirestoreRead.integer(data[StadiumFields.closeMinute]) ?? 0,
      timeZone: FirestoreRead.string(data[StadiumFields.timeZone]) ??
          BookingPolicy.defaultTimeZone,
      isActive: FirestoreRead.flag(data[StadiumFields.isActive]),
      isPublished: FirestoreRead.flag(data[StadiumFields.isPublished]),
      minHourlyPrice: _amount(data[StadiumFields.minHourlyPrice]),
      surfaces: [
        for (final key in FirestoreRead.strings(data[StadiumFields.surfaces]))
          if (CourtSurface.tryParse(key) case final CourtSurface s) s,
      ],
      freeCancelHours: switch (
          FirestoreRead.integer(data[StadiumFields.freeCancelHours])) {
        final h? when CancellationPolicy.freeCancelHourOptions.contains(h) => h,
        _ => null,
      },
      cancellationNote:
          FirestoreRead.string(data[StadiumFields.cancellationNote]),
      createdAt: FirestoreRead.date(data[StadiumFields.createdAt]),
      updatedAt: FirestoreRead.date(data[StadiumFields.updatedAt]),
    );
  }

  final String id;
  final String shopId;
  final String name;
  final String? description;
  final String? address;
  final String? township;
  final String? city;
  final double? latitude;
  final double? longitude;
  final List<String> images;
  final List<Facility> facilities;
  final int openMinute;
  final int closeMinute;
  final String timeZone;
  final bool isActive;

  /// Server-maintained; see `StadiumFields.isPublished`.
  final bool isPublished;

  /// Server-maintained; int MMK.
  final int? minHourlyPrice;

  /// Client-maintained; see `StadiumFields.surfaces`.
  final List<CourtSurface> surfaces;

  /// See `CancellationPolicy`; `null` = no stated policy.
  final int? freeCancelHours;
  final String? cancellationNote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static int? _amount(Object? v) {
    final n = FirestoreRead.integer(v);
    return n != null && n >= 0 ? n : null;
  }
}
