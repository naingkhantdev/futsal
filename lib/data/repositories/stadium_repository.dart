import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_agents/shop_data_agent_impl.dart';
import '../data_agents/stadium_data_agent_impl.dart';
import '../requests/venue_write_requests.dart';
import '../vos/stadium_vo.dart';
import 'stadium_repository_impl.dart';

/// Stadiums. Every method throws / emits only `AppException`.
abstract interface class StadiumRepository {
  /// CUSTOMER discovery: published stadiums (active + listed shop, active
  /// stadium), by name. Blank filters are ignored.
  Stream<List<StadiumVO>> watchPublishedStadiums({
    String? city,
    String? township,
  });

  /// `null` when the stadium does not exist. A customer reading an
  /// unpublished stadium gets `PermissionDeniedException` (rules).
  Future<StadiumVO?> getStadium(String stadiumId);

  Stream<StadiumVO?> watchStadium(String stadiumId);

  /// SHOP / PLATFORM scope: every stadium of [shopId], active or not, by
  /// name. Rules allow it only for that shop's admins and the superadmin.
  Stream<List<StadiumVO>> watchShopStadiums(String shopId);

  /// SHOP scope: a stadium in the admin's own shop ([shopId] must be the
  /// signed-in admin's `users/{uid}.shopId`, or the rules refuse it).
  /// `isPublished` is derived from the shop's status. Returns the new id.
  Future<String> createStadium(String shopId, StadiumWriteRequest request);

  /// SHOP scope. `shopId` never changes; `isPublished` is re-derived.
  Future<void> updateStadium(String stadiumId, StadiumWriteRequest request);
}

final stadiumRepositoryProvider = Provider<StadiumRepository>(
  (ref) => StadiumRepositoryImpl(
    stadiumDataAgent: ref.watch(stadiumDataAgentProvider),
    shopDataAgent: ref.watch(shopDataAgentProvider),
  ),
);
