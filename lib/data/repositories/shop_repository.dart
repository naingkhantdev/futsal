import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../data_agents/auth_data_agent_impl.dart';
import '../data_agents/shop_data_agent_impl.dart';
import '../data_agents/stadium_data_agent_impl.dart';
import '../requests/venue_write_requests.dart';
import '../vos/shop_private_vo.dart';
import '../vos/shop_vo.dart';
import 'shop_repository_impl.dart';

/// Shops. Every method throws / emits only `AppException`.
///
/// Access is enforced by firestore.rules, not here: customers can read a
/// shop only while it is active + listed; the private details only the
/// superadmin (PLATFORM) and that shop's admins (SHOP) can read; only the
/// superadmin writes.
abstract interface class ShopRepository {
  /// Emits `null` while the shop doc does not exist.
  Stream<ShopVO?> watchShop(String shopId);

  /// SHOP / PLATFORM scope.
  Stream<ShopPrivateVO?> watchShopPrivateDetails(String shopId);

  /// PLATFORM scope: every shop, by name.
  Stream<List<ShopVO>> watchShops();

  /// PLATFORM scope: a new shop, `pending` and unlisted. Returns its id.
  Future<String> createShop(ShopProfileRequest request);

  /// PLATFORM scope: profile + owner contact only (not status).
  Future<void> updateShopProfile(String shopId, ShopProfileRequest request);

  /// PLATFORM scope: status / listing change. In the same batch every
  /// stadium of the shop gets its `isPublished` re-synced, so discovery
  /// hides a suspended or unlisted shop at once. (Bookings never depend on
  /// that: the booking rule re-checks the shop itself.)
  Future<void> setShopStatus(
    String shopId, {
    required ShopStatus status,
    required bool isListed,
    String? reason,
  });
}

final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => ShopRepositoryImpl(
    shopDataAgent: ref.watch(shopDataAgentProvider),
    stadiumDataAgent: ref.watch(stadiumDataAgentProvider),
    authDataAgent: ref.watch(authDataAgentProvider),
  ),
);
