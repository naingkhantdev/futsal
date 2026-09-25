import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter/foundation.dart';

import '../../firebase/firestore/user_fields.dart';

/// Typed DTO for `users/{uid}`.
///
/// Parsed by hand (not json_serializable) so a malformed or partially
/// written doc degrades safely instead of throwing: unknown types become
/// null, and a missing `isActive` is read as `false` (fail closed).
@immutable
class UserResponse {
  const UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    this.phone,
    this.profileImage,
    this.role,
    this.shopId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserResponse.fromFirestore(String id, Map<String, dynamic> data) {
    return UserResponse(
      id: id,
      name: _string(data[UserFields.name]) ?? '',
      email: _string(data[UserFields.email]) ?? '',
      phone: _string(data[UserFields.phone]),
      profileImage: _string(data[UserFields.profileImage]),
      role: _string(data[UserFields.role]),
      shopId: _string(data[UserFields.shopId]),
      isActive: data[UserFields.isActive] == true,
      createdAt: _date(data[UserFields.createdAt]),
      updatedAt: _date(data[UserFields.updatedAt]),
    );
  }

  /// Document id == Firebase Auth uid.
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;

  /// THE source of truth for roles (firestore.rules read the same fields).
  /// Raw strings: the session decides what an unknown role means — never a
  /// default role. Only a superadmin can change role / shopId / isActive.
  final String? role;
  final String? shopId;
  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  static String? _string(Object? v) => v is String && v.isNotEmpty ? v : null;

  static DateTime? _date(Object? v) => switch (v) {
        final Timestamp t => t.toDate(),
        final DateTime d => d,
        _ => null,
      };

  @override
  bool operator ==(Object other) =>
      other is UserResponse &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.phone == phone &&
      other.profileImage == profileImage &&
      other.role == role &&
      other.shopId == shopId &&
      other.isActive == isActive &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(id, name, email, phone, profileImage, role,
      shopId, isActive, createdAt, updatedAt);
}
