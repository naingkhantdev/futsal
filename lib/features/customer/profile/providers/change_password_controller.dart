import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/auth_repository.dart';

/// Re-authenticates with the current password, then sets the new one.
class ChangePasswordController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
    );
    return !state.hasError;
  }
}

final changePasswordControllerProvider =
    AsyncNotifierProvider.autoDispose<ChangePasswordController, void>(
  ChangePasswordController.new,
);
