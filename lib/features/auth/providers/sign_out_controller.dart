import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';

/// Sign out (account-blocked, splash error, profile). The router moves to
/// /login when the session becomes `SignedOut`.
class SignOutController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signOut(),
    );
    return !state.hasError;
  }
}

final signOutControllerProvider =
    AsyncNotifierProvider.autoDispose<SignOutController, void>(
  SignOutController.new,
);
