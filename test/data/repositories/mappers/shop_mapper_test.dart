import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/data/repositories/mappers/shop_mapper.dart';
import 'package:futsal_booking/data/responses/shop_private_response.dart';
import 'package:futsal_booking/data/responses/shop_response.dart';
import 'package:futsal_booking/data/vos/shop_private_vo.dart';
import 'package:futsal_booking/data/vos/shop_vo.dart';

void main() {
  test('Firestore map -> ShopResponse -> ShopVO keeps every field', () {
    final t = DateTime(2026, 1, 2, 3, 4);
    final vo = ShopResponse.fromFirestore('s1', {
      'name': 'Golden Futsal',
      'slug': 'golden',
      'description': 'Two courts',
      'logo': 'logo.png',
      'coverImage': 'cover.png',
      'phone': '+95 9111',
      'email': 'shop@example.com',
      'address': '1 Main Rd',
      'township': 'Sanchaung',
      'city': 'Yangon',
      'latitude': 16.8,
      'longitude': 96.1,
      'status': 'active',
      'isListed': true,
      'approvedAt': Timestamp.fromDate(t),
      'createdAt': Timestamp.fromDate(t),
      'updatedAt': Timestamp.fromDate(t),
    }).toVO();

    expect(
      vo,
      ShopVO(
        id: 's1',
        name: 'Golden Futsal',
        slug: 'golden',
        description: 'Two courts',
        logo: 'logo.png',
        coverImage: 'cover.png',
        phone: '+95 9111',
        email: 'shop@example.com',
        address: '1 Main Rd',
        township: 'Sanchaung',
        city: 'Yangon',
        latitude: 16.8,
        longitude: 96.1,
        status: ShopStatus.active,
        isListed: true,
        approvedAt: t,
        createdAt: t,
        updatedAt: t,
      ),
    );
    expect(vo.isVisibleToCustomers, isTrue);
  });

  test('isVisibleToCustomers needs active AND listed', () {
    ShopVO shop(String status, bool listed) => ShopResponse.fromFirestore(
          's1',
          {'status': status, 'isListed': listed},
        ).toVO();
    expect(shop('active', false).isVisibleToCustomers, isFalse);
    expect(shop('suspended', true).isVisibleToCustomers, isFalse);
    expect(shop('bogus', true).isVisibleToCustomers, isFalse);
  });

  test('ShopPrivateResponse -> ShopPrivateVO', () {
    final t = DateTime(2026, 5, 6);
    final vo = ShopPrivateResponse.fromFirestore('s1', {
      'ownerName': 'U Aung',
      'ownerPhone': '+95 9222',
      'adminIds': const ['a1', 'a2'],
      'approvedBy': 'root',
      'suspendedAt': Timestamp.fromDate(t),
      'suspendedReason': 'Unpaid fees',
      'updatedAt': Timestamp.fromDate(t),
    }).toVO();
    expect(
      vo,
      ShopPrivateVO(
        shopId: 's1',
        ownerName: 'U Aung',
        ownerPhone: '+95 9222',
        adminIds: const ['a1', 'a2'],
        approvedBy: 'root',
        suspendedAt: t,
        suspendedReason: 'Unpaid fees',
        updatedAt: t,
      ),
    );
  });
}
