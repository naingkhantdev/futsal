import 'package:flutter/foundation.dart';

import '../../core/constants/booking_policy.dart';
import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/booking_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `bookings/{bookingId}` (client-written, validated by
/// firestore.rules).
///
/// Unknown enum strings never elevate: an unknown `status` reads as
/// [BookingStatus.pending] (not confirmed, still treated as occupying the
/// time) and an unknown `paymentStatus` as [PaymentStatus.unpaid].
/// Missing minutes read as `0`/`0` (an invalid, empty range); a missing or
/// invalid `slotMinutes` reads as the default (60).
@immutable
class BookingResponse {
  const BookingResponse({
    required this.id,
    required this.shopId,
    required this.customerId,
    required this.stadiumId,
    required this.courtId,
    required this.bookingDate,
    required this.startMinute,
    required this.endMinute,
    required this.pricePerHour,
    required this.totalPrice,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    required this.customerNameSnapshot,
    required this.stadiumNameSnapshot,
    required this.courtNameSnapshot,
    this.freeCancelHours,
    this.slotMinutes = BookingPolicy.defaultSlotMinutes,
    this.customerPhoneSnapshot,
    this.startAt,
    this.endAt,
    this.cancelledAt,
    this.cancelReason,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingResponse.fromFirestore(String id, Map<String, dynamic> data) {
    String str(String key) => FirestoreRead.string(data[key]) ?? '';
    int amount(String key) {
      final n = FirestoreRead.integer(data[key]);
      return n != null && n >= 0 ? n : 0;
    }

    final slot = FirestoreRead.integer(data[BookingFields.slotMinutes]);
    return BookingResponse(
      id: id,
      shopId: str(BookingFields.shopId),
      customerId: str(BookingFields.customerId),
      stadiumId: str(BookingFields.stadiumId),
      courtId: str(BookingFields.courtId),
      bookingDate: str(BookingFields.bookingDate),
      startMinute: FirestoreRead.integer(data[BookingFields.startMinute]) ?? 0,
      endMinute: FirestoreRead.integer(data[BookingFields.endMinute]) ?? 0,
      slotMinutes:
          slot != null && slot > 0 && slot <= BookingPolicy.minutesPerDay
              ? slot
              : BookingPolicy.defaultSlotMinutes,
      startAt: FirestoreRead.date(data[BookingFields.startAt]),
      endAt: FirestoreRead.date(data[BookingFields.endAt]),
      pricePerHour: amount(BookingFields.pricePerHour),
      totalPrice: amount(BookingFields.totalPrice),
      currency: FirestoreRead.string(data[BookingFields.currency]) ??
          BookingPolicy.currency,
      status: BookingStatus.tryParse(
            FirestoreRead.string(data[BookingFields.status]),
          ) ??
          BookingStatus.pending,
      paymentStatus: PaymentStatus.tryParse(
            FirestoreRead.string(data[BookingFields.paymentStatus]),
          ) ??
          PaymentStatus.unpaid,
      customerNameSnapshot: str(BookingFields.customerNameSnapshot),
      customerPhoneSnapshot:
          FirestoreRead.string(data[BookingFields.customerPhoneSnapshot]),
      stadiumNameSnapshot: str(BookingFields.stadiumNameSnapshot),
      courtNameSnapshot: str(BookingFields.courtNameSnapshot),
      freeCancelHours:
          FirestoreRead.integer(data[BookingFields.freeCancelHours]),
      cancelledAt: FirestoreRead.date(data[BookingFields.cancelledAt]),
      cancelReason: FirestoreRead.string(data[BookingFields.cancelReason]),
      createdAt: FirestoreRead.date(data[BookingFields.createdAt]),
      updatedAt: FirestoreRead.date(data[BookingFields.updatedAt]),
    );
  }

  final String id;
  final String shopId;
  final String customerId;
  final String stadiumId;
  final String courtId;

  /// `yyyy-MM-dd`, stadium local time.
  final String bookingDate;
  final int startMinute;
  final int endMinute;

  /// Court slot length at booking time; locates the booking's slot docs.
  final int slotMinutes;
  final DateTime? startAt;
  final DateTime? endAt;

  /// Int MMK.
  final int pricePerHour;
  final int totalPrice;
  final String currency;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String customerNameSnapshot;
  final String? customerPhoneSnapshot;
  final String stadiumNameSnapshot;
  final String courtNameSnapshot;

  /// Policy snapshot (`CancellationPolicy`); `null` = none stated.
  final int? freeCancelHours;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
