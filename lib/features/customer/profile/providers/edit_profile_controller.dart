import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/auth_repository.dart';

/// CUSTOMER (self) scope: saves name/phone only. Role, shopId and isActive
/// are not editable (and firestore.rules reject them anyway).
class EditProfileController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save({required String name, required String? phone}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .updateProfile(name: name, phone: phone),
    );
    return !state.hasError;
  }
}

final editProfileControllerProvider =
    AsyncNotifierProvider.autoDispose<EditProfileController, void>(
  EditProfileController.new,
);
