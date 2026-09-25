import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_instance.dart';
import 'firestore_paths.dart';
import 'stadium_fields.dart';

/// Access to `stadiums`. Every stadium query is defined here.
///
/// Writes are SHOP scope (admins of the stadium's shop, firestore.rules)
/// and stamp `updatedAt` (and `createdAt` on create) with the server time.
class StadiumsCollection {
  StadiumsCollection(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<JsonMap> get _stadiums =>
      _firestore.collection(FirestoreCollections.stadiums);

  DocumentReference<JsonMap> _doc(String stadiumId) =>
      _firestore.doc(FirestorePaths.stadium(stadiumId));

  /// CUSTOMER discovery query.
  ///
  /// MUST keep `isPublished == true`: firestore.rules only let non-admins
  /// list stadiums when every possible result is published, so a query
  /// without this filter is rejected as a whole. Indexes:
  /// firestore.indexes.json (isPublished [+ city] [+ township], name).
  Query<JsonMap> _published({String? city, String? township}) {
    Query<JsonMap> query =
        _stadiums.where(StadiumFields.isPublished, isEqualTo: true);
    if (city != null) {
      query = query.where(StadiumFields.city, isEqualTo: city);
    }
    if (township != null) {
      query = query.where(StadiumFields.township, isEqualTo: township);
    }
    return query.orderBy(StadiumFields.name);
  }

  Stream<QuerySnapshot<JsonMap>> watchPublished({
    String? city,
    String? township,
  }) =>
      _published(city: city, township: township).snapshots();

  /// SHOP scope: all stadiums of [shopId], including inactive ones. The
  /// `shopId` filter is what firestore.rules require for a shop admin's
  /// list query. Unordered (single-field index); callers sort by name.
  Query<JsonMap> _ofShop(String shopId) =>
      _stadiums.where(StadiumFields.shopId, isEqualTo: shopId);

  Stream<QuerySnapshot<JsonMap>> watchByShop(String shopId) =>
      _ofShop(shopId).snapshots();

  Future<QuerySnapshot<JsonMap>> getByShop(String shopId) =>
      _ofShop(shopId).get();

  /// A fresh random document id (no network call).
  String newId() => _stadiums.doc().id;

  Future<void> create(String stadiumId, JsonMap data) {
    final now = FieldValue.serverTimestamp();
    return _doc(stadiumId).set({
      ...data,
      StadiumFields.createdAt: now,
      StadiumFields.updatedAt: now,
    });
  }

  Future<void> update(String stadiumId, JsonMap fields) {
    return _doc(stadiumId).update({
      ...fields,
      StadiumFields.updatedAt: FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot<JsonMap>> get(String stadiumId) =>
      _doc(stadiumId).get();

  Stream<DocumentSnapshot<JsonMap>> watch(String stadiumId) =>
      _doc(stadiumId).snapshots();
}

final stadiumsCollectionProvider = Provider<StadiumsCollection>(
  (ref) => StadiumsCollection(ref.watch(firestoreProvider)),
);
