import '../../core/constants/domain_enums.dart';
import '../responses/user_response.dart';

/// `users/{uid}` access as typed Responses. Throws raw Firebase errors;
/// repositories map them to `AppException`. Which writes succeed is decided
/// by firestore.rules, never here.
abstract interface class UserDataAgent {
  /// Emits `null` while the doc does not exist.
  Stream<UserResponse?> watchUser(String uid);

  /// One-off read; `null` when the doc does not exist.
  Future<UserResponse?> getUser(String uid);

  /// CUSTOMER (self) scope: creates the caller's own doc as an active
  /// customer without a shop (the only shape the rules accept). Returns
  /// `false` if the doc already existed (nothing written).
  Future<bool> createCustomerProfile(
    String uid, {
    required String email,
    required String name,
    required String? phone,
  });

  /// CUSTOMER (self) scope: writes only the non-privileged profile fields.
  Future<void> updateProfile(
    String uid, {
    required String name,
    required String? phone,
  });

  /// PLATFORM scope (superadmin): users with role shopAdmin assigned to
  /// [shopId].
  Stream<List<UserResponse>> watchShopAdmins(String shopId);

  /// PLATFORM scope (superadmin): accounts whose stored email is exactly
  /// [email].
  Future<List<UserResponse>> findUsersByEmail(String email);

  /// PLATFORM scope (superadmin, another user only): role + shop assignment.
  /// [shopId] must be an existing shop for [UserRole.shopAdmin] and is
  /// written as `null` for the other roles.
  Future<void> setRole(String uid, {required UserRole role, String? shopId});

  /// PLATFORM scope (superadmin, another user only).
  Future<void> setActive(String uid, {required bool isActive});
}
