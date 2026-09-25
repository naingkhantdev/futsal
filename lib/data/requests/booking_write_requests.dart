import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/blocked_slot_fields.dart';
import '../../firebase/firestore/booking_fields.dart';
import '../../firebase/firestore/court_slot_fields.dart';
import '../../firebase/firestore/firestore_paths.dart';

/// Typed write DTOs for the booking / blocked-slot write paths. Built by
/// `BookingRequestBuilder` (pure) in the repository, serialized by the data
/// agent. `createdAt` / `updatedAt` are NOT here: the data layer stamps them
/// with the server time because firestore.rules require `== request.time`.

/// One slot lock doc (`stadiums/{sid}/courts/{cid}/slots/{slotId}`).
@immutable
class SlotLockRequest {
  const SlotLockRequest({
    required this.slotId,
    required this.shopId,
    required this.stadiumId,
    required this.courtId,
    required this.date,
    required this.startMinute,
    required this.endMinute,
    required this.kind,
    required this.refId,
    required this.createdBy,
  });

  final String slotId;
  final String shopId;
  final String stadiumId;
  final String courtId;
  final String date;
  final int startMinute;
  final int endMinute;
  final BusyKind kind;
  final String refId;
  final String createdBy;

  String get path => FirestorePaths.courtSlot(stadiumId, courtId, slotId);

  Map<String, Object?> toFirestore() => {
        CourtSlotFields.shopId: shopId,
        CourtSlotFields.stadiumId: stadiumId,
        CourtSlotFields.courtId: courtId,
        CourtSlotFields.date: date,
        CourtSlotFields.startMinute: startMinute,
        CourtSlotFields.endMinute: endMinute,
        CourtSlotFields.kind: kind.name,
        CourtSlotFields.refId: refId,
        CourtSlotFields.createdBy: createdBy,
      };

  @override
  bool operator ==(Object other) =>
      other is SlotLockRequest &&
      other.slotId == slotId &&
      other.shopId == shopId &&
      other.stadiumId == stadiumId &&
      other.courtId == courtId &&
      other.date == date &&
      other.startMinute == startMinute &&
      other.endMinute == endMinute &&
      other.kind == kind &&
      other.refId == refId &&
      other.createdBy == createdBy;

  @override
  int get hashCode => Object.hash(slotId, shopId, stadiumId, courtId, date,
      startMinute, endMinute, kind, refId, createdBy);
}

/// A new `bookings/{bookingId}` doc plus its slot lock docs.
@immutable
class BookingCreateRequest {
  const BookingCreateRequest({
    required this.bookingId,
    required this.shopId,
    required this.customerId,
    required this.stadiumId,
    required this.courtId,
    required this.bookingDate,
    required this.startMinute,
    required this.endMinute,
    required this.slotMinutes,
    required this.startAt,
    required this.endAt,
    required this.pricePerHour,
    required this.totalPrice,
    required this.currency,
    required this.customerNameSnapshot,
    required this.customerPhoneSnapshot,
    required this.stadiumNameSnapshot,
    required this.courtNameSnapshot,
    required this.slots,
  });

  final String bookingId;
  final String shopId;
  final String customerId;
  final String stadiumId;
  final String courtId;
  final String bookingDate;
  final int startMinute;
  final int endMinute;
  final int slotMinutes;

  /// UTC instants (Asia/Yangon local date + minutes).
  final DateTime startAt;
  final DateTime endAt;
  final int pricePerHour;
  final int totalPrice;
  final String currency;
  final String customerNameSnapshot;
  final String? customerPhoneSnapshot;
  final String stadiumNameSnapshot;
  final String courtNameSnapshot;
  final List<SlotLockRequest> slots;

  String get path => FirestorePaths.booking(bookingId);

