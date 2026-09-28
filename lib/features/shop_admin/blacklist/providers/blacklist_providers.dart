import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../data/repositories/blacklist_repository.dart';
import '../../../../data/requests/blacklist_requests.dart';
import '../../../../data/vos/blacklist_entry_vo.dart';
import '../../../auth/providers/auth_session_provider.dart';

/// SHOP scope. The shop is always the signed-in admin's
/// `users/{uid}.shopId` ([currentShopIdProvider]); firestore.rules refuse
/// any other shop's blacklist.

/// The admin's shop blacklist, newest first.
final myBlacklistProvider =
    StreamProvider.autoDispose<List<BlacklistEntryVO>>((ref) {
  final shopId = ref.watch(currentShopIdProvider);
  if (shopId == null) return Stream.error(const PermissionDeniedException());
  return ref.watch(blacklistRepositoryProvider).watchShopBlacklist(shopId);
});

/// One customer's entry at the admin's shop (`null` = not blacklisted).
final myBlacklistEntryProvider =
    StreamProvider.autoDispose.family<BlacklistEntryVO?, String>(
  (ref, customerId) {
    final shopId = ref.watch(currentShopIdProvider);
    if (shopId == null) return Stream.error(const PermissionDeniedException());
    return ref
        .watch(blacklistRepositoryProvider)
        .watchEntry(shopId, customerId);
  },
);

/// Adds / removes blacklist entries of the admin's shop. Each call returns
/// `true` on success; on failure the error is in `state`.
class BlacklistController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> add(BlacklistAddRequest request) =>
      _run((repo, shopId) => repo.add(shopId, request));

  Future<bool> remove(String customerId) =>
      _run((repo, shopId) => repo.remove(shopId, customerId));

  Future<bool> _run(
    Future<void> Function(BlacklistRepository repo, String shopId) action,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final shopId = ref.read(currentShopIdProvider);
      if (shopId == null) throw const PermissionDeniedException();
      await action(ref.read(blacklistRepositoryProvider), shopId);
    });
    return !state.hasError;
  }
}

final blacklistControllerProvider =
    AsyncNotifierProvider.autoDispose<BlacklistController, void>(
  BlacklistController.new,
);
