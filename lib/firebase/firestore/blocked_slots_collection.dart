import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'blocked_slot_fields.dart';
import 'firestore_instance.dart';
import 'firestore_paths.dart';

/// `blocked_slots` reads and id generation (admin / superadmin only per
/// firestore.rules). Atomic writes with slot docs go through
/// `SlotLockWriter`. List queries must filter
/// `shopId == users/{uid}.shopId`.
class BlockedSlotsCollection {
  BlockedSlotsCollection(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<JsonMap> get _blocked =>
      _firestore.collection(FirestoreCollections.blockedSlots);

  String newId() => _blocked.doc().id;

  Future<DocumentSnapshot<JsonMap>> get(String blockedSlotId) =>
      _firestore.doc(FirestorePaths.blockedSlot(blockedSlotId)).get();

  /// SHOP scope: blocks of [shopId] ending after [from], earliest first.
  /// Index: blocked_slots (shopId, endAt).
  Stream<QuerySnapshot<JsonMap>> watchShop(
    String shopId, {
    required DateTime from,
  }) {
    return _blocked
        .where(BlockedSlotFields.shopId, isEqualTo: shopId)
        .where(
          BlockedSlotFields.endAt,
          isGreaterThan: Timestamp.fromDate(from),
        )
        .orderBy(BlockedSlotFields.endAt)
        .snapshots();
  }
}

final blockedSlotsCollectionProvider = Provider<BlockedSlotsCollection>(
  (ref) => BlockedSlotsCollection(ref.watch(firestoreProvider)),
);
