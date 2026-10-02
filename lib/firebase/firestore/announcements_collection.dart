import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'announcement_fields.dart';
import 'firestore_instance.dart';
import 'firestore_paths.dart';

/// Access to `announcements`. Raw maps stay below the data agent; errors
/// propagate raw.
class AnnouncementsCollection {
  AnnouncementsCollection(this._firestore);

  final FirebaseFirestore _firestore;

  static const int defaultLimit = 100;

  CollectionReference<JsonMap> get _announcements =>
      _firestore.collection(FirestoreCollections.announcements);

  /// PLATFORM scope (superadmin only): newest first. Single-field
  /// ordering, no composite index.
  Stream<QuerySnapshot<JsonMap>> watchAll({int limit = defaultLimit}) {
    return _announcements
        .orderBy(AnnouncementFields.createdAt, descending: true)
        .limit(limit)
        .snapshots();
  }

  /// Creates a new doc; `createdAt` is the server time (rules require
  /// `== request.time`). Returns its id.
  Future<String> create(JsonMap fields) async {
    final ref = _announcements.doc();
    await ref.set({
      ...fields,
      AnnouncementFields.createdAt: FieldValue.serverTimestamp(),
    });
    return ref.id;
  }
}

final announcementsCollectionProvider = Provider<AnnouncementsCollection>(
  (ref) => AnnouncementsCollection(ref.watch(firestoreProvider)),
);
