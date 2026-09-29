import '../../core/constants/domain_enums.dart';
import '../../core/utils/date_key.dart';
import '../../core/utils/local_time.dart';
import '../../core/utils/money.dart';
import '../vos/blocked_slot_vo.dart';
import '../vos/booking_vo.dart';
import '../vos/court_vo.dart';
import '../vos/shop_vo.dart';
import '../vos/stadium_vo.dart';
import '../vos/user_vo.dart';

/// SAMPLE DATA for screens that are not wired to Firestore yet.
///
/// Built from the real VOs so each screen only swaps its source (this file →
/// a repository provider) when its phase lands. Nothing here is written
/// anywhere; screens using it show `DemoDataBanner`. Dates are relative to
/// today so the previews always look current.
abstract final class DemoData {
  /// The signed-in customer in customer previews.
  static const String meId = 'demo-customer-1';

  /// The shop a shop admin manages in shop-admin previews.
  static const String myShopId = 'demo-shop-1';

  // ---------------------------------------------------------------- shops

  static final List<ShopVO> shops = [
    ShopVO(
      id: myShopId,
      name: 'Golden Goal Futsal',
      description: 'Three floodlit courts in Hlaing and Thingangyun, open '
          'from 6 AM to 11 PM every day.',
      phone: '09 420 111 222',
      email: 'hello@goldengoal.mm',
      address: 'No. 12, Parami Road',
      township: 'Hlaing',
      city: 'Yangon',
      status: ShopStatus.active,
      isListed: true,
      approvedAt: _daysAgo(120),
      createdAt: _daysAgo(130),
    ),
    ShopVO(
      id: 'demo-shop-2',
      name: 'Kick Off Arena',
      description: 'Indoor and outdoor pitches near Kandawgyi Lake.',
      phone: '09 250 333 444',
      email: 'booking@kickoff.mm',
      address: 'No. 45, Bahan 3rd Street',
      township: 'Bahan',
      city: 'Yangon',
      status: ShopStatus.active,
      isListed: true,
      approvedAt: _daysAgo(60),
      createdAt: _daysAgo(64),
    ),
    ShopVO(
      id: 'demo-shop-3',
      name: 'Night Owl Futsal',
      description: 'Late-night games until 1 AM.',
      phone: '09 790 555 666',
      township: 'Chanayethazan',
      city: 'Mandalay',
      status: ShopStatus.pending,
      isListed: false,
      createdAt: _daysAgo(2),
    ),
    ShopVO(
      id: 'demo-shop-4',
      name: 'Downtown Five',
      phone: '09 311 777 888',
      township: 'Kyauktada',
      city: 'Yangon',
      status: ShopStatus.suspended,
      isListed: false,
      approvedAt: _daysAgo(200),
      createdAt: _daysAgo(210),
    ),
  ];

  // ------------------------------------------------------------- stadiums

  // Venue photos: Unsplash (free to use under the Unsplash License, no
  // attribution required). Sample data only; real venues upload their own
  // photos to Storage.
  static const String _unsplash = 'https://images.unsplash.com';
  static const String _photoQuery = '?w=1200&q=75&auto=format&fit=crop';
  static const String _photoFloodlit =
      '$_unsplash/photo-1431324155629-1a6deb1dec8d$_photoQuery';
  static const String _photoCage =
      '$_unsplash/photo-1606925797300-0b35e9d1794e$_photoQuery';
  static const String _photoTurf =
      '$_unsplash/photo-1529900748604-07564a03e7a6$_photoQuery';
  static const String _photoBall =
      '$_unsplash/photo-1589487391730-58f20eb2c308$_photoQuery';

