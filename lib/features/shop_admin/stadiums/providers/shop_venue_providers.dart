import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../data/repositories/court_repository.dart';
import '../../../../data/repositories/shop_repository.dart';
import '../../../../data/repositories/stadium_repository.dart';
import '../../../../data/requests/venue_write_requests.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../../data/vos/shop_vo.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../../../auth/providers/auth_session_provider.dart';

/// SHOP scope. The shop is always the signed-in admin's
/// `users/{uid}.shopId` ([currentShopIdProvider]), never a route
/// parameter; firestore.rules refuse anything outside that shop.

/// The admin's own shop (status / listing banner).
final myShopProvider = StreamProvider.autoDispose<ShopVO?>((ref) {
  final shopId = ref.watch(currentShopIdProvider);
  if (shopId == null) return Stream.error(const PermissionDeniedException());
  return ref.watch(shopRepositoryProvider).watchShop(shopId);
});

/// Every stadium of the admin's shop, active or not.
final myStadiumsProvider = StreamProvider.autoDispose<List<StadiumVO>>((ref) {
  final shopId = ref.watch(currentShopIdProvider);
  if (shopId == null) return Stream.error(const PermissionDeniedException());
  return ref.watch(stadiumRepositoryProvider).watchShopStadiums(shopId);
});

final adminStadiumProvider =
    StreamProvider.autoDispose.family<StadiumVO?, String>(
  (ref, stadiumId) =>
      ref.watch(stadiumRepositoryProvider).watchStadium(stadiumId),
);

/// All courts of a stadium, including inactive ones (admin view).
final adminCourtsProvider =
    StreamProvider.autoDispose.family<List<CourtVO>, String>(
  (ref, stadiumId) => ref
      .watch(courtRepositoryProvider)
      .watchCourts(stadiumId, activeOnly: false),
);

typedef CourtRef = ({String stadiumId, String courtId});

final adminCourtProvider = StreamProvider.autoDispose.family<CourtVO?, CourtRef>(
  (ref, id) =>
      ref.watch(courtRepositoryProvider).watchCourt(id.stadiumId, id.courtId),
);

/// Creates (no `stadiumId`) or updates a stadium of the admin's shop.
/// Returns the stadium id, or `null` on failure (error in `state`).
class StadiumFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> save({
    String? stadiumId,
    required StadiumWriteRequest request,
  }) async {
    state = const AsyncLoading();
    String? id;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(stadiumRepositoryProvider);
      if (stadiumId != null) {
        await repo.updateStadium(stadiumId, request);
        id = stadiumId;
        return;
      }
      final shopId = ref.read(currentShopIdProvider);
      if (shopId == null) throw const PermissionDeniedException();
      id = await repo.createStadium(shopId, request);
    });
    return state.hasError ? null : id;
  }
}

final stadiumFormControllerProvider =
    AsyncNotifierProvider.autoDispose<StadiumFormController, void>(
  StadiumFormController.new,
);

/// Creates (no `courtId`) or updates a court. Returns the court id, or
/// `null` on failure (error in `state`).
class CourtFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> save(
    String stadiumId, {
    String? courtId,
    required CourtWriteRequest request,
  }) async {
    state = const AsyncLoading();
    String? id;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(courtRepositoryProvider);
      if (courtId != null) {
        await repo.updateCourt(stadiumId, courtId, request);
        id = courtId;
      } else {
        id = await repo.createCourt(stadiumId, request);
      }
    });
    return state.hasError ? null : id;
  }
}

final courtFormControllerProvider =
    AsyncNotifierProvider.autoDispose<CourtFormController, void>(
  CourtFormController.new,
);
