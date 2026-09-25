import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'court_fields.dart';
import 'court_slot_fields.dart';
import 'firestore_instance.dart';
import 'firestore_paths.dart';
import 'stadium_fields.dart';

/// Access to `stadiums/{id}/courts` and their `slots` lock docs.
///
/// Court writes are SHOP scope (admins of the stadium's shop,
/// firestore.rules) and stamp `updatedAt` (and `createdAt` on create) with
/// the server time. Slot lock docs are written only by `SlotLockWriter`.
class CourtsCollection {
  CourtsCollection(this._firestore);

  final FirebaseFirestore _firestore;

  /// Courts of one stadium, by name.
  ///
  /// Customers MUST pass `activeOnly: true`: firestore.rules let non-admins
  /// list courts only when every result is active (and the parent stadium is
  /// published). Admins of the owning shop may list all courts.
  /// Index: courts (isActive, name).
  Query<JsonMap> _courts(String stadiumId, {required bool activeOnly}) {
    Query<JsonMap> query =
        _firestore.collection(FirestorePaths.courts(stadiumId));
    if (activeOnly) {
      query = query.where(CourtFields.isActive, isEqualTo: true);
    }
    return query.orderBy(CourtFields.name);
  }

  Stream<QuerySnapshot<JsonMap>> watchCourts(
    String stadiumId, {
    required bool activeOnly,
  }) =>
      _courts(stadiumId, activeOnly: activeOnly).snapshots();

  Stream<DocumentSnapshot<JsonMap>> watchCourt(
    String stadiumId,
    String courtId,
  ) =>
      _firestore.doc(FirestorePaths.court(stadiumId, courtId)).snapshots();

  /// SHOP scope: every court of the stadium (active or not).
  Future<QuerySnapshot<JsonMap>> getAll(String stadiumId) =>
      _firestore.collection(FirestorePaths.courts(stadiumId)).get();

  /// A fresh random court id (no network call).
  String newId(String stadiumId) =>
      _firestore.collection(FirestorePaths.courts(stadiumId)).doc().id;

  /// Creates ([create] true) or updates the court and, in the same batch,
  /// the parent stadium's display-only `minHourlyPrice`.
  Future<void> save(
    String stadiumId,
    String courtId, {
    required bool create,
    required JsonMap court,
    required int? minHourlyPrice,
  }) async {
    final now = FieldValue.serverTimestamp();
    final ref = _firestore.doc(FirestorePaths.court(stadiumId, courtId));
    final batch = _firestore.batch();
    if (create) {
      batch.set(ref, {
        ...court,
        CourtFields.createdAt: now,
        CourtFields.updatedAt: now,
      });
    } else {
      batch.update(ref, {...court, CourtFields.updatedAt: now});
    }
    batch.update(_firestore.doc(FirestorePaths.stadium(stadiumId)), {
      StadiumFields.minHourlyPrice: minHourlyPrice,
      StadiumFields.updatedAt: now,
    });
    await batch.commit();
  }

  /// Slot lock docs of one court on one local date. Single-field equality,
  /// so the automatic index is enough (sorted client-side).
  Stream<QuerySnapshot<JsonMap>> watchSlots(
    String stadiumId,
    String courtId,
    String dateKey,
  ) =>
      _firestore
          .collection(FirestorePaths.courtSlots(stadiumId, courtId))
          .where(CourtSlotFields.date, isEqualTo: dateKey)
          .snapshots();
}

final courtsCollectionProvider = Provider<CourtsCollection>(
  (ref) => CourtsCollection(ref.watch(firestoreProvider)),
);