  static const List<StadiumVO> stadiums = [
    StadiumVO(
      id: 'demo-stadium-1',
      shopId: myShopId,
      name: 'Golden Goal Hlaing',
      description: 'Our flagship venue: two outdoor turf courts and one '
          'covered court, with showers and a small cafe.',
      address: 'No. 12, Parami Road',
      township: 'Hlaing',
      city: 'Yangon',
      // Approximate township centre (sample data).
      latitude: 16.853,
      longitude: 96.1266,
      facilities: [
        Facility.floodLights,
        Facility.parking,
        Facility.shower,
        Facility.changingRoom,
        Facility.cafe,
      ],
      openMinute: 6 * 60,
      closeMinute: 23 * 60,
      timeZone: 'Asia/Yangon',
      isActive: true,
      isPublished: true,
      minHourlyPrice: 30000,
      images: [_photoFloodlit],
    ),
    StadiumVO(
      id: 'demo-stadium-2',
      shopId: myShopId,
      name: 'Golden Goal Thingangyun',
      description: 'A quiet neighbourhood court, great for weekday games.',
      address: 'No. 8, Thanthumar Road',
      township: 'Thingangyun',
      city: 'Yangon',
      // Approximate township centre (sample data).
      latitude: 16.829,
      longitude: 96.193,
      facilities: [
        Facility.floodLights,
        Facility.drinkingWater,
        Facility.restroom,
      ],
      openMinute: 7 * 60,
      closeMinute: 22 * 60,
      timeZone: 'Asia/Yangon',
      isActive: true,
      isPublished: true,
      minHourlyPrice: 25000,
      images: [_photoCage],
    ),
    StadiumVO(
      id: 'demo-stadium-3',
      shopId: 'demo-shop-2',
      name: 'Kick Off Arena Bahan',
      description: 'Indoor court with air conditioning plus an outdoor pitch.',
      address: 'No. 45, Bahan 3rd Street',
      township: 'Bahan',
      city: 'Yangon',
      // Approximate township centre (sample data).
      latitude: 16.801,
      longitude: 96.158,
      facilities: [
        Facility.parking,
        Facility.shower,
        Facility.seating,
        Facility.equipmentRental,
      ],
      openMinute: 6 * 60,
      closeMinute: 24 * 60,
      timeZone: 'Asia/Yangon',
      isActive: true,
      isPublished: true,
      minHourlyPrice: 35000,
      images: [_photoTurf],
    ),
    StadiumVO(
      id: 'demo-stadium-4',
      shopId: 'demo-shop-2',
      name: 'Kick Off Mini Pitch',
      description: 'Small-sided court for 4 v 4. Half-hour slots.',
      address: 'No. 3, Hledan Road',
      township: 'Kamayut',
      city: 'Yangon',
      facilities: [Facility.drinkingWater, Facility.restroom],
      openMinute: 8 * 60,
      closeMinute: 22 * 60,
      timeZone: 'Asia/Yangon',
      isActive: true,
      isPublished: true,
      minHourlyPrice: 20000,
      images: [_photoBall],
    ),
  ];

  // --------------------------------------------------------------- courts

  static const List<CourtVO> courts = [
    CourtVO(
      id: 'demo-court-1',
      shopId: myShopId,
      stadiumId: 'demo-stadium-1',
      name: 'Court A',
      surfaceType: 'Artificial turf',
      capacity: 10,
      hourlyPrice: 30000,
      currency: 'MMK',
      slotMinutes: 60,
      isActive: true,
    ),
    CourtVO(
      id: 'demo-court-2',
      shopId: myShopId,
      stadiumId: 'demo-stadium-1',
      name: 'Court B',
      surfaceType: 'Artificial turf',
      capacity: 10,
      hourlyPrice: 30000,
      currency: 'MMK',
      slotMinutes: 60,
      isActive: true,
    ),
    CourtVO(
      id: 'demo-court-3',
      shopId: myShopId,
      stadiumId: 'demo-stadium-1',
      name: 'Covered Court',
      surfaceType: 'Rubber',
      capacity: 12,
      hourlyPrice: 40000,
      currency: 'MMK',
      slotMinutes: 60,
      isActive: true,
    ),
    CourtVO(
      id: 'demo-court-4',
      shopId: myShopId,
      stadiumId: 'demo-stadium-2',
      name: 'Court 1',
      surfaceType: 'Artificial turf',
      capacity: 10,
      hourlyPrice: 25000,
      currency: 'MMK',
      slotMinutes: 60,
      isActive: true,
    ),
    CourtVO(
      id: 'demo-court-5',
      shopId: 'demo-shop-2',
      stadiumId: 'demo-stadium-3',
      name: 'Indoor Court',
      surfaceType: 'Wooden',
      capacity: 10,
      hourlyPrice: 45000,
      currency: 'MMK',
      slotMinutes: 60,
      isActive: true,
    ),
    CourtVO(
      id: 'demo-court-6',
      shopId: 'demo-shop-2',
      stadiumId: 'demo-stadium-3',
      name: 'Outdoor Pitch',
      surfaceType: 'Artificial turf',
      capacity: 12,
      hourlyPrice: 35000,
      currency: 'MMK',
      slotMinutes: 60,
      isActive: true,
    ),
    CourtVO(
      id: 'demo-court-7',
      shopId: 'demo-shop-2',
      stadiumId: 'demo-stadium-4',
      name: 'Mini Court',
      surfaceType: 'Artificial turf',
      capacity: 8,
      hourlyPrice: 20000,
      currency: 'MMK',
      slotMinutes: 30,
      isActive: true,
    ),
  ];

