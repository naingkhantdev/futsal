import '../../core/constants/domain_enums.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../data_agents/auth_data_agent.dart';
import '../data_agents/user_data_agent.dart';
import '../responses/user_response.dart';
import '../vos/user_vo.dart';
import 'mappers/user_mapper.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required AuthDataAgent authDataAgent,
    required UserDataAgent userDataAgent,
  })  : _auth = authDataAgent,
        _users = userDataAgent;

  final AuthDataAgent _auth;
  final UserDataAgent _users;

  @override
  Stream<List<UserVO>> watchCustomers() {
    return mapStreamErrors(
      _users.watchUsersByRole(UserRole.customer).map(_byName),
    );
  }

  @override
  Stream<UserVO?> watchUser(String uid) {
    return mapStreamErrors(_users.watchUser(uid).map((r) => r?.toVO()));
  }

  @override
  Stream<List<UserVO>> watchShopAdmins(String shopId) {
    return mapStreamErrors(_users.watchShopAdmins(shopId).map(_byName));
  }

  static List<UserVO> _byName(List<UserResponse> list) =>
      [for (final r in list) r.toVO()]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  @override
  Future<UserVO?> findUserByEmail(String email) {
    return guardAppException(() async {
      final typed = email.trim();
      if (typed.isEmpty) return null;
      // Auth stores emails lower-cased; fall back to the exact spelling.
      final lower = typed.toLowerCase();
      var found = await _users.findUsersByEmail(lower);
      if (found.isEmpty && lower != typed) {
        found = await _users.findUsersByEmail(typed);
      }
      return found.isEmpty ? null : found.first.toVO();
    });
  }

  @override
  Future<void> setUserRole(String uid, UserRole role, {String? shopId}) {
    return guardAppException(() async {
      _rejectSelf(uid);
      final shop = shopId?.trim() ?? '';
      if (role == UserRole.shopAdmin && shop.isEmpty) {
        // The rules would refuse it too; fail before the round trip.
        throw const PermissionDeniedException();
      }
      await _users.setRole(
        uid,
        role: role,
        shopId: role == UserRole.shopAdmin ? shop : null,
      );
    });
  }

  @override
  Future<void> setUserActive(String uid, {required bool isActive}) {
    return guardAppException(() async {
      _rejectSelf(uid);
      await _users.setActive(uid, isActive: isActive);
    });
  }

  /// Mirrors the rule that a superadmin cannot change their own role or
  /// status (prevents locking the platform out).
  void _rejectSelf(String uid) {
    final me = _auth.currentUser;
    if (me == null) throw const AuthenticationException();
    if (me.uid == uid) throw const PermissionDeniedException();
  }
}
