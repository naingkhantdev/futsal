import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/errors/app_exception.dart';
import 'package:futsal_booking/data/data_agents/auth_data_agent.dart';
import 'package:futsal_booking/data/data_agents/court_data_agent.dart';
import 'package:futsal_booking/data/data_agents/shop_data_agent.dart';
import 'package:futsal_booking/data/data_agents/stadium_data_agent.dart';
import 'package:futsal_booking/data/repositories/court_repository_impl.dart';
import 'package:futsal_booking/data/repositories/shop_repository_impl.dart';
import 'package:futsal_booking/data/repositories/stadium_repository_impl.dart';
import 'package:futsal_booking/data/requests/venue_write_requests.dart';
import 'package:futsal_booking/data/responses/auth_user_response.dart';
import 'package:futsal_booking/data/responses/court_response.dart';
import 'package:futsal_booking/data/responses/shop_response.dart';
import 'package:futsal_booking/data/responses/stadium_response.dart';
import 'package:futsal_booking/firebase/firestore/shop_fields.dart';
import 'package:futsal_booking/firebase/firestore/stadium_fields.dart';
import 'package:mocktail/mocktail.dart';

class _MockShops extends Mock implements ShopDataAgent {}

class _MockStadiums extends Mock implements StadiumDataAgent {}

class _MockCourts extends Mock implements CourtDataAgent {}

class _MockAuth extends Mock implements AuthDataAgent {}

ShopResponse _shop({
  ShopStatus status = ShopStatus.active,
  bool isListed = true,
  DateTime? approvedAt,
}) =>
    ShopResponse(
      id: 'shopA',
      name: 'Shop A',
      status: status,
      isListed: isListed,
      approvedAt: approvedAt,
    );

StadiumResponse _stadium(
  String id, {
  bool isActive = true,
  bool isPublished = true,
}) =>
    StadiumResponse(
      id: id,
      shopId: 'shopA',
      name: id,
      images: const [],
      facilities: const [],
      openMinute: 480,
      closeMinute: 1320,
      timeZone: 'Asia/Yangon',
      isActive: isActive,
      isPublished: isPublished,
    );

CourtResponse _court(String id, {int? price, bool isActive = true}) =>
    CourtResponse(
      id: id,
      shopId: 'shopA',
      stadiumId: 's1',
      name: id,
      currency: 'MMK',
      slotMinutes: 60,
      images: const [],
      isActive: isActive,
      hourlyPrice: price,
    );

const _stadiumRequest = StadiumWriteRequest(
  name: 'Arena',
  openMinute: 480,
  closeMinute: 1320,
  isActive: true,
);

CourtWriteRequest _courtRequest({
  int price = 20000,
  bool isActive = true,
  int slotMinutes = 60,
}) =>
    CourtWriteRequest(
      name: 'Court 1',
      hourlyPrice: price,
      slotMinutes: slotMinutes,
      isActive: isActive,
    );

