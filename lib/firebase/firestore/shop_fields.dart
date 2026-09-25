/// Field names of `shops/{shopId}` (master notes §13 SHOP MODEL).
///
/// This doc is readable by any signed-in user while the shop is active and
/// listed, so it holds only customer-safe fields. Admin-only fields live in
/// `shops/{shopId}/private/details` ([ShopPrivateFields]).
///
/// Written by the superadmin only (firestore.rules `validShopShape`).
abstract final class ShopFields {
  static const String name = 'name';
  static const String slug = 'slug';
  static const String description = 'description';
  static const String logo = 'logo';
  static const String coverImage = 'coverImage';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String address = 'address';
  static const String township = 'township';
  static const String city = 'city';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';

  /// `ShopStatus` wire value. Only `active` + [isListed] shops are public.
  static const String status = 'status';
  static const String isListed = 'isListed';
  static const String approvedAt = 'approvedAt';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

/// Field names of `shops/{shopId}/private/details` — superadmin and that
/// shop's admins may read; only the superadmin writes.
abstract final class ShopPrivateFields {
  static const String shopId = 'shopId';
  static const String ownerName = 'ownerName';
  static const String ownerPhone = 'ownerPhone';

  /// Uids of the shop's admins (display only; `users/{uid}.shopId` is what
  /// grants access).
  static const String adminIds = 'adminIds';
  static const String approvedBy = 'approvedBy';
  static const String suspendedAt = 'suspendedAt';
  static const String suspendedReason = 'suspendedReason';
  static const String updatedAt = 'updatedAt';
}
