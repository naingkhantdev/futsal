import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_agents/auth_data_agent_impl.dart';
import '../data_agents/user_data_agent_impl.dart';
import '../vos/user_vo.dart';
import 'auth_repository_impl.dart';

/// Account operations for the signed-in (or signing-in) user.
///
/// Every method throws only `AppException`. Role, shopId and isActive are
/// never written here: self-registration always creates an active customer
/// (the only shape firestore.rules accept) and only a superadmin changes
/// roles (`UserRepository`).
abstract interface class AuthRepository {
  Future<void> signIn({required String email, required String password});

  /// CUSTOMER self-registration: creates the Auth account, then
  /// `users/{uid}` as `{role: customer, shopId: null, isActive: true}` with
  /// the entered name/phone. There is no role input.
  ///
  /// If the profile write fails the error is thrown, the user stays signed
  /// in and the session reports `incomplete`, which re-creates the doc
  /// (splash shows "Try again" if that fails too).
  Future<void> register({
    required String name,
    required String email,
    required String? phone,
    required String password,
  });

  /// Whether an unknown email errors depends on the project's
  /// email-enumeration protection; the UI shows the same "check your email"
  /// copy either way and never reveals whether an account exists.
  Future<void> sendPasswordReset(String email);

  Future<void> signOut();

  /// Re-authenticates with [currentPassword], then sets [newPassword].
  /// Wrong current password → `IncorrectPasswordException`.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// CUSTOMER (self) scope. Emits `null` while the profile doc is missing.
  Stream<UserVO?> watchProfile(String uid);

  /// CUSTOMER (self) scope: name and phone only.
  Future<void> updateProfile({required String name, required String? phone});
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    authDataAgent: ref.watch(authDataAgentProvider),
    userDataAgent: ref.watch(userDataAgentProvider),
  ),
);
