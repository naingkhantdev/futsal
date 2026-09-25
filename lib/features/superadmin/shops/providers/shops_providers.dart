import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../data/repositories/shop_repository.dart';
import '../../../../data/requests/venue_write_requests.dart';
import '../../../../data/vos/shop_private_vo.dart';
import '../../../../data/vos/shop_vo.dart';

/// PLATFORM scope: every shop (rules: superadmin only).
final allShopsProvider = StreamProvider.autoDispose<List<ShopVO>>(
  (ref) => ref.watch(shopRepositoryProvider).watchShops(),
);

final shopProvider = StreamProvider.autoDispose.family<ShopVO?, String>(
  (ref, shopId) => ref.watch(shopRepositoryProvider).watchShop(shopId),
);

final shopPrivateProvider =
    StreamProvider.autoDispose.family<ShopPrivateVO?, String>(
  (ref, shopId) =>
      ref.watch(shopRepositoryProvider).watchShopPrivateDetails(shopId),
);

/// Creates (no [shopId]) or updates a shop's profile. Returns the shop id,
/// or `null` on failure (the error is in `state`).
class ShopFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> save({String? shopId, required ShopProfileRequest request}) {
    return _run(() async {
      final repo = ref.read(shopRepositoryProvider);
      if (shopId == null) return repo.createShop(request);
      await repo.updateShopProfile(shopId, request);
      return shopId;
    });
  }

  Future<String?> _run(Future<String> Function() action) async {
    state = const AsyncLoading();
    String? id;
    state = await AsyncValue.guard(() async {
      id = await action();
    });
    return state.hasError ? null : id;
  }
}

final shopFormControllerProvider =
    AsyncNotifierProvider.autoDispose<ShopFormController, void>(
  ShopFormController.new,
);

/// Approve / reject / suspend / reactivate / list / unlist.
class ShopStatusController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> setStatus(
    String shopId, {
    required ShopStatus status,
    required bool isListed,
    String? reason,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(shopRepositoryProvider).setShopStatus(
            shopId,
            status: status,
            isListed: isListed,
            reason: reason,
          ),
    );
    return !state.hasError;
  }
}

final shopStatusControllerProvider =
    AsyncNotifierProvider.autoDispose<ShopStatusController, void>(
  ShopStatusController.new,
);
