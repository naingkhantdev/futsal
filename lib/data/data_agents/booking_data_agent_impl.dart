import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/firestore/blocked_slots_collection.dart';
import '../../firebase/firestore/booking_fields.dart';
import '../../firebase/firestore/bookings_collection.dart';
import '../../firebase/firestore/firestore_instance.dart';
import '../../firebase/firestore/firestore_paths.dart';
import '../../firebase/firestore/slot_lock_writer.dart';
import '../requests/booking_write_requests.dart';
import '../responses/blocked_slot_response.dart';
import '../responses/booking_response.dart';
import 'booking_data_agent.dart';

class BookingDataAgentImpl implements BookingDataAgent {
  BookingDataAgentImpl({
    required BookingsCollection bookings,
    required BlockedSlotsCollection blockedSlots,
    required SlotLockWriter writer,
  })  : _bookings = bookings,
        _blocked = blockedSlots,
        _writer = writer;

  final BookingsCollection _bookings;
  final BlockedSlotsCollection _blocked;
  final SlotLockWriter _writer;

  static Object _timestamp(DateTime utc) => Timestamp.fromDate(utc);

  @override
  Stream<List<BookingResponse>> watchCustomerBookings(String customerId) {
    return _bookings.watchCustomerBookings(customerId).map(_toList);
  }

  @override
  Stream<List<BookingResponse>> watchShopBookings(
    String shopId, {
    required DateTime from,
    required DateTime to,
  }) {
    return _bookings
        .watchShopBookings(shopId, from: from, to: to)
        .map(_toList);
  }

  @override
  Future<BookingResponse?> getBooking(String bookingId) async {
    final snapshot = await _bookings.get(bookingId);
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;
    return BookingResponse.fromFirestore(snapshot.id, data);
  }

  @override
  String newBookingId() => _bookings.newId();

  @override
  Future<SlotWriteResult> createBooking(BookingCreateRequest request) async {
    final committed = await _writer.createWithSlots(
      parentPath: request.path,
      parentData: request.toFirestore(_timestamp),
      slots: {for (final s in request.slots) s.path: s.toFirestore()},
    );
    return committed ? SlotWriteResult.committed : SlotWriteResult.slotTaken;
  }

  @override
  Future<void> updateBooking(BookingUpdateRequest request) {
    return _writer.updateAndDeleteSlots(
      parentPath: request.path,
      fields: request.toFirestore(),
      serverTimeFields: {
        if (request.stampCancelledAt) BookingFields.cancelledAt,
      },
      slotPaths: request.slotPathsToDelete,
    );
  }

  @override
  Future<BlockedSlotResponse?> getBlockedSlot(String blockedSlotId) async {
    final snapshot = await _blocked.get(blockedSlotId);
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;
    return BlockedSlotResponse.fromFirestore(snapshot.id, data);
  }

  @override
  String newBlockedSlotId() => _blocked.newId();

  @override
  Future<SlotWriteResult> createBlockedSlot(
    BlockedSlotCreateRequest request,
  ) async {
    final committed = await _writer.createWithSlots(
      parentPath: request.path,
      parentData: request.toFirestore(_timestamp),
      slots: {for (final s in request.slots) s.path: s.toFirestore()},
    );
    return committed ? SlotWriteResult.committed : SlotWriteResult.slotTaken;
  }

  @override
  Future<void> deleteBlockedSlot({
    required String blockedSlotId,
    required List<String> slotPaths,
  }) {
    return _writer.deleteWithSlots(
      parentPath: FirestorePaths.blockedSlot(blockedSlotId),
      slotPaths: slotPaths,
    );
  }

  static List<BookingResponse> _toList(QuerySnapshot<JsonMap> query) => [
        for (final doc in query.docs)
          BookingResponse.fromFirestore(doc.id, doc.data()),
      ];
}

final bookingDataAgentProvider = Provider<BookingDataAgent>(
  (ref) => BookingDataAgentImpl(
    bookings: ref.watch(bookingsCollectionProvider),
    blockedSlots: ref.watch(blockedSlotsCollectionProvider),
    writer: ref.watch(slotLockWriterProvider),
  ),
);
