import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_instance.dart';
import 'firestore_paths.dart';
import 'notification_fields.dart';

/// Access to `notifications`. Raw maps stay below the data agent; errors
/// propagate raw.
///
/// Rules: a customer reads docs with `audience == 'customer'` and
/// `recipientId == uid`; a shop admin reads `audience == 'shop'` and
/// `recipientId == users/{uid}.shopId`. List queries must carry both
/// filters (rules are not filters).
class NotificationsCollection {
  NotificationsCollection(this._firestore);

  final FirebaseFirestore _firestore;

  /// Newest page; older notifications are not shown.
  static const int defaultLimit = 50;

  /// Newest first. Index: notifications (audience, recipientId,
  /// createdAt desc).
  Stream<QuerySnapshot<JsonMap>> watchInbox({
    required String audience,
    required String recipientId,
    int limit = defaultLimit,
  }) {
    return _firestore
        .collection(FirestoreCollections.notifications)
        .where(NotificationFields.audience, isEqualTo: audience)
        .where(NotificationFields.recipientId, isEqualTo: recipientId)
        .orderBy(NotificationFields.createdAt, descending: true)
        .limit(limit)
        .snapshots();
  }

  /// Creates the doc; `createdAt` is the server time (rules require
  /// `== request.time`). Fails if it already exists (create-only).
  Future<void> create(String notificationId, JsonMap fields) =>
      _firestore.doc(FirestorePaths.notification(notificationId)).set({
        ...fields,
        NotificationFields.createdAt: FieldValue.serverTimestamp(),
      });

  /// Marks every doc in [notificationIds] read in one batch.
  Future<void> markRead(Iterable<String> notificationIds) {
    final batch = _firestore.batch();
    for (final id in notificationIds) {
      batch.update(_firestore.doc(FirestorePaths.notification(id)), {
        NotificationFields.isRead: true,
        NotificationFields.readAt: FieldValue.serverTimestamp(),
      });
    }
    return batch.commit();
  }
}

final notificationsCollectionProvider = Provider<NotificationsCollection>(
  (ref) => NotificationsCollection(ref.watch(firestoreProvider)),
);
