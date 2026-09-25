import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_instance.dart';
import 'firestore_paths.dart';

/// `blocked_slots` reads and id generation (admin / superadmin only per
/// firestore.rules). Atomic writes with slot docs go through
/// `SlotLockWriter`. List queries arrive with the Phase 11 admin UI and
/// must filter `shopId == users/{uid}.shopId`.
class BlockedSlotsCollection {
  BlockedSlotsCollection(this._firestore);

  final FirebaseFirestore _firestore;

  String newId() =>
      _firestore.collection(FirestoreCollections.blockedSlots).doc().id;

  Future<DocumentSnapshot<JsonMap>> get(String blockedSlotId) =>
      _firestore.doc(FirestorePaths.blockedSlot(blockedSlotId)).get();
}

final blockedSlotsCollectionProvider = Provider<BlockedSlotsCollection>(
  (ref) => BlockedSlotsCollection(ref.watch(firestoreProvider)),
);
