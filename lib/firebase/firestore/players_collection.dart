import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_instance.dart';
import 'firestore_paths.dart';
import 'player_fields.dart';

/// Access to `players`. Raw maps stay below the data agent; errors
/// propagate raw.
class PlayersCollection {
  PlayersCollection(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<JsonMap> _doc(String uid) =>
      _firestore.collection(FirestoreCollections.players).doc(uid);

  Stream<DocumentSnapshot<JsonMap>> watch(String uid) =>
      _doc(uid).snapshots();

  /// Writes the whole card (create or replace). `updatedAt` is the server
  /// time (rules require `== request.time`).
  Future<void> save(String uid, JsonMap fields) {
    return _doc(uid).set({
      ...fields,
      PlayerFields.updatedAt: FieldValue.serverTimestamp(),
    });
  }
}

final playersCollectionProvider = Provider<PlayersCollection>(
  (ref) => PlayersCollection(ref.watch(firestoreProvider)),
);
