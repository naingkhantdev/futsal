import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/firestore/shops_collection.dart';
import '../responses/shop_private_response.dart';
import '../responses/shop_response.dart';
import 'shop_data_agent.dart';

class ShopDataAgentImpl implements ShopDataAgent {
  ShopDataAgentImpl(this._shops);

  final ShopsCollection _shops;

  @override
  Stream<ShopResponse?> watchShop(String shopId) =>
      _shops.watchShop(shopId).map(_fromSnapshot);

  @override
  Future<ShopResponse?> getShop(String shopId) async =>
      _fromSnapshot(await _shops.getShop(shopId));

  @override
  Stream<ShopPrivateResponse?> watchShopPrivateDetails(String shopId) {
    return _shops.watchPrivateDetails(shopId).map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return ShopPrivateResponse.fromFirestore(shopId, data);
    });
  }

  @override
  Stream<List<ShopResponse>> watchShops() {
    return _shops.watchAll().map(
          (query) => [
            for (final doc in query.docs)
              ShopResponse.fromFirestore(doc.id, doc.data()),
          ],
        );
  }

  @override
  Future<String> createShop({
    required Map<String, Object?> shop,
    required Map<String, Object?> details,
  }) {
    return _shops.create(shop: shop, details: details);
  }

  @override
  Future<void> updateShop(
    String shopId, {
    required Map<String, Object?> shop,
    Map<String, Object?> details = const {},
    Map<String, bool> stadiumPublished = const {},
  }) {
    return _shops.update(
      shopId,
      shop: shop,
      details: details,
      stadiumPublished: stadiumPublished,
    );
  }

  static ShopResponse? _fromSnapshot(DocumentSnapshot<Map<String, dynamic>> s) {
    final data = s.data();
    if (!s.exists || data == null) return null;
    return ShopResponse.fromFirestore(s.id, data);
  }
}

final shopDataAgentProvider = Provider<ShopDataAgent>(
  (ref) => ShopDataAgentImpl(ref.watch(shopsCollectionProvider)),
);
