import '../responses/shop_private_response.dart';
import '../responses/shop_response.dart';

/// `shops/{shopId}` access as typed Responses. Writes are PLATFORM scope
/// (superadmin only, enforced by firestore.rules). Throws raw Firebase
/// errors; repositories map them to `AppException`.
abstract interface class ShopDataAgent {
  /// Emits `null` while the doc does not exist.
  Stream<ShopResponse?> watchShop(String shopId);

  /// One-off read; `null` when the doc does not exist.
  Future<ShopResponse?> getShop(String shopId);

  /// SHOP / PLATFORM scope only (rules deny customers).
  Stream<ShopPrivateResponse?> watchShopPrivateDetails(String shopId);

  /// PLATFORM scope: every shop, by name.
  Stream<List<ShopResponse>> watchShops();

  /// PLATFORM scope. [shop] / [details] are already-serialized fields
  /// (without timestamps). Returns the new shop id.
  Future<String> createShop({
    required Map<String, Object?> shop,
    required Map<String, Object?> details,
  });

  /// PLATFORM scope. Updates [shop] fields, merges [details] into the
  /// private doc and sets `isPublished` on each stadium in
  /// [stadiumPublished], in one batch.
  Future<void> updateShop(
    String shopId, {
    required Map<String, Object?> shop,
    Map<String, Object?> details = const {},
    Map<String, bool> stadiumPublished = const {},
  });
}
