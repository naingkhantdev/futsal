import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/vos/user_vo.dart';

/// PLATFORM scope: admins assigned to a shop.
final shopAdminsProvider =
    StreamProvider.autoDispose.family<List<UserVO>, String>(
  (ref, shopId) => ref.watch(userRepositoryProvider).watchShopAdmins(shopId),
);

/// Result of an email lookup: the email searched and the account found
/// (`null` user = no account with that email).
typedef UserLookup = ({String email, UserVO? user});

/// Finds an account by email. State: `null` before the first search.
class ShopAdminLookupController extends AutoDisposeAsyncNotifier<UserLookup?> {
  @override
  FutureOr<UserLookup?> build() => null;

  Future<void> search(String email) async {
    final typed = email.trim();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => (
          email: typed,
          user: await ref.read(userRepositoryProvider).findUserByEmail(typed),
        ));
  }

  void clear() => state = const AsyncData(null);
}

final shopAdminLookupControllerProvider =
    AsyncNotifierProvider.autoDispose<ShopAdminLookupController, UserLookup?>(
  ShopAdminLookupController.new,
);

/// Assigns an account to a shop as shop admin, or removes it (back to
/// customer). firestore.rules: superadmin only, never on their own doc,
/// and the shop must exist.
class ShopAdminAssignmentController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> assign(String uid, String shopId) => _run(
        () => ref
            .read(userRepositoryProvider)
            .setUserRole(uid, UserRole.shopAdmin, shopId: shopId),
      );

  Future<bool> remove(String uid) => _run(
        () => ref
            .read(userRepositoryProvider)
            .setUserRole(uid, UserRole.customer),
      );

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}

final shopAdminAssignmentControllerProvider =
    AsyncNotifierProvider.autoDispose<ShopAdminAssignmentController, void>(
  ShopAdminAssignmentController.new,
);
