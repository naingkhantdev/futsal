import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'court_slot_fields.dart';
import 'firestore_instance.dart';

/// Atomic writes of a parent doc (booking or blocked slot) together with its
/// slot lock docs. Thin: no validation, errors propagate raw.
///
/// Runs as Firestore transactions (not plain batches) so that
/// - a slot taken by someone else is seen before committing (clear
///   "conflict" result instead of an ambiguous permission-denied), and
/// - the call fails fast when offline instead of queueing a write the
///   rules may reject later.
/// Correctness does NOT depend on this: firestore.rules refuse any request
/// that touches an existing slot doc.
class SlotLockWriter {
  SlotLockWriter(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<JsonMap> doc(String path) => _firestore.doc(path);

  /// Creates [parent] with [parentData] and every slot in [slots] (path ->
  /// data). Returns `false`, writing nothing, if any slot already exists.
  /// Stamps `createdAt`/`updatedAt` on the parent and `createdAt` on slots
  /// with the server time (rules require `== request.time`).
  Future<bool> createWithSlots({
    required String parentPath,
    required JsonMap parentData,
    required Map<String, JsonMap> slots,
  }) {
    final parent = _firestore.doc(parentPath);
    final slotRefs = {
      for (final path in slots.keys) path: _firestore.doc(path),
    };
    return _firestore.runTransaction<bool>((tx) async {
      for (final ref in slotRefs.values) {
        final snapshot = await tx.get(ref);
        if (snapshot.exists) return false;
      }
      final now = FieldValue.serverTimestamp();
      tx.set(parent, {
        ...parentData,
        'createdAt': now,
        'updatedAt': now,
      });
      for (final MapEntry(key: path, value: data) in slots.entries) {
        tx.set(slotRefs[path]!, {...data, CourtSlotFields.createdAt: now});
      }
      return true;
    });
  }

  /// Updates [parentPath] with [fields] (+ `updatedAt` and every key in
  /// [serverTimeFields] set to the server time) and deletes the slot docs
  /// at [slotPaths], atomically.
  Future<void> updateAndDeleteSlots({
    required String parentPath,
    required JsonMap fields,
    Set<String> serverTimeFields = const {},
    List<String> slotPaths = const [],
  }) {
    final parent = _firestore.doc(parentPath);
    return _firestore.runTransaction<void>((tx) async {
      final now = FieldValue.serverTimestamp();
      tx.update(parent, {
        ...fields,
        for (final key in serverTimeFields) key: now,
        'updatedAt': now,
      });
      for (final path in slotPaths) {
        tx.delete(_firestore.doc(path));
      }
    });
  }

  /// Deletes [parentPath] and the slot docs at [slotPaths], atomically.
  Future<void> deleteWithSlots({
    required String parentPath,
    required List<String> slotPaths,
  }) {
    return _firestore.runTransaction<void>((tx) async {
      tx.delete(_firestore.doc(parentPath));
      for (final path in slotPaths) {
        tx.delete(_firestore.doc(path));
      }
    });
  }
}

final slotLockWriterProvider = Provider<SlotLockWriter>(
  (ref) => SlotLockWriter(ref.watch(firestoreProvider)),
);
