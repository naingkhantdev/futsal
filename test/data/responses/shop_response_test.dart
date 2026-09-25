import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/data/responses/shop_private_response.dart';
import 'package:futsal_booking/data/responses/shop_response.dart';

void main() {
  group('ShopResponse.fromFirestore', () {
    test('parses a full doc', () {
      final created = DateTime(2026, 1, 2);
      final r = ShopResponse.fromFirestore('s1', {
        'name': 'Golden Futsal',
        'slug': 'golden-futsal',
        'city': 'Yangon',
        'township': 'Sanchaung',
        'latitude': 16.8,
        'longitude': 96,
        'status': 'active',
        'isListed': true,
        'createdAt': Timestamp.fromDate(created),
      });
      expect(r.id, 's1');
      expect(r.name, 'Golden Futsal');
      expect(r.slug, 'golden-futsal');
      expect(r.longitude, 96.0);
      expect(r.status, ShopStatus.active);
      expect(r.isListed, isTrue);
      expect(r.createdAt, created);
    });

    test('empty doc: safe defaults, never active or listed', () {
      final r = ShopResponse.fromFirestore('s1', const {});
      expect(r.name, '');
      expect(r.slug, isNull);
      expect(r.status, ShopStatus.inactive);
      expect(r.isListed, isFalse);
      expect(r.createdAt, isNull);
    });

    test('unknown status never elevates; non-bool isListed is false', () {
      final r = ShopResponse.fromFirestore('s1', const {
        'status': 'superActive',
        'isListed': 'true',
      });
      expect(r.status, ShopStatus.inactive);
      expect(r.isListed, isFalse);
    });

    test('wrong types become null', () {
      final r = ShopResponse.fromFirestore('s1', const {
        'name': 42,
        'phone': '',
        'latitude': 'north',
      });
      expect(r.name, '');
      expect(r.phone, isNull);
      expect(r.latitude, isNull);
    });
  });

  group('ShopPrivateResponse.fromFirestore', () {
    test('shopId comes from the path; adminIds skips junk', () {
      final r = ShopPrivateResponse.fromFirestore('s1', const {
        'shopId': 'other',
        'ownerName': 'U Aung',
        'adminIds': ['a1', 7, '', 'a2'],
      });
      expect(r.shopId, 's1');
      expect(r.ownerName, 'U Aung');
      expect(r.adminIds, ['a1', 'a2']);
    });

    test('missing adminIds is empty', () {
      final r = ShopPrivateResponse.fromFirestore('s1', const {});
      expect(r.adminIds, isEmpty);
      expect(r.suspendedReason, isNull);
    });
  });
}
