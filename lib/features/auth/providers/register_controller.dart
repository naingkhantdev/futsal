import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';

/// CUSTOMER self-registration. No role input: the client can only create
/// an active customer profile (firestore.rules).
///
/// If the profile write fails after the account was created, the error is
/// shown here but the router usually moves to splash first: the session is
/// then `incomplete`, re-creates the profile and offers "Try again".
class RegisterController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({
    required String name,
    required String email,
    required String? phone,
    required String password,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      ),
    );
    // The router may have left /register (disposing this controller).
    if (!ref.exists(registerControllerProvider)) return !result.hasError;
    state = result;
    return !result.hasError;
  }
}

final registerControllerProvider =
    AsyncNotifierProvider.autoDispose<RegisterController, void>(
  RegisterController.new,
);