  // ------------------------------------------------------------ customers

  static final List<UserVO> customers = [
    UserVO(
      id: meId,
      name: 'Aung Kyaw',
      email: 'aungkyaw@example.com',
      phone: '09 450 123 456',
      role: UserRole.customer,
      isActive: true,
      createdAt: _daysAgo(90),
    ),
    UserVO(
      id: 'demo-customer-2',
      name: 'Thandar Hlaing',
      email: 'thandar@example.com',
      phone: '09 777 234 567',
      role: UserRole.customer,
      isActive: true,
      createdAt: _daysAgo(75),
    ),
    UserVO(
      id: 'demo-customer-3',
      name: 'Min Thu',
      email: 'minthu@example.com',
      phone: '09 263 345 678',
      role: UserRole.customer,
      isActive: true,
      createdAt: _daysAgo(40),
    ),
    UserVO(
      id: 'demo-customer-4',
      name: 'Zaw Lin Htet',
      email: 'zawlin@example.com',
      phone: '09 512 456 789',
      role: UserRole.customer,
      isActive: true,
      createdAt: _daysAgo(30),
    ),
    UserVO(
      id: 'demo-customer-5',
      name: 'Hnin Wai',
      email: 'hninwai@example.com',
      role: UserRole.customer,
      isActive: true,
      createdAt: _daysAgo(12),
    ),
    UserVO(
      id: 'demo-customer-6',
      name: 'Kyaw Zin Oo',
      email: 'kyawzin@example.com',
      phone: '09 698 567 890',
      role: UserRole.customer,
      isActive: false,
      createdAt: _daysAgo(150),
    ),
  ];

  // ------------------------------------------------------------- bookings

  static final List<BookingVO> bookings = [
    // Today
    _booking('b01', 'demo-customer-2', 'demo-court-1', 0, 17, 2,
        BookingStatus.confirmed, PaymentStatus.paid),
    _booking('b02', 'demo-customer-3', 'demo-court-2', 0, 19, 1,
        BookingStatus.pending, PaymentStatus.unpaid),
    _booking('b03', meId, 'demo-court-3', 0, 20, 1, BookingStatus.confirmed,
        PaymentStatus.pending),
    // Coming days
    _booking('b04', 'demo-customer-4', 'demo-court-1', 1, 18, 2,
        BookingStatus.pending, PaymentStatus.unpaid),
    _booking('b05', meId, 'demo-court-4', 2, 19, 1, BookingStatus.pending,
        PaymentStatus.unpaid),
    _booking('b06', 'demo-customer-5', 'demo-court-2', 2, 7, 1,
        BookingStatus.confirmed, PaymentStatus.paid),
    _booking('b07', 'demo-customer-2', 'demo-court-5', 3, 20, 2,
        BookingStatus.confirmed, PaymentStatus.pending),
    _booking('b08', meId, 'demo-court-6', 5, 17, 2, BookingStatus.confirmed,
        PaymentStatus.paid),
    _booking('b09', 'demo-customer-3', 'demo-court-4', 6, 18, 1,
        BookingStatus.pending, PaymentStatus.unpaid),
    // Past
    _booking('b10', meId, 'demo-court-1', -2, 18, 2, BookingStatus.completed,
        PaymentStatus.paid),
    _booking('b11', 'demo-customer-4', 'demo-court-3', -1, 20, 1,
        BookingStatus.completed, PaymentStatus.paid),
    _booking('b12', meId, 'demo-court-7', -4, 9, 1, BookingStatus.cancelled,
        PaymentStatus.unpaid,
        cancelReason: 'Team could not make it'),
    _booking('b13', 'demo-customer-5', 'demo-court-1', -3, 16, 1,
        BookingStatus.rejected, PaymentStatus.unpaid,
        cancelReason: 'Court under maintenance'),
    _booking('b14', 'demo-customer-2', 'demo-court-2', -6, 19, 2,
        BookingStatus.completed, PaymentStatus.paid),
    _booking('b15', 'demo-customer-6', 'demo-court-5', -8, 18, 1,
        BookingStatus.completed, PaymentStatus.refunded),
  ];

