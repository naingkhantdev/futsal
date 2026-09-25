import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/shop_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `shops/{shopId}` (customer-safe public fields).
///
/// Fail closed: an unknown or missing `status` reads as
/// [ShopStatus.inactive] and a missing `isListed` as `false`, so a malformed
/// doc can never make a shop look bookable.
@immutable
class ShopResponse {
  const ShopResponse({
    required this.id,
    required this.name,
    required this.status,
    required this.isListed,
    this.slug,
    this.description,
    this.logo,
    this.coverImage,
    this.phone,
    this.email,
    this.address,
    this.township,
    this.city,
    this.latitude,
    this.longitude,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ShopResponse.fromFirestore(String id, Map<String, dynamic> data) {
    return ShopResponse(
      id: id,
      name: FirestoreRead.string(data[ShopFields.name]) ?? '',
      slug: FirestoreRead.string(data[ShopFields.slug]),
      description: FirestoreRead.string(data[ShopFields.description]),
      logo: FirestoreRead.string(data[ShopFields.logo]),
      coverImage: FirestoreRead.string(data[ShopFields.coverImage]),
      phone: FirestoreRead.string(data[ShopFields.phone]),
      email: FirestoreRead.string(data[ShopFields.email]),
      address: FirestoreRead.string(data[ShopFields.address]),
      township: FirestoreRead.string(data[ShopFields.township]),
      city: FirestoreRead.string(data[ShopFields.city]),
      latitude: FirestoreRead.decimal(data[ShopFields.latitude]),
      longitude: FirestoreRead.decimal(data[ShopFields.longitude]),
      status:
          ShopStatus.tryParse(FirestoreRead.string(data[ShopFields.status])) ??
              ShopStatus.inactive,
      isListed: FirestoreRead.flag(data[ShopFields.isListed]),
      approvedAt: FirestoreRead.date(data[ShopFields.approvedAt]),
      createdAt: FirestoreRead.date(data[ShopFields.createdAt]),
      updatedAt: FirestoreRead.date(data[ShopFields.updatedAt]),
    );
  }

  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? logo;
  final String? coverImage;
  final String? phone;
  final String? email;
  final String? address;
  final String? township;
  final String? city;
  final double? latitude;
  final double? longitude;
  final ShopStatus status;
  final bool isListed;
  final DateTime? approvedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
