import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'booking_fields.dart';
import 'firestore_instance.dart';
import 'firestore_paths.dart';

/// Read access to `bookings` and client-side id generation. Every booking
/// query is defined here; atomic writes with slot docs go through
/// `SlotLockWriter`.
///
/// firestore.rules only allow list queries that are provably scoped:
/// customers must filter `customerId == uid`, shop admins
/// `shopId == users/{uid}.shopId`.
class BookingsCollection {
  BookingsCollection(this._firestore);

  final FirebaseFirestore _firestore;

  /// Page size until Phase 10 adds pagination.
  static const int defaultLimit = 100;

  /// Superadmin cross-shop list cap until pagination lands.
  static const int platformLimit = 500;

  CollectionReference<JsonMap> get _bookings =>
      _firestore.collection(FirestoreCollections.bookings);

  /// A fresh random document id (no network call). The slot docs written in
  /// the same request reference it, so it must be known up front.
  String newId() => _bookings.doc().id;

  Future<DocumentSnapshot<JsonMap>> get(String bookingId) =>
      _firestore.doc(FirestorePaths.booking(bookingId)).get();

  Stream<DocumentSnapshot<JsonMap>> watch(String bookingId) =>
      _firestore.doc(FirestorePaths.booking(bookingId)).snapshots();

  /// PLATFORM scope (superadmin only): latest bookings of every shop,
  /// newest first. Single-field ordering, no composite index.
  Stream<QuerySnapshot<JsonMap>> watchAll({int limit = platformLimit}) {
    return _bookings
        .orderBy(BookingFields.startAt, descending: true)
        .limit(limit)
        .snapshots();
  }

  /// CUSTOMER scope, newest first. Index: bookings (customerId, startAt desc).
  Stream<QuerySnapshot<JsonMap>> watchCustomerBookings(
    String customerId, {
    int limit = defaultLimit,
  }) {
    return _bookings
        .where(BookingFields.customerId, isEqualTo: customerId)
        .orderBy(BookingFields.startAt, descending: true)
        .limit(limit)
        .snapshots();
  }

  /// SHOP scope: bookings starting in `[from, to)`, earliest first.
  /// Index: bookings (shopId, startAt).
  Stream<QuerySnapshot<JsonMap>> watchShopBookings(
    String shopId, {
    required DateTime from,
    required DateTime to,
  }) {
    return _bookings
        .where(BookingFields.shopId, isEqualTo: shopId)
        .where(
          BookingFields.startAt,
          isGreaterThanOrEqualTo: Timestamp.fromDate(from),
        )
        .where(BookingFields.startAt, isLessThan: Timestamp.fromDate(to))
        .orderBy(BookingFields.startAt)
        .snapshots();
  }
}

final bookingsCollectionProvider = Provider<BookingsCollection>(
  (ref) => BookingsCollection(ref.watch(firestoreProvider)),
);
