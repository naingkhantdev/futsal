import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_instance.dart';
import 'firestore_paths.dart';
import 'shop_fields.dart';
import 'stadium_fields.dart';

/// Access to `shops/{shopId}` and its private details doc. Raw maps stay
/// below the data agent; errors propagate raw.
///
/// Writes are PLATFORM scope (superadmin only, firestore.rules). Every write
/// stamps `updatedAt` (and `createdAt` on create) with the server time: the
/// rules require `== request.time`.
class ShopsCollection {
  ShopsCollection(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<JsonMap> get _shops =>
      _firestore.collection(FirestoreCollections.shops);

  DocumentReference<JsonMap> _shop(String shopId) =>
      _firestore.doc(FirestorePaths.shop(shopId));

  DocumentReference<JsonMap> _private(String shopId) =>
      _firestore.doc(FirestorePaths.shopPrivateDetails(shopId));

  /// Public shop doc. Rules: superadmin, that shop's admins, or any
  /// signed-in user while the shop is active + listed.
  Stream<DocumentSnapshot<JsonMap>> watchShop(String shopId) =>
      _shop(shopId).snapshots();

  Future<DocumentSnapshot<JsonMap>> getShop(String shopId) =>
      _shop(shopId).get();

  /// Admin-only details. Rules: superadmin or that shop's admins.
  Stream<DocumentSnapshot<JsonMap>> watchPrivateDetails(String shopId) =>
      _private(shopId).snapshots();

  /// PLATFORM scope: every shop, by name (superadmin only).
  Stream<QuerySnapshot<JsonMap>> watchAll() =>
      _shops.orderBy(ShopFields.name).snapshots();

  /// Creates the shop and its private details doc in one batch. Returns
  /// the new shop id.
  Future<String> create({
    required JsonMap shop,
    required JsonMap details,
  }) async {
    final ref = _shops.doc();
    final now = FieldValue.serverTimestamp();
    final batch = _firestore.batch()
      ..set(ref, {
        ...shop,
        ShopFields.createdAt: now,
        ShopFields.updatedAt: now,
      })
      ..set(_private(ref.id), {
        ...details,
        ShopPrivateFields.shopId: ref.id,
        ShopPrivateFields.updatedAt: now,
      });
    await batch.commit();
    return ref.id;
  }

  /// Updates [shop] fields and merges [details] into the private doc, in
  /// one batch. When [stadiumPublished] is given (shop status / listing
  /// changed), each listed stadium's `isPublished` is re-synced in the same
  /// batch, as firestore.rules require.
  Future<void> update(
    String shopId, {
    required JsonMap shop,
    JsonMap details = const {},
    Map<String, bool> stadiumPublished = const {},
  }) async {
    final now = FieldValue.serverTimestamp();
    final batch = _firestore.batch()
      ..update(_shop(shopId), {...shop, ShopFields.updatedAt: now});
    if (details.isNotEmpty) {
      batch.set(
        _private(shopId),
        {
          ...details,
          ShopPrivateFields.shopId: shopId,
          ShopPrivateFields.updatedAt: now,
        },
        SetOptions(merge: true),
      );
    }
    for (final MapEntry(key: stadiumId, value: published)
        in stadiumPublished.entries) {
      batch.update(_firestore.doc(FirestorePaths.stadium(stadiumId)), {
        StadiumFields.isPublished: published,
        StadiumFields.updatedAt: now,
      });
    }
    await batch.commit();
  }
}

final shopsCollectionProvider = Provider<ShopsCollection>(
  (ref) => ShopsCollection(ref.watch(firestoreProvider)),
);
