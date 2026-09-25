import '../../core/constants/booking_policy.dart';
import '../../core/constants/domain_enums.dart';
import '../../core/errors/app_exception.dart';
import '../../core/utils/date_key.dart';
import '../../core/utils/local_time.dart';
import '../../core/utils/money.dart';
import '../../core/utils/slot_key.dart';
import '../../core/utils/time_range.dart';
import '../../firebase/firestore/firestore_paths.dart';
import '../vos/booking_draft.dart';
import '../vos/booking_vo.dart';
import '../vos/blocked_slot_vo.dart';
import '../vos/court_vo.dart';
import '../vos/stadium_vo.dart';
import 'booking_write_requests.dart';

/// Pure construction of booking / blocked-slot write requests.
///
/// Mirrors the firestore.rules checks so a request built here is one the
/// rules accept, and so the user gets a precise error instead of a generic
/// permission-denied. The rules remain authoritative (they re-read the
/// court, stadium, shop and profile); nothing here is trusted server-side.
abstract final class BookingRequestBuilder {
  static const int _maxReasonLength = 500;

  /// CUSTOMER scope: the booking doc + one `booked` slot doc per slot.
  ///
  /// Throws an `AppException` when the draft cannot pass the rules.
  static BookingCreateRequest booking({
    required BookingDraft draft,
    required String bookingId,
    required String customerId,
    required String customerName,
    required String? customerPhone,
    required DateTime now,
  }) {
    final stadium = draft.stadium;
    final court = draft.court;
    _checkVenue(stadium, court);
    if (!stadium.isPublished) throw const ShopUnavailableException();
    if (!court.isActive) throw const CourtUnavailableException();
    final hourlyPrice = court.hourlyPrice;
    if (hourlyPrice == null) throw const CourtUnavailableException();

    // Same limits as validName() in firestore.rules. The rules compare the
    // snapshot with users/{uid}.name exactly, so it is copied untrimmed.
    if (customerName.trim().length < 2 || customerName.length > 80) {
      throw const ProfileIncompleteException();
    }

    final window = _window(
      stadium: stadium,
      court: court,
      date: draft.date,
      range: draft.range,
    );
    if (!window.startAt.isAfter(now)) {
      throw const InvalidBookingTimeException();
    }
    if (!window.startAt.isBefore(
      now.add(const Duration(days: BookingPolicy.maxAdvanceDays)),
    )) {
      throw const InvalidDateException();
    }

    final totalPrice = Money.totalPrice(
      hourlyPrice: hourlyPrice,
      minutes: draft.range.durationMinutes,
      slotMinutes: court.slotMinutes,
    );
    if (totalPrice == null) throw const InvalidBookingTimeException();

    return BookingCreateRequest(
      bookingId: bookingId,
      shopId: stadium.shopId,
      customerId: customerId,
      stadiumId: stadium.id,
      courtId: court.id,
      bookingDate: draft.date,
      startMinute: draft.startMinute,
      endMinute: draft.endMinute,
      slotMinutes: court.slotMinutes,
      startAt: window.startAt,
      endAt: window.endAt,
      pricePerHour: hourlyPrice,
      totalPrice: totalPrice,
      currency: BookingPolicy.currency,
      customerNameSnapshot: customerName,
      customerPhoneSnapshot: customerPhone,
      stadiumNameSnapshot: stadium.name,
      courtNameSnapshot: court.name,
      slots: _slots(
        shopId: stadium.shopId,
        stadiumId: stadium.id,
        courtId: court.id,
        date: draft.date,
        range: draft.range,
        slotMinutes: court.slotMinutes,
        kind: BusyKind.booked,
        refId: bookingId,
        createdBy: customerId,
      ),
    );
  }

