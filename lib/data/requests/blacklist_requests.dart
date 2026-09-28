import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/blacklist_fields.dart';

/// SHOP scope: blacklist one customer at the admin's shop. `shopId`,
/// `createdBy` and `createdAt` are set by the data layer; firestore.rules
/// check every field.
@immutable
class BlacklistAddRequest {
  const BlacklistAddRequest({
    required this.customerId,
    required this.customerName,
    required this.reason,
    this.customerPhone,
    this.note,
  });

  final String customerId;

  /// Snapshots from the customer's booking (admins can't read users/{uid}).
  final String customerName;
  final String? customerPhone;
  final BlacklistReason reason;
  final String? note;

  Map<String, Object?> toFields({
    required String shopId,
    required String createdBy,
  }) {
    final phone = customerPhone?.trim() ?? '';
    final text = note?.trim() ?? '';
    return {
      BlacklistFields.shopId: shopId,
      BlacklistFields.customerId: customerId,
      BlacklistFields.customerNameSnapshot: customerName.trim(),
      BlacklistFields.customerPhoneSnapshot: phone.isEmpty ? null : phone,
      BlacklistFields.reason: reason.name,
      BlacklistFields.note: text.isEmpty ? null : text,
      BlacklistFields.createdBy: createdBy,
    };
  }
}
