import 'package:flutter/foundation.dart';

/// Minimal Firebase Auth user DTO (no SDK types above the data agent).
@immutable
class AuthUserResponse {
  const AuthUserResponse({
    required this.uid,
    this.email,
    this.displayName,
  });

  final String uid;
  final String? email;
  final String? displayName;

  @override
  bool operator ==(Object other) =>
      other is AuthUserResponse &&
      other.uid == uid &&
      other.email == email &&
      other.displayName == displayName;

  @override
  int get hashCode => Object.hash(uid, email, displayName);
}