void main() {
  late _MockShops shops;
  late _MockStadiums stadiums;
  late _MockCourts courts;
  late _MockAuth auth;

  setUpAll(() {
    registerFallbackValue(<String, Object?>{});
    registerFallbackValue(<String, bool>{});
    registerFallbackValue(<CourtSurface>[]);
  });

  setUp(() {
    shops = _MockShops();
    stadiums = _MockStadiums();
    courts = _MockCourts();
    auth = _MockAuth();
    when(() => auth.currentUser)
        .thenReturn(const AuthUserResponse(uid: 'root', email: 'r@x.co'));
  });

  group('ShopRepository.setShopStatus', () {
    late ShopRepositoryImpl repo;
    late Map<String, Object?> shopFields;
    late Map<String, Object?> details;
    late Map<String, bool> published;

    setUp(() {
      repo = ShopRepositoryImpl(
        shopDataAgent: shops,
        stadiumDataAgent: stadiums,
        authDataAgent: auth,
      );
      when(() => shops.updateShop(
            any(),
            shop: any(named: 'shop'),
            details: any(named: 'details'),
            stadiumPublished: any(named: 'stadiumPublished'),
          )).thenAnswer((inv) async {
        shopFields = inv.namedArguments[#shop] as Map<String, Object?>;
        details = inv.namedArguments[#details] as Map<String, Object?>;
        published = inv.namedArguments[#stadiumPublished] as Map<String, bool>;
      });
    });

    test('suspending unpublishes only the stadiums that were published',
        () async {
      when(() => shops.getShop('shopA')).thenAnswer(
        (_) async => _shop(approvedAt: DateTime.utc(2026)),
      );
      when(() => stadiums.getShopStadiums('shopA')).thenAnswer((_) async => [
            _stadium('s1'),
            _stadium('s2', isActive: false, isPublished: false),
          ]);

      await repo.setShopStatus(
        'shopA',
        status: ShopStatus.suspended,
        isListed: true,
        reason: 'Unpaid fees',
      );

      expect(published, {'s1': false});
      expect(shopFields[ShopFields.status], 'suspended');
      expect(shopFields.containsKey(ShopFields.approvedAt), isFalse);
      expect(details[ShopPrivateFields.suspendedReason], 'Unpaid fees');
      expect(details[ShopPrivateFields.suspendedAt], isA<DateTime>());
    });

    test('first approval publishes active stadiums and stamps approval',
        () async {
      when(() => shops.getShop('shopA')).thenAnswer(
        (_) async => _shop(status: ShopStatus.pending, isListed: false),
      );
      when(() => stadiums.getShopStadiums('shopA')).thenAnswer((_) async => [
            _stadium('s1', isPublished: false),
            _stadium('s2', isActive: false, isPublished: false),
          ]);

      await repo.setShopStatus(
        'shopA',
        status: ShopStatus.active,
        isListed: true,
      );

      expect(published, {'s1': true});
      expect(shopFields[ShopFields.approvedAt], isA<DateTime>());
      expect(details[ShopPrivateFields.approvedBy], 'root');
      expect(details[ShopPrivateFields.suspendedAt], isNull);
    });

    test('missing shop → NotFoundException, nothing written', () async {
      when(() => shops.getShop('shopA')).thenAnswer((_) async => null);
      await expectLater(
        repo.setShopStatus('shopA', status: ShopStatus.active, isListed: true),
        throwsA(isA<NotFoundException>()),
      );
      verifyNever(() => shops.updateShop(
            any(),
            shop: any(named: 'shop'),
            details: any(named: 'details'),
            stadiumPublished: any(named: 'stadiumPublished'),
          ));
    });
  });

  group('StadiumRepository', () {
    late StadiumRepositoryImpl repo;

    setUp(() {
      repo = StadiumRepositoryImpl(
        stadiumDataAgent: stadiums,
        shopDataAgent: shops,
      );
      when(() => stadiums.createStadium(
            shopId: any(named: 'shopId'),
            fields: any(named: 'fields'),
            isPublished: any(named: 'isPublished'),
          )).thenAnswer((_) async => 'new');
    });

    for (final (status, listed, expected) in [
      (ShopStatus.active, true, true),
      (ShopStatus.active, false, false),
      (ShopStatus.pending, true, false),
    ]) {
      test('create: $status shop, listed=$listed → isPublished=$expected',
          () async {
        when(() => shops.getShop('shopA'))
            .thenAnswer((_) async => _shop(status: status, isListed: listed));

        await repo.createStadium('shopA', _stadiumRequest);

        verify(() => stadiums.createStadium(
              shopId: 'shopA',
              fields: any(named: 'fields'),
              isPublished: expected,
            )).called(1);
      });
    }

    test('opening time off the hour → InvalidVenueDetailsException', () {
      expect(
        repo.createStadium(
          'shopA',
          const StadiumWriteRequest(
            name: 'Arena',
            openMinute: 510,
            closeMinute: 1320,
            isActive: true,
          ),
        ),
        throwsA(isA<InvalidVenueDetailsException>()),
      );
    });

    test('request carries no shopId / isPublished of its own', () {
      final fields = _stadiumRequest.toFirestore();
      expect(fields.containsKey(StadiumFields.shopId), isFalse);
      expect(fields.containsKey(StadiumFields.isPublished), isFalse);
    });
  });

  group('CourtRepository', () {
    late CourtRepositoryImpl repo;

    setUp(() {
      repo = CourtRepositoryImpl(
        courtDataAgent: courts,
        stadiumDataAgent: stadiums,
      );
      when(() => courts.saveCourt(
            any(),
            courtId: any(named: 'courtId'),
            shopId: any(named: 'shopId'),
            fields: any(named: 'fields'),
            minHourlyPrice: any(named: 'minHourlyPrice'),
            surfaces: any(named: 'surfaces'),
          )).thenAnswer((_) async => 'c-new');
    });

    test('create: shopId comes from the stadium; min price includes it',
        () async {
      when(() => stadiums.getStadium('s1'))
          .thenAnswer((_) async => _stadium('s1'));
      when(() => courts.getAllCourts('s1')).thenAnswer((_) async => [
            _court('c1', price: 30000),
            _court('c2', price: 5000, isActive: false),
          ]);

      await repo.createCourt('s1', _courtRequest(price: 20000));

      verify(() => courts.saveCourt(
            's1',
            shopId: 'shopA',
            fields: any(named: 'fields'),
            minHourlyPrice: 20000,
            surfaces: any(named: 'surfaces'),
          )).called(1);
    });

    test('update: the edited court replaces its old price', () async {
      when(() => courts.getAllCourts('s1')).thenAnswer((_) async => [
            _court('c1', price: 10000),
            _court('c2', price: 30000),
          ]);

      await repo.updateCourt('s1', 'c1', _courtRequest(isActive: false));

      verify(() => courts.saveCourt(
            's1',
            courtId: 'c1',
            shopId: 'shopA',
            fields: any(named: 'fields'),
            minHourlyPrice: 30000,
            surfaces: any(named: 'surfaces'),
          )).called(1);
    });

    test('update never writes slotMinutes', () {
      expect(
        _courtRequest().toUpdateFields().containsKey('slotMinutes'),
        isFalse,
      );
    });

    test('create with a 45-minute slot → InvalidVenueDetailsException', () {
      expect(
        repo.createCourt('s1', _courtRequest(slotMinutes: 45)),
        throwsA(isA<InvalidVenueDetailsException>()),
      );
    });
  });
}
