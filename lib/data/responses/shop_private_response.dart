import 'package:flutter/foundation.dart';

import '../../firebase/firestore/shop_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `shops/{shopId}/private/details` (superadmin + that shop's
/// admins only).
@immutable
class ShopPrivateResponse {
  const ShopPrivateResponse({
    required this.shopId,
    required this.adminIds,
    this.ownerName,
    this.ownerPhone,
    this.approvedBy,
    this.suspendedAt,
    this.suspendedReason,
    this.updatedAt,
  });

  /// [shopId] comes from the path, not the doc body.
  factory ShopPrivateResponse.fromFirestore(
    String shopId,
    Map<String, dynamic> data,
  ) {
    return ShopPrivateResponse(
      shopId: shopId,
      ownerName: FirestoreRead.string(data[ShopPrivateFields.ownerName]),
      ownerPhone: FirestoreRead.string(data[ShopPrivateFields.ownerPhone]),
      adminIds: FirestoreRead.strings(data[ShopPrivateFields.adminIds]),
      approvedBy: FirestoreRead.string(data[ShopPrivateFields.approvedBy]),
      suspendedAt: FirestoreRead.date(data[ShopPrivateFields.suspendedAt]),
      suspendedReason:
          FirestoreRead.string(data[ShopPrivateFields.suspendedReason]),
      updatedAt: FirestoreRead.date(data[ShopPrivateFields.updatedAt]),
    );
  }

  final String shopId;
  final String? ownerName;
  final String? ownerPhone;
  final List<String> adminIds;
  final String? approvedBy;
  final DateTime? suspendedAt;
  final String? suspendedReason;
  final DateTime? updatedAt;
}
