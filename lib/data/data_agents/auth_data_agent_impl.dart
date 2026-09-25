import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/firebase_error_mapper.dart' show AuthErrorCodes;
import '../../firebase/auth/firebase_auth_service.dart';
import '../responses/auth_user_response.dart';
import 'auth_data_agent.dart';

class AuthDataAgentImpl implements AuthDataAgent {
  AuthDataAgentImpl(this._service);

  final FirebaseAuthService _service;

  @override
  Stream<AuthUserResponse?> watchAuthUser() =>
      _service.authStateChanges().map(_toResponse);

  @override
  AuthUserResponse? get currentUser => _toResponse(_service.currentUser);

  @override
  Future<AuthUserResponse> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _service.signInWithEmail(email, password);
    return _requireResponse(credential.user);
  }

  @override
  Future<AuthUserResponse> createAccount({
    required String email,
    required String password,
  }) async {
    final credential = await _service.createUserWithEmail(email, password);
    return _requireResponse(credential.user);
  }

  @override
  Future<void> updateDisplayName(String name) =>
      _service.updateDisplayName(name);

  @override
  Future<void> sendPasswordReset(String email) =>
      _service.sendPasswordResetEmail(email);

  @override
  Future<void> reauthenticate(String currentPassword) =>
      _service.reauthenticateWithPassword(currentPassword);

  @override
  Future<void> updatePassword(String newPassword) =>
      _service.updatePassword(newPassword);

  @override
  Future<void> signOut() => _service.signOut();

  static AuthUserResponse? _toResponse(User? user) => user == null
      ? null
      : AuthUserResponse(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
        );

  static AuthUserResponse _requireResponse(User? user) {
    final response = _toResponse(user);
    if (response == null) {
      throw FirebaseAuthException(code: AuthErrorCodes.noCurrentUser);
    }
    return response;
  }
}

final authDataAgentProvider = Provider<AuthDataAgent>(
  (ref) => AuthDataAgentImpl(ref.watch(firebaseAuthServiceProvider)),
);
