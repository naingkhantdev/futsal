import 'package:flutter/foundation.dart';

import '../../core/constants/booking_policy.dart';
import '../../firebase/firestore/court_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `stadiums/{stadiumId}/courts/{courtId}`.
///
/// Fail closed: missing `isActive` reads as `false`; a missing, negative or
/// fractional `hourlyPrice` reads as `null` (not bookable). A missing or
/// out-of-range `slotMinutes` falls back to the default (60).
@immutable
class CourtResponse {
  const CourtResponse({
    required this.id,
    required this.shopId,
    required this.stadiumId,
    required this.name,
    required this.currency,
    required this.slotMinutes,
    required this.images,
    required this.isActive,
    this.description,
    this.surfaceType,
    this.capacity,
    this.hourlyPrice,
    this.createdAt,
    this.updatedAt,
  });

  /// [stadiumId] falls back to the parent path id when the body lacks it.
  factory CourtResponse.fromFirestore(
    String id,
    Map<String, dynamic> data, {
    required String parentStadiumId,
  }) {
    final price = FirestoreRead.integer(data[CourtFields.hourlyPrice]);
    final slot = FirestoreRead.integer(data[CourtFields.slotMinutes]);
    final capacity = FirestoreRead.integer(data[CourtFields.capacity]);
    return CourtResponse(
      id: id,
      shopId: FirestoreRead.string(data[CourtFields.shopId]) ?? '',
      stadiumId:
          FirestoreRead.string(data[CourtFields.stadiumId]) ?? parentStadiumId,
      name: FirestoreRead.string(data[CourtFields.name]) ?? '',
      description: FirestoreRead.string(data[CourtFields.description]),
      surfaceType: FirestoreRead.string(data[CourtFields.surfaceType]),
      capacity: capacity != null && capacity > 0 ? capacity : null,
      hourlyPrice: price != null && price >= 0 ? price : null,
      currency: FirestoreRead.string(data[CourtFields.currency]) ??
          BookingPolicy.currency,
      slotMinutes:
          slot != null && slot > 0 && slot <= BookingPolicy.minutesPerDay
              ? slot
              : BookingPolicy.defaultSlotMinutes,
      images: FirestoreRead.strings(data[CourtFields.images]),
      isActive: FirestoreRead.flag(data[CourtFields.isActive]),
      createdAt: FirestoreRead.date(data[CourtFields.createdAt]),
      updatedAt: FirestoreRead.date(data[CourtFields.updatedAt]),
    );
  }

  final String id;
  final String shopId;
  final String stadiumId;
  final String name;
  final String? description;
  final String? surfaceType;
  final int? capacity;

  /// Int MMK per hour.
  final int? hourlyPrice;
  final String currency;
  final int slotMinutes;
  final List<String> images;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
