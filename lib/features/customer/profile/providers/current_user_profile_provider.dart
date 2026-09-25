import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/vos/auth_session.dart';
import '../../../../data/vos/user_vo.dart';
import '../../../auth/providers/auth_session_provider.dart';

/// CUSTOMER (self) scope: the signed-in user's own `users/{uid}` profile.
/// Rules allow reading only your own doc (or any, for superadmin).
final currentUserProfileProvider = StreamProvider.autoDispose<UserVO?>((ref) {
  final uid = ref.watch(
    currentAuthSessionProvider.select((s) => s is SignedIn ? s.uid : null),
  );
  if (uid == null) return Stream<UserVO?>.value(null);
  return ref.watch(authRepositoryProvider).watchProfile(uid);
});
