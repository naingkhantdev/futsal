import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/firebase_error_mapper.dart' show AuthErrorCodes;

/// Thin wrapper over [FirebaseAuth]. No mapping or business logic here —
/// errors propagate raw and are mapped to `AppException` in repositories.
class FirebaseAuthService {
  FirebaseAuthService(this._auth);

  final FirebaseAuth _auth;

  /// Fires on sign-in and sign-out. Roles are not in the token (they live
  /// in `users/{uid}`), so token refreshes are irrelevant to the session.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> createUserWithEmail(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() => _auth.signOut();

  Future<void> reauthenticateWithPassword(String password) async {
    final user = _requireUser();
    final email = user.email;
    if (email == null) {
      throw FirebaseAuthException(code: AuthErrorCodes.noCurrentUser);
    }
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
  }

  Future<void> updatePassword(String newPassword) =>
      _requireUser().updatePassword(newPassword);

  Future<void> updateDisplayName(String name) =>
      _requireUser().updateDisplayName(name);

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: AuthErrorCodes.noCurrentUser);
    }
    return user;
  }
}

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(FirebaseAuth.instance),
);
