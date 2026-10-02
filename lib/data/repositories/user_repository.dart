import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../data_agents/auth_data_agent_impl.dart';
import '../data_agents/user_data_agent_impl.dart';
import '../vos/user_vo.dart';
import 'user_repository_impl.dart';

/// PLATFORM scope: superadmin user management. Every method throws only
/// `AppException`.
///
/// Shop admins are onboarded without the Admin SDK (Spark plan): the person
/// registers a normal customer account, then the superadmin finds it by
/// email ([findUserByEmail]) and assigns it to a shop ([setUserRole]).
///
/// firestore.rules are the real guard: only an active superadmin may write
/// these fields, only on OTHER users, a shop admin needs an existing shop,
/// customers/superadmins get `shopId = null`. Superadmin bootstrap: set
/// `users/{uid}.role = 'superadmin'` in the Firebase console.
abstract interface class UserRepository {
  /// Every customer account, by name.
  Stream<List<UserVO>> watchCustomers();

  /// One account; `null` while the doc does not exist.
  Stream<UserVO?> watchUser(String uid);

  /// Admins currently assigned to [shopId].
  Stream<List<UserVO>> watchShopAdmins(String shopId);

  /// The account registered with [email] (case-insensitive for the usual
  /// lower-case Auth emails), or `null` when there is none.
  Future<UserVO?> findUserByEmail(String email);

  /// Sets [uid]'s role. [shopId] is required for [UserRole.shopAdmin]
  /// (must be an existing shop) and ignored (written as null) otherwise.
  /// Changing your own role → `PermissionDeniedException`.
  Future<void> setUserRole(String uid, UserRole role, {String? shopId});

  /// Activates / deactivates [uid]. The user is blocked in the app and by
  /// the rules immediately; their Firebase Auth account stays enabled (Spark
  /// plan: no Admin SDK). Deactivating yourself → `PermissionDeniedException`.
  Future<void> setUserActive(String uid, {required bool isActive});
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(
    authDataAgent: ref.watch(authDataAgentProvider),
    userDataAgent: ref.watch(userDataAgentProvider),
  ),
);
