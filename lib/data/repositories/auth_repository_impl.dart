import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../../core/utils/validators.dart';
import '../data_agents/auth_data_agent.dart';
import '../data_agents/user_data_agent.dart';
import '../vos/user_vo.dart';
import 'auth_repository.dart';
import 'mappers/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataAgent authDataAgent,
    required UserDataAgent userDataAgent,
  })  : _auth = authDataAgent,
        _users = userDataAgent;

  final AuthDataAgent _auth;
  final UserDataAgent _users;

  /// Codes Firebase returns for a wrong password on re-authentication.
  static const Set<String> _wrongPasswordCodes = {
    'wrong-password',
    'invalid-credential',
    'invalid-login-credentials',
  };

  @override
  Future<void> signIn({required String email, required String password}) {
    return guardAppException(
      () => _auth.signIn(email: email.trim(), password: password),
    );
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String? phone,
    required String password,
  }) {
    return guardAppException(() async {
      final user =
          await _auth.createAccount(email: email.trim(), password: password);
      final trimmedName = name.trim();
      final normalizedPhone = AppValidators.normalizePhone(phone);
      // Display name first: if the profile write below fails, the session's
      // recovery path re-creates users/{uid} from it. Cosmetic otherwise.
      try {
        await _auth.updateDisplayName(trimmedName);
      } catch (error) {
        debugPrint('Display name update after registration failed: $error');
      }
      // CUSTOMER scope. The rules require email == the Auth token email, so
      // use the account's email rather than the typed one.
      final created = await _users.createCustomerProfile(
        user.uid,
        email: user.email ?? email.trim(),
        name: trimmedName,
        phone: normalizedPhone,
      );
      if (!created) {
        // The session's recovery path won the race (possibly without the
        // phone); write what the user entered.
        await _users.updateProfile(
          user.uid,
          name: trimmedName,
          phone: normalizedPhone,
        );
      }
    });
  }

  @override
  Future<void> sendPasswordReset(String email) {
    return guardAppException(() => _auth.sendPasswordReset(email.trim()));
  }

  @override
  Future<void> signOut() => guardAppException(() => _auth.signOut());

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return guardAppException(() async {
      try {
        await _auth.reauthenticate(currentPassword);
      } on FirebaseAuthException catch (e, st) {
        if (_wrongPasswordCodes.contains(e.code)) {
          throw IncorrectPasswordException(cause: e, stackTrace: st);
        }
        rethrow;
      }
      await _auth.updatePassword(newPassword);
    });
  }

  @override
  Stream<UserVO?> watchProfile(String uid) {
    return mapStreamErrors(
      _users.watchUser(uid).map((response) => response?.toVO()),
    );
  }

  @override
  Future<void> updateProfile({required String name, required String? phone}) {
    return guardAppException(() async {
      final user = _auth.currentUser;
      if (user == null) throw const AuthenticationException();
      final trimmed = name.trim();
      // CUSTOMER (self): rules restrict this write to name/phone/updatedAt.
      await _users.updateProfile(
        user.uid,
        name: trimmed,
        phone: AppValidators.normalizePhone(phone),
      );
      // Keep the Auth display name in sync; cosmetic, so best effort.
      try {
        await _auth.updateDisplayName(trimmed);
      } catch (error) {
        debugPrint('Display name sync failed: $error');
      }
    });
  }
}
