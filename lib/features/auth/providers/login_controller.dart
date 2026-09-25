import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';

/// Login form submission. Idle = `AsyncData(null)`; failures are
/// `AppException`s from the repository. On success the router redirects
/// once the session resolves.
class LoginController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
    return !state.hasError;
  }
}

final loginControllerProvider =
    AsyncNotifierProvider.autoDispose<LoginController, void>(
  LoginController.new,
);
