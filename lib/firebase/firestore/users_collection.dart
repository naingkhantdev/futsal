import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_instance.dart';
import 'user_fields.dart';

export 'firestore_instance.dart' show JsonMap, firestoreProvider;

/// Thin access to the `users` collection. Raw maps stay below the data
/// agent; errors propagate raw and are mapped in repositories.
///
/// Every write stamps `updatedAt` (and `createdAt` on create) with the
/// server time: firestore.rules require `== request.time`.
class UsersCollection {
  UsersCollection(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<JsonMap> _doc(String uid) =>
      _firestore.collection(FirestoreCollections.users).doc(uid);

  Stream<DocumentSnapshot<JsonMap>> watch(String uid) =>
      _doc(uid).snapshots();

  /// PLATFORM scope (superadmin only): admins assigned to [shopId].
  /// Equality-only filters, so no composite index is needed.
  Stream<QuerySnapshot<JsonMap>> watchShopAdmins(
    String shopId, {
    required String shopAdminRole,
  }) {
    return _firestore
        .collection(FirestoreCollections.users)
        .where(UserFields.role, isEqualTo: shopAdminRole)
        .where(UserFields.shopId, isEqualTo: shopId)
        .snapshots();
  }

  /// PLATFORM scope (superadmin only): every account with [role].
  /// Equality-only filter, so no composite index is needed.
  Stream<QuerySnapshot<JsonMap>> watchByRole(String role) {
    return _firestore
        .collection(FirestoreCollections.users)
        .where(UserFields.role, isEqualTo: role)
        .snapshots();
  }

  /// PLATFORM scope (superadmin only): accounts with exactly [email].
  Future<QuerySnapshot<JsonMap>> findByEmail(String email) {
    return _firestore
        .collection(FirestoreCollections.users)
        .where(UserFields.email, isEqualTo: email)
        .limit(5)
        .get();
  }

  /// One-off read (server when online, cache otherwise).
  Future<DocumentSnapshot<JsonMap>> get(String uid) => _doc(uid).get();

  /// Creates `users/{uid}` with [fields] unless it already exists.
  /// Returns `false` when the doc was already there (nothing written).
  ///
  /// A transaction, so registration and the session's recovery path can
  /// both call it without one overwriting the other (rules would reject the
  /// overwrite anyway). Fails fast when offline.
  Future<bool> createIfMissing(String uid, Map<String, Object?> fields) {
    final ref = _doc(uid);
    return _firestore.runTransaction<bool>((tx) async {
      final snapshot = await tx.get(ref);
      if (snapshot.exists) return false;
      tx.set(ref, {
        ...fields,
        UserFields.createdAt: FieldValue.serverTimestamp(),
        UserFields.updatedAt: FieldValue.serverTimestamp(),
      });
      return true;
    });
  }

  /// Updates [fields] (plus `updatedAt`). Which keys are allowed depends on
  /// who writes (self: profile fields; superadmin: role/shopId/isActive of
  /// another user) and is enforced by firestore.rules.
  Future<void> update(String uid, Map<String, Object?> fields) {
    return _doc(uid).update({
      ...fields,
      UserFields.updatedAt: FieldValue.serverTimestamp(),
    });
  }
}

final usersCollectionProvider = Provider<UsersCollection>(
  (ref) => UsersCollection(ref.watch(firestoreProvider)),
);