  // -------------------------------------------------------- blocked slots

  static final List<BlockedSlotVO> blockedSlots = [
    _blocked('k1', 'demo-court-2', 1, 6 * 60, 8 * 60,
        BlockedSlotReason.maintenance, 'Turf brushing'),
    _blocked('k2', 'demo-court-1', 3, 18 * 60, 22 * 60,
        BlockedSlotReason.tournament, 'Company league night'),
    _blocked('k3', 'demo-court-4', 4, 7 * 60, 9 * 60,
        BlockedSlotReason.cleaning, null),
  ];

  // -------------------------------------------------------- notifications

  static final List<DemoNotification> notifications = [
    DemoNotification(
      title: 'Booking confirmed',
      body: 'Covered Court, today at 20:00 is confirmed. See you there!',
      kind: DemoNotificationKind.booking,
      at: _hoursAgo(1),
      isRead: false,
    ),
    DemoNotification(
      title: 'Reminder: game tomorrow',
      body: 'Outdoor Pitch at Kick Off Arena Bahan, 17:00 – 19:00.',
      kind: DemoNotificationKind.reminder,
      at: _hoursAgo(5),
      isRead: false,
    ),
    DemoNotification(
      title: 'Booking request sent',
      body: 'Golden Goal Thingangyun will confirm your 19:00 booking soon.',
      kind: DemoNotificationKind.booking,
      at: _hoursAgo(26),
      isRead: true,
    ),
    DemoNotification(
      title: 'New venue near you',
      body: 'Kick Off Mini Pitch just opened in Kamayut. Half-hour slots '
          'from MMK 20,000/hr.',
      kind: DemoNotificationKind.announcement,
      at: _hoursAgo(72),
      isRead: true,
    ),
    DemoNotification(
      title: 'Booking cancelled',
      body: 'Your Mini Court booking was cancelled.',
      kind: DemoNotificationKind.cancelled,
      at: _hoursAgo(96),
      isRead: true,
    ),
  ];

  // -------------------------------------------------------- announcements

  static final List<DemoAnnouncement> announcements = [
    DemoAnnouncement(
      title: 'Thingyan holiday hours',
      body: 'Venues may close early during the water festival. Check each '
          'stadium page before booking.',
      audience: DemoAudience.everyone,
      sentAt: _daysAgo(1),
    ),
    DemoAnnouncement(
      title: 'Confirm bookings within 2 hours',
      body: 'Customers are more likely to return when requests are confirmed '
          'quickly. Pending requests now show on your dashboard.',
      audience: DemoAudience.shopAdmins,
      sentAt: _daysAgo(6),
    ),
    DemoAnnouncement(
      title: 'Welcome to Futsal Booking',
      body: 'Find a court, pick your time and book in seconds.',
      audience: DemoAudience.customers,
      sentAt: _daysAgo(30),
    ),
  ];

  /// Sample records never reach Firestore: actions on them are preview-only.
  static bool isDemoId(String id) => id.startsWith('demo-');

  // --------------------------------------------------------------- lookups

  static ShopVO shop(String id) =>
      shops.firstWhere((s) => s.id == id, orElse: () => shops.first);

