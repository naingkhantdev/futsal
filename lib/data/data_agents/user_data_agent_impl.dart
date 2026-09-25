import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/user_fields.dart';
import '../../firebase/firestore/users_collection.dart';
import '../responses/user_response.dart';
import 'user_data_agent.dart';

class UserDataAgentImpl implements UserDataAgent {
  UserDataAgentImpl(this._users);

  final UsersCollection _users;

  @override
  Stream<UserResponse?> watchUser(String uid) =>
      _users.watch(uid).map(_fromSnapshot);

  @override
  Future<UserResponse?> getUser(String uid) async =>
      _fromSnapshot(await _users.get(uid));

  static UserResponse? _fromSnapshot(DocumentSnapshot<JsonMap> snapshot) {
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;
    return UserResponse.fromFirestore(snapshot.id, data);
  }

  @override
  Future<bool> createCustomerProfile(
    String uid, {
    required String email,
    required String name,
    required String? phone,
  }) {
    // Exactly the shape firestore.rules `validSelfCreate` accepts.
    return _users.createIfMissing(uid, {
      UserFields.name: name,
      UserFields.email: email,
      UserFields.phone: phone,
      UserFields.profileImage: null,
      UserFields.role: UserRole.customer.name,
      UserFields.shopId: null,
      UserFields.isActive: true,
    });
  }

  @override
  Future<void> updateProfile(
    String uid, {
    required String name,
    required String? phone,
  }) {
    return _users.update(uid, {
      UserFields.name: name,
      UserFields.phone: phone,
    });
  }

  @override
  Stream<List<UserResponse>> watchShopAdmins(String shopId) {
    return _users
        .watchShopAdmins(shopId, shopAdminRole: UserRole.shopAdmin.name)
        .map(_fromQuery);
  }

  @override
  Future<List<UserResponse>> findUsersByEmail(String email) async =>
      _fromQuery(await _users.findByEmail(email));

  static List<UserResponse> _fromQuery(QuerySnapshot<JsonMap> query) => [
        for (final doc in query.docs)
          UserResponse.fromFirestore(doc.id, doc.data()),
      ];

  @override
  Future<void> setRole(String uid, {required UserRole role, String? shopId}) {
    return _users.update(uid, {
      UserFields.role: role.name,
      UserFields.shopId: role == UserRole.shopAdmin ? shopId : null,
    });
  }

  @override
  Future<void> setActive(String uid, {required bool isActive}) {
    return _users.update(uid, {UserFields.isActive: isActive});
  }
}

final userDataAgentProvider = Provider<UserDataAgent>(
  (ref) => UserDataAgentImpl(ref.watch(usersCollectionProvider)),
);
