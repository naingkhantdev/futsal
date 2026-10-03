import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/player_repository.dart';

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
    if (state.hasError) return false;
    // The player card copies the name; a stale copy is only cosmetic, so a
    // failure here doesn't fail the save.
    try {
      await ref.read(playerRepositoryProvider).syncMyDisplayName();
    } on Object {
      // Ignored: retried the next time the card or name is saved.
    }
    return true;
  }
}

final editProfileControllerProvider =
    AsyncNotifierProvider.autoDispose<EditProfileController, void>(
  EditProfileController.new,
);