  /// Every key the rules require (`bookingKeys()`) except the timestamps.
  /// [toTimestamp] converts the UTC instants to the SDK's Timestamp type
  /// (kept out of this file so it stays SDK-free and unit-testable).
  Map<String, Object?> toFirestore(Object Function(DateTime) toTimestamp) => {
        BookingFields.shopId: shopId,
        BookingFields.customerId: customerId,
        BookingFields.stadiumId: stadiumId,
        BookingFields.courtId: courtId,
        BookingFields.bookingDate: bookingDate,
        BookingFields.startMinute: startMinute,
        BookingFields.endMinute: endMinute,
        BookingFields.slotMinutes: slotMinutes,
        BookingFields.startAt: toTimestamp(startAt),
        BookingFields.endAt: toTimestamp(endAt),
        BookingFields.pricePerHour: pricePerHour,
        BookingFields.totalPrice: totalPrice,
        BookingFields.currency: currency,
        BookingFields.status: BookingStatus.pending.name,
        BookingFields.paymentStatus: PaymentStatus.unpaid.name,
        BookingFields.customerNameSnapshot: customerNameSnapshot,
        BookingFields.customerPhoneSnapshot: customerPhoneSnapshot,
        BookingFields.stadiumNameSnapshot: stadiumNameSnapshot,
        BookingFields.courtNameSnapshot: courtNameSnapshot,
      };
}

/// A new `blocked_slots/{blockedSlotId}` doc plus its slot lock docs.
@immutable
class BlockedSlotCreateRequest {
  const BlockedSlotCreateRequest({
    required this.blockedSlotId,
    required this.shopId,
    required this.stadiumId,
    required this.courtId,
    required this.date,
    required this.startMinute,
    required this.endMinute,
    required this.slotMinutes,
    required this.startAt,
    required this.endAt,
    required this.reason,
    required this.note,
    required this.createdBy,
    required this.slots,
  });

  final String blockedSlotId;
  final String shopId;
  final String stadiumId;
  final String courtId;
  final String date;
  final int startMinute;
  final int endMinute;
  final int slotMinutes;
  final DateTime startAt;
  final DateTime endAt;
  final BlockedSlotReason reason;
  final String? note;
  final String createdBy;
  final List<SlotLockRequest> slots;

  String get path => FirestorePaths.blockedSlot(blockedSlotId);

  Map<String, Object?> toFirestore(Object Function(DateTime) toTimestamp) => {
        BlockedSlotFields.shopId: shopId,
        BlockedSlotFields.stadiumId: stadiumId,
        BlockedSlotFields.courtId: courtId,
        BlockedSlotFields.date: date,
        BlockedSlotFields.startMinute: startMinute,
        BlockedSlotFields.endMinute: endMinute,
        BlockedSlotFields.slotMinutes: slotMinutes,
        BlockedSlotFields.startAt: toTimestamp(startAt),
        BlockedSlotFields.endAt: toTimestamp(endAt),
        BlockedSlotFields.reason: reason.name,
        BlockedSlotFields.note: note,
        BlockedSlotFields.createdBy: createdBy,
      };
}

/// A booking status / payment change plus the slot docs to delete in the
/// same request (cancel and reject free the time).
@immutable
class BookingUpdateRequest {
  const BookingUpdateRequest({
    required this.bookingId,
    this.status,
    this.paymentStatus,
    this.cancelReason,
    this.stampCancelledAt = false,
    this.slotPathsToDelete = const [],
  });

  final String bookingId;
  final BookingStatus? status;
  final PaymentStatus? paymentStatus;
  final String? cancelReason;

  /// Customer cancel: set `cancelledAt` to the server time.
  final bool stampCancelledAt;
  final List<String> slotPathsToDelete;

  String get path => FirestorePaths.booking(bookingId);

  /// Only the keys that change (the rules whitelist them per transition).
  Map<String, Object?> toFirestore() => {
        if (status != null) BookingFields.status: status!.name,
        if (paymentStatus != null)
          BookingFields.paymentStatus: paymentStatus!.name,
        if (cancelReason != null) BookingFields.cancelReason: cancelReason,
      };
}
