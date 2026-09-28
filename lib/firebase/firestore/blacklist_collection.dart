import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'blacklist_fields.dart';
import 'firestore_instance.dart';
import 'firestore_paths.dart';

/// Access to `shops/{shopId}/blacklist`. Raw maps stay below the data
/// agent; errors propagate raw.
///
/// Rules: list / write by that shop's admins or the superadmin; a customer
/// can only `get` their own entry.
class BlacklistCollection {
  BlacklistCollection(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<JsonMap> _entry(String shopId, String customerId) =>
      _firestore.doc(FirestorePaths.shopBlacklistEntry(shopId, customerId));

  /// Newest first.
  Stream<QuerySnapshot<JsonMap>> watchShop(String shopId) => _firestore
      .collection(FirestorePaths.shopBlacklist(shopId))
      .orderBy(BlacklistFields.createdAt, descending: true)
      .snapshots();

  Stream<DocumentSnapshot<JsonMap>> watchEntry(
    String shopId,
    String customerId,
  ) =>
      _entry(shopId, customerId).snapshots();

  Future<DocumentSnapshot<JsonMap>> getEntry(
    String shopId,
    String customerId,
  ) =>
      _entry(shopId, customerId).get();

  /// Creates the entry; `createdAt` is the server time (rules require
  /// `== request.time`). Fails if it already exists (no update rule).
  Future<void> create(String shopId, String customerId, JsonMap fields) =>
      _entry(shopId, customerId).set({
        ...fields,
        BlacklistFields.createdAt: FieldValue.serverTimestamp(),
      });

  Future<void> delete(String shopId, String customerId) =>
      _entry(shopId, customerId).delete();
}

final blacklistCollectionProvider = Provider<BlacklistCollection>(
  (ref) => BlacklistCollection(ref.watch(firestoreProvider)),
);