  /// SHOP / PLATFORM scope: a blocked_slots doc + one `blocked` slot doc per
  /// slot (at most [BookingPolicy.maxSlotsPerBooking]; longer closures are
  /// several blocks).
  static BlockedSlotCreateRequest block({
    required StadiumVO stadium,
    required CourtVO court,
    required String date,
    required int startMinute,
    required int endMinute,
    required BlockedSlotReason reason,
    required String? note,
    required String blockedSlotId,
    required String adminUid,
  }) {
    _checkVenue(stadium, court);
    final range = TimeRange(startMinute, endMinute);
    final window =
        _window(stadium: stadium, court: court, date: date, range: range);
    final cleanNote = cleanReason(note);
    return BlockedSlotCreateRequest(
      blockedSlotId: blockedSlotId,
      shopId: stadium.shopId,
      stadiumId: stadium.id,
      courtId: court.id,
      date: date,
      startMinute: startMinute,
      endMinute: endMinute,
      slotMinutes: court.slotMinutes,
      startAt: window.startAt,
      endAt: window.endAt,
      reason: reason,
      note: cleanNote,
      createdBy: adminUid,
      slots: _slots(
        shopId: stadium.shopId,
        stadiumId: stadium.id,
        courtId: court.id,
        date: date,
        range: range,
        slotMinutes: court.slotMinutes,
        kind: BusyKind.blocked,
        refId: blockedSlotId,
        createdBy: adminUid,
      ),
    );
  }

  /// Paths of the slot docs a booking holds (deleted on cancel / reject).
  static List<String> bookingSlotPaths(BookingVO booking) => [
        for (final id in SlotKey.idsFor(
          dateKey: booking.bookingDate,
          startMinute: booking.startMinute,
          endMinute: booking.endMinute,
          slotMinutes: booking.slotMinutes,
        ))
          _slotPath(booking.stadiumId, booking.courtId, id),
      ];

  /// Paths of the slot docs a block holds (deleted with it).
  static List<String> blockSlotPaths(BlockedSlotVO block) => [
        for (final id in SlotKey.idsFor(
          dateKey: block.date,
          startMinute: block.startMinute,
          endMinute: block.endMinute,
          slotMinutes: block.slotMinutes,
        ))
          _slotPath(block.stadiumId, block.courtId, id),
      ];

  /// Optional reason for cancel / reject: trimmed, empty -> null, capped at
  /// the rules' 500 characters.
  static String? cleanReason(String? reason) {
    final trimmed = reason?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed.length > _maxReasonLength
        ? trimmed.substring(0, _maxReasonLength)
        : trimmed;
  }

  // --- internals ------------------------------------------------------------

  static void _checkVenue(StadiumVO stadium, CourtVO court) {
    if (court.stadiumId != stadium.id || court.shopId != stadium.shopId) {
      throw const CourtUnavailableException();
    }
    if (!stadium.isActive ||
        stadium.timeZone != BookingPolicy.defaultTimeZone) {
      throw const StadiumUnavailableException();
    }
  }

  static ({DateTime startAt, DateTime endAt}) _window({
    required StadiumVO stadium,
    required CourtVO court,
    required String date,
    required TimeRange range,
  }) {
    if (!DateKey.isValid(date)) throw const InvalidDateException();
    final bookable = SlotRules.isBookableWindow(
      range,
      openMinute: stadium.openMinute,
      closeMinute: stadium.closeMinute,
      slotMinutes: court.slotMinutes,
    );
    if (!bookable) throw const InvalidBookingTimeException();
    if (range.durationMinutes >
        BookingPolicy.maxSlotsPerBooking * court.slotMinutes) {
      throw const BookingTooLongException();
    }
    final startAt = LocalTime.instantFor(date, range.startMinute);
    final endAt = LocalTime.instantFor(date, range.endMinute);
    if (startAt == null || endAt == null) throw const InvalidDateException();
    return (startAt: startAt, endAt: endAt);
  }

  static List<SlotLockRequest> _slots({
    required String shopId,
    required String stadiumId,
    required String courtId,
    required String date,
    required TimeRange range,
    required int slotMinutes,
    required BusyKind kind,
    required String refId,
    required String createdBy,
  }) =>
      [
        for (final start in SlotKey.startMinutes(
          startMinute: range.startMinute,
          endMinute: range.endMinute,
          slotMinutes: slotMinutes,
        ))
          SlotLockRequest(
            slotId: SlotKey.of(date, start),
            shopId: shopId,
            stadiumId: stadiumId,
            courtId: courtId,
            date: date,
            startMinute: start,
            endMinute: start + slotMinutes,
            kind: kind,
            refId: refId,
            createdBy: createdBy,
          ),
      ];

  static String _slotPath(String stadiumId, String courtId, String slotId) =>
      FirestorePaths.courtSlot(stadiumId, courtId, slotId);
}
