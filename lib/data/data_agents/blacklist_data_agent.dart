import '../responses/blacklist_entry_response.dart';

/// `shops/{shopId}/blacklist` access as typed Responses. SHOP scope
/// (enforced by firestore.rules). Throws raw Firebase errors; repositories
/// map them to `AppException`.
abstract interface class BlacklistDataAgent {
  /// Every entry of the shop, newest first (admins / superadmin).
  Stream<List<BlacklistEntryResponse>> watchShopBlacklist(String shopId);

  /// Emits `null` while [customerId] is not blacklisted at [shopId].
  Stream<BlacklistEntryResponse?> watchEntry(String shopId, String customerId);

  /// Whether [customerId] is blacklisted at [shopId]. Allowed for the shop's
  /// admins and for the customer themselves.
  Future<bool> isBlacklisted(String shopId, String customerId);

  /// [fields] are already serialized (without `createdAt`).
  Future<void> addEntry(
    String shopId,
    String customerId,
    Map<String, Object?> fields,
  );

  Future<void> removeEntry(String shopId, String customerId);
}
