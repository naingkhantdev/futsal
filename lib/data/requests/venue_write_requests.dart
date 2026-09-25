import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/court_fields.dart';
import '../../firebase/firestore/shop_fields.dart';
import '../../firebase/firestore/stadium_fields.dart';

/// Typed write DTOs for shops, stadiums and courts: the fields an admin
/// edits in a form. Built by feature controllers, serialized by data
/// agents. Ownership (`shopId`), derived fields (`isPublished`,
/// `minHourlyPrice`) and timestamps are NOT here: the data layer sets them,
/// and firestore.rules check every one.

/// Trimmed text, or `null` when blank (stored as null, never "").
String? _text(String? value) {
  final v = value?.trim() ?? '';
  return v.isEmpty ? null : v;
}

/// PLATFORM scope: shop profile + owner contact (superadmin form).
@immutable
class ShopProfileRequest {
  const ShopProfileRequest({
    required this.name,
    this.description,
    this.phone,
    this.email,
    this.address,
    this.township,
    this.city,
    this.ownerName,
    this.ownerPhone,
  });

  final String name;
  final String? description;
  final String? phone;
  final String? email;
  final String? address;
  final String? township;
  final String? city;
  final String? ownerName;
  final String? ownerPhone;

  /// Public `shops/{shopId}` fields.
  Map<String, Object?> toShopFields() => {
        ShopFields.name: name.trim(),
        ShopFields.description: _text(description),
        ShopFields.phone: _text(phone),
        ShopFields.email: _text(email)?.toLowerCase(),
        ShopFields.address: _text(address),
        ShopFields.township: _text(township),
        ShopFields.city: _text(city),
      };

  /// Admin-only `shops/{shopId}/private/details` fields.
  Map<String, Object?> toPrivateFields() => {
        ShopPrivateFields.ownerName: _text(ownerName),
        ShopPrivateFields.ownerPhone: _text(ownerPhone),
      };
}

/// PLATFORM scope: a shop status / listing change (superadmin). Built by
/// `ShopRepository`, which also re-syncs the shop's stadiums.
@immutable
class ShopStatusRequest {
  const ShopStatusRequest({
    required this.status,
    required this.isListed,
    this.approvedAt,
    this.approvedBy,
    this.suspendedAt,
    this.suspendedReason,
  });

  final ShopStatus status;
  final bool isListed;

  /// Set on first approval only; display only.
  final DateTime? approvedAt;
  final String? approvedBy;

  /// Set when suspending; cleared (null) otherwise.
  final DateTime? suspendedAt;
  final String? suspendedReason;

  Map<String, Object?> toShopFields() => {
        ShopFields.status: status.name,
        ShopFields.isListed: isListed,
        if (approvedAt != null) ShopFields.approvedAt: approvedAt,
      };

  Map<String, Object?> toPrivateFields() => {
        if (approvedBy != null) ShopPrivateFields.approvedBy: approvedBy,
        ShopPrivateFields.suspendedAt: suspendedAt,
        ShopPrivateFields.suspendedReason: _text(suspendedReason),
      };
}

/// SHOP scope: the stadium fields a shop admin edits.
@immutable
class StadiumWriteRequest {
  const StadiumWriteRequest({
    required this.name,
    required this.openMinute,
    required this.closeMinute,
    required this.isActive,
    this.description,
    this.address,
    this.township,
    this.city,
    this.facilities = const [],
  });

  final String name;
  final String? description;
  final String? address;
  final String? township;
  final String? city;
  final List<Facility> facilities;

  /// Minutes from local midnight; `openMinute` on a whole hour
  /// (`VenuePolicy.openingHourStep`).
  final int openMinute;
  final int closeMinute;
  final bool isActive;

  Map<String, Object?> toFirestore() => {
        StadiumFields.name: name.trim(),
        StadiumFields.description: _text(description),
        StadiumFields.address: _text(address),
        StadiumFields.township: _text(township),
        StadiumFields.city: _text(city),
        StadiumFields.facilities: [for (final f in facilities) f.name],
        StadiumFields.openMinute: openMinute,
        StadiumFields.closeMinute: closeMinute,
        StadiumFields.isActive: isActive,
      };
}

/// SHOP scope: the court fields a shop admin edits.
@immutable
class CourtWriteRequest {
  const CourtWriteRequest({
    required this.name,
    required this.hourlyPrice,
    required this.slotMinutes,
    required this.isActive,
    this.description,
    this.surfaceType,
    this.capacity,
  });

  final String name;
  final String? description;
  final String? surfaceType;
  final int? capacity;

  /// Int MMK per hour.
  final int hourlyPrice;

  /// One of `VenuePolicy.allowedSlotMinutes`. Written on create only: the
  /// rules refuse any change afterwards.
  final int slotMinutes;
  final bool isActive;

  /// Editable fields (everything except [slotMinutes]).
  Map<String, Object?> toUpdateFields() => {
        CourtFields.name: name.trim(),
        CourtFields.description: _text(description),
        CourtFields.surfaceType: _text(surfaceType),
        CourtFields.capacity: capacity,
        CourtFields.hourlyPrice: hourlyPrice,
        CourtFields.isActive: isActive,
      };

  Map<String, Object?> toCreateFields() => {
        ...toUpdateFields(),
        CourtFields.slotMinutes: slotMinutes,
      };
}