  static StadiumVO stadium(String id) =>
      stadiums.firstWhere((s) => s.id == id, orElse: () => stadiums.first);

  static CourtVO court(String id) =>
      courts.firstWhere((c) => c.id == id, orElse: () => courts.first);

  static List<CourtVO> courtsOf(String stadiumId) =>
      courts.where((c) => c.stadiumId == stadiumId).toList();

  static List<StadiumVO> stadiumsOf(String shopId) =>
      stadiums.where((s) => s.shopId == shopId).toList();

  static UserVO customer(String id) =>
      customers.firstWhere((c) => c.id == id, orElse: () => customers.first);

  static BookingVO booking(String id) =>
      bookings.firstWhere((b) => b.id == id, orElse: () => bookings.first);

  /// Newest first.
  static List<BookingVO> bookingsOfCustomer(String customerId) =>
      _sorted(bookings.where((b) => b.customerId == customerId));

  static List<BookingVO> bookingsOfShop(String shopId) =>
      _sorted(bookings.where((b) => b.shopId == shopId));

  static List<BookingVO> allBookings() => _sorted(bookings);

  /// Soonest first.
  static List<BookingVO> upcoming(Iterable<BookingVO> list) {
    final now = DateTime.now();
    return list.where((b) => b.isUpcoming(now)).toList()
      ..sort((a, b) => a.startAt!.compareTo(b.startAt!));
  }

  /// Customers who booked at [shopId] (all customers when null).
  static List<UserVO> customersOf(String? shopId) {
    if (shopId == null) return customers;
    final ids = bookings
        .where((b) => b.shopId == shopId)
        .map((b) => b.customerId)
        .toSet();
    return customers.where((c) => ids.contains(c.id)).toList();
  }

  /// Booking count and money spent (completed + confirmed, paid) of a
  /// customer, optionally at one shop.
  static ({int bookings, int spent, DateTime? lastPlayed}) customerStats(
    String customerId, {
    String? shopId,
  }) {
    final list = bookings.where(
      (b) => b.customerId == customerId && (shopId == null || b.shopId == shopId),
    );
    final spent = list
        .where((b) => b.paymentStatus == PaymentStatus.paid)
        .fold<int>(0, (sum, b) => sum + b.totalPrice);
    final past = list.where((b) => b.status == BookingStatus.completed);
    DateTime? last;
    for (final b in past) {
      if (last == null || b.startAt!.isAfter(last)) last = b.startAt;
    }
    return (bookings: list.length, spent: spent, lastPlayed: last);
  }

  /// Slot state of [court] on [date] at [startMinute] for the slot grid.
  static bool isBusy(String courtId, String date, int startMinute, int end) =>
      bookings.any((b) =>
          b.courtId == courtId &&
          b.bookingDate == date &&
          b.blocksAvailability &&
          b.startMinute < end &&
          b.endMinute > startMinute);

  static bool isBlocked(String courtId, String date, int startMinute, int end) =>
      blockedSlots.any((k) =>
          k.courtId == courtId &&
          k.date == date &&
          k.startMinute < end &&
          k.endMinute > startMinute);

  /// PREVIEW availability for quick booking: the earliest [limit] start
  /// times on [date] with a free, bookable slot on some court of
  /// [stadiumId] (slots that already started today are skipped). One entry
  /// per start time, on the first court that is free then. Display only:
  /// the booking itself is still validated by the rules.
  static List<({CourtVO court, int startMinute})> openStarts(
    String stadiumId,
    String date, {
    int limit = 3,
  }) {
    final s = stadium(stadiumId);
    final now = DateTime.now();
    final nowMinute =
        date == DateKey.fromDate(now) ? now.hour * 60 + now.minute : -1;
    final byStart = <int, CourtVO>{};
    for (final c in courtsOf(stadiumId).where((c) => c.hasPrice)) {
      final slots =
          c.slots(openMinute: s.openMinute, closeMinute: s.closeMinute);
      for (final slot in slots) {
        if (slot.startMinute <= nowMinute) continue;
        if (isBusy(c.id, date, slot.startMinute, slot.endMinute) ||
            isBlocked(c.id, date, slot.startMinute, slot.endMinute)) {
          continue;
        }
        byStart.putIfAbsent(slot.startMinute, () => c);
      }
    }
    final starts = byStart.keys.toList()..sort();
    return [
      for (final m in starts.take(limit)) (court: byStart[m]!, startMinute: m),
    ];
  }

