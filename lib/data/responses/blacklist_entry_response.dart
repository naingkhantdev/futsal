import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/blacklist_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `shops/{shopId}/blacklist/{customerId}` (admin-written,
/// validated by firestore.rules). An unknown `reason` reads as
/// [BlacklistReason.other].
@immutable
class BlacklistEntryResponse {
  const BlacklistEntryResponse({
    required this.customerId,
    required this.shopId,
    required this.customerNameSnapshot,
    required this.reason,
    this.customerPhoneSnapshot,
    this.note,
    this.createdBy,
    this.createdAt,
  });

  factory BlacklistEntryResponse.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return BlacklistEntryResponse(
      customerId: id,
      shopId: FirestoreRead.string(data[BlacklistFields.shopId]) ?? '',
      customerNameSnapshot:
          FirestoreRead.string(data[BlacklistFields.customerNameSnapshot]) ??
              '',
      customerPhoneSnapshot:
          FirestoreRead.string(data[BlacklistFields.customerPhoneSnapshot]),
      reason: BlacklistReason.tryParse(
            FirestoreRead.string(data[BlacklistFields.reason]),
          ) ??
          BlacklistReason.other,
      note: FirestoreRead.string(data[BlacklistFields.note]),
      createdBy: FirestoreRead.string(data[BlacklistFields.createdBy]),
      createdAt: FirestoreRead.date(data[BlacklistFields.createdAt]),
    );
  }

  /// Doc id.
  final String customerId;
  final String shopId;
  final String customerNameSnapshot;
  final String? customerPhoneSnapshot;
  final BlacklistReason reason;
  final String? note;
  final String? createdBy;
  final DateTime? createdAt;
}
