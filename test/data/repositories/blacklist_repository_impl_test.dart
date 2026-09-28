import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/errors/app_exception.dart';
import 'package:futsal_booking/data/data_agents/auth_data_agent.dart';
import 'package:futsal_booking/data/data_agents/blacklist_data_agent.dart';
import 'package:futsal_booking/data/repositories/blacklist_repository_impl.dart';
import 'package:futsal_booking/data/requests/blacklist_requests.dart';
import 'package:futsal_booking/data/responses/auth_user_response.dart';
import 'package:futsal_booking/firebase/firestore/blacklist_fields.dart';
import 'package:mocktail/mocktail.dart';

class _MockBlacklist extends Mock implements BlacklistDataAgent {}

class _MockAuth extends Mock implements AuthDataAgent {}

BlacklistAddRequest _request({
  String customerId = 'cust1',
  String name = 'Aung Kyaw',
  String? phone = ' 09 450 123 456 ',
  String? note = '  Missed two games  ',
}) =>
    BlacklistAddRequest(
      customerId: customerId,
      customerName: name,
      customerPhone: phone,
      reason: BlacklistReason.noShow,
      note: note,
    );

void main() {
  late _MockBlacklist blacklist;
  late _MockAuth auth;
  late BlacklistRepositoryImpl repo;

  setUp(() {
    blacklist = _MockBlacklist();
    auth = _MockAuth();
    repo = BlacklistRepositoryImpl(
      blacklistDataAgent: blacklist,
      authDataAgent: auth,
    );
    when(() => auth.currentUser)
        .thenReturn(const AuthUserResponse(uid: 'admin1', email: 'a@x.co'));
    when(() => blacklist.addEntry(any(), any(), any()))
        .thenAnswer((_) async {});
  });

  group('BlacklistRepository.add', () {
    test('writes the rule-shaped fields for the shop', () async {
      await repo.add('shopA', _request());

      final fields = verify(
        () => blacklist.addEntry('shopA', 'cust1', captureAny()),
      ).captured.single as Map<String, Object?>;
      expect(fields, {
        BlacklistFields.shopId: 'shopA',
        BlacklistFields.customerId: 'cust1',
        BlacklistFields.customerNameSnapshot: 'Aung Kyaw',
        BlacklistFields.customerPhoneSnapshot: '09 450 123 456',
        BlacklistFields.reason: 'noShow',
        BlacklistFields.note: 'Missed two games',
        BlacklistFields.createdBy: 'admin1',
      });
    });

    test('stores blank phone and note as null', () async {
      await repo.add('shopA', _request(phone: '  ', note: ''));

      final fields = verify(
        () => blacklist.addEntry('shopA', 'cust1', captureAny()),
      ).captured.single as Map<String, Object?>;
      expect(fields[BlacklistFields.customerPhoneSnapshot], isNull);
      expect(fields[BlacklistFields.note], isNull);
    });

    test('refuses blacklisting yourself', () async {
      await expectLater(
        repo.add('shopA', _request(customerId: 'admin1')),
        throwsA(isA<InvalidVenueDetailsException>()),
      );
      verifyNever(() => blacklist.addEntry(any(), any(), any()));
    });

    test('refuses a note over the limit', () async {
      await expectLater(
        repo.add('shopA', _request(note: 'x' * 201)),
        throwsA(isA<InvalidVenueDetailsException>()),
      );
      verifyNever(() => blacklist.addEntry(any(), any(), any()));
    });

    test('requires a signed-in admin', () async {
      when(() => auth.currentUser).thenReturn(null);
      await expectLater(
        repo.add('shopA', _request()),
        throwsA(isA<AuthenticationException>()),
      );
    });
  });

  test('isBlacklisted forwards the lookup', () async {
    when(() => blacklist.isBlacklisted('shopA', 'cust1'))
        .thenAnswer((_) async => true);
    expect(await repo.isBlacklisted('shopA', 'cust1'), isTrue);
  });
}