  // --------------------------------------------------------------- helpers

  static List<BookingVO> _sorted(Iterable<BookingVO> list) =>
      list.toList()..sort((a, b) => b.startAt!.compareTo(a.startAt!));

  static DateTime _daysAgo(int days) =>
      DateTime.now().subtract(Duration(days: days));

  static DateTime _hoursAgo(int hours) =>
      DateTime.now().subtract(Duration(hours: hours));

  static String _dateKey(int dayOffset) =>
      DateKey.fromDate(DateTime.now().add(Duration(days: dayOffset)));

  static BookingVO _booking(
    String id,
    String customerId,
    String courtId,
    int dayOffset,
    int startHour,
    int hours,
    BookingStatus status,
    PaymentStatus payment, {
    String? cancelReason,
  }) {
    final c = court(courtId);
    final s = stadium(c.stadiumId);
    final date = _dateKey(dayOffset);
    final start = startHour * 60;
    final end = start + hours * 60;
    final cancelled =
        status == BookingStatus.cancelled || status == BookingStatus.rejected;
    return BookingVO(
      id: 'demo-booking-$id',
      shopId: c.shopId,
      customerId: customerId,
      stadiumId: s.id,
      courtId: c.id,
      bookingDate: date,
      startMinute: start,
      endMinute: end,
      slotMinutes: c.slotMinutes,
      startAt: LocalTime.instantFor(date, start),
      endAt: LocalTime.instantFor(date, end),
      pricePerHour: c.hourlyPrice!,
      totalPrice: Money.totalPrice(
        hourlyPrice: c.hourlyPrice!,
        minutes: end - start,
        slotMinutes: c.slotMinutes,
      )!,
      currency: c.currency,
      status: status,
      paymentStatus: payment,
      customerNameSnapshot: customer(customerId).name,
      customerPhoneSnapshot: customer(customerId).phone,
      stadiumNameSnapshot: s.name,
      courtNameSnapshot: c.name,
      cancelReason: cancelReason,
      cancelledAt: cancelled ? LocalTime.instantFor(date, start - 180) : null,
      createdAt: LocalTime.instantFor(_dateKey(dayOffset - 2), 10 * 60),
    );
  }

  static BlockedSlotVO _blocked(
    String id,
    String courtId,
    int dayOffset,
    int start,
    int end,
    BlockedSlotReason reason,
    String? note,
  ) {
    final c = court(courtId);
    final date = _dateKey(dayOffset);
    return BlockedSlotVO(
      id: 'demo-blocked-$id',
      shopId: c.shopId,
      stadiumId: c.stadiumId,
      courtId: c.id,
      date: date,
      startMinute: start,
      endMinute: end,
      slotMinutes: c.slotMinutes,
      startAt: LocalTime.instantFor(date, start),
      endAt: LocalTime.instantFor(date, end),
      reason: reason,
      note: note,
    );
  }
}

enum DemoNotificationKind { booking, reminder, cancelled, announcement }

/// Customer notification (no VO yet: notifications arrive in Phase 12).
class DemoNotification {
  const DemoNotification({
    required this.title,
    required this.body,
    required this.kind,
    required this.at,
    required this.isRead,
  });

  final String title;
  final String body;
  final DemoNotificationKind kind;
  final DateTime at;
  final bool isRead;
}

enum DemoAudience {
  everyone('Everyone'),
  customers('Customers'),
  shopAdmins('Shop admins');

  const DemoAudience(this.label);
  final String label;
}

/// Platform announcement (no VO yet).
class DemoAnnouncement {
  const DemoAnnouncement({
    required this.title,
    required this.body,
    required this.audience,
    required this.sentAt,
  });

  final String title;
  final String body;
  final DemoAudience audience;
  final DateTime sentAt;
}
