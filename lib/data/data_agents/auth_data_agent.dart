import '../responses/auth_user_response.dart';

/// Firebase Auth access as typed Responses. Throws raw Firebase errors;
/// repositories map them to `AppException`.
///
/// Roles are not read from Auth (no custom claims on the Spark plan); they
/// live in `users/{uid}` (see `UserDataAgent`).
abstract interface class AuthDataAgent {
  /// Emits on sign-in and sign-out.
  Stream<AuthUserResponse?> watchAuthUser();

  AuthUserResponse? get currentUser;

  Future<AuthUserResponse> signIn({
    required String email,
    required String password,
  });

  /// Creates the Firebase Auth account (signs it in). The caller then
  /// creates the `users/{uid}` customer doc.
  Future<AuthUserResponse> createAccount({
    required String email,
    required String password,
  });

  Future<void> updateDisplayName(String name);

  Future<void> sendPasswordReset(String email);

  Future<void> reauthenticate(String currentPassword);

  Future<void> updatePassword(String newPassword);

  Future<void> signOut();
}
