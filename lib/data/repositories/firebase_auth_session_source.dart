import 'dart:async';

import '../../core/constants/app_constants.dart';
import '../../core/constants/domain_enums.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/firebase_error_mapper.dart';
import '../data_agents/auth_data_agent.dart';
import '../data_agents/user_data_agent.dart';
import '../responses/auth_user_response.dart';
import '../responses/user_response.dart';
import '../vos/auth_session.dart';
import 'auth_session_source.dart';

/// Resolves [AuthSession] from Firebase Auth + the `users/{uid}` stream.
///
/// - role / shopId / isActive: ONLY from `users/{uid}` — the same fields
///   firestore.rules authorize against (Spark plan: no custom claims).
///   Changes made by a superadmin reach the session live.
/// - Doc missing → [SessionIncomplete]. After [repairDelay] (so an ongoing
///   registration can write it first) the customer doc is re-created; the
///   rules only accept `{role: customer, shopId: null, isActive: true}`.
///   If that fails → [SessionError] ([SessionFailure.setupFailed]).
/// - Unknown or missing role → [SessionError]
///   ([SessionFailure.unrecognizedRole]). Never falls back to a default role.
/// - Nothing resolved within [resolveTimeout] → [SessionError]
///   ([SessionFailure.timeout]).
class FirebaseAuthSessionSource implements AuthSessionSource {
  FirebaseAuthSessionSource({
    required AuthDataAgent authDataAgent,
    required UserDataAgent userDataAgent,
    this.resolveTimeout = AppConstants.sessionResolveTimeout,
    this.repairDelay = AppConstants.profileRepairDelay,
  })  : _auth = authDataAgent,
        _users = userDataAgent;

  final AuthDataAgent _auth;
  final UserDataAgent _users;
  final Duration resolveTimeout;
  final Duration repairDelay;

  @override
  Stream<AuthSession> watchSession() => _SessionResolver(
        auth: _auth,
        users: _users,
        resolveTimeout: resolveTimeout,
        repairDelay: repairDelay,
      ).stream;
}

/// One resolver per subscription; all state is per signed-in uid.
class _SessionResolver {
  _SessionResolver({
    required AuthDataAgent auth,
    required UserDataAgent users,
    required Duration resolveTimeout,
    required Duration repairDelay,
  })  : _auth = auth,
        _users = users,
        _resolveTimeout = resolveTimeout,
        _repairDelay = repairDelay {
    _controller = StreamController<AuthSession>(
      onListen: _start,
      onCancel: _stop,
    );
  }

  final AuthDataAgent _auth;
  final UserDataAgent _users;
  final Duration _resolveTimeout;
  final Duration _repairDelay;
  late final StreamController<AuthSession> _controller;

  Stream<AuthSession> get stream => _controller.stream;

  StreamSubscription<AuthUserResponse?>? _authSub;
  StreamSubscription<UserResponse?>? _profileSub;
  AuthSession? _last;

  // --- Per-uid state (cleared by _resetUser) -------------------------------
  AuthUserResponse? _user;
  Timer? _timeoutTimer;
  Timer? _repairTimer;

  /// One automatic repair per uid (retry = re-subscribe from splash).
  bool _repairAttempted = false;

  void _start() {
    _authSub = _auth.watchAuthUser().listen(_onAuthUser, onError: _onError);
  }

  Future<void> _stop() async {
    _resetUser();
    await _authSub?.cancel();
    _authSub = null;
  }

  void _onAuthUser(AuthUserResponse? user) {
    if (user == null) {
      _resetUser();
      _emit(const AuthSession.signedOut());
      return;
    }
    if (user.uid == _user?.uid) {
      _user = user; // e.g. display name updated
      return;
    }
    _resetUser();
    _user = user;
    _timeoutTimer = Timer(_resolveTimeout, _onTimeout);
    _profileSub =
        _users.watchUser(user.uid).listen(_onProfile, onError: _onError);
  }

  void _resetUser() {
    _profileSub?.cancel();
    _profileSub = null;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    _repairTimer?.cancel();
    _repairTimer = null;
    _user = null;
    _repairAttempted = false;
  }

  void _onProfile(UserResponse? profile) {
    final uid = _user?.uid;
    if (uid == null) return;

    if (profile == null) {
      // Auth account without users/{uid}: registration interrupted (or
      // still writing it). Wait briefly, then re-create the customer doc.
      _emit(AuthSession.incomplete(uid: uid));
      if (!_repairAttempted && _repairTimer == null) {
        _repairTimer = Timer(_repairDelay, () => _repair(uid));
      }
      return;
    }

    _repairTimer?.cancel();
    _repairTimer = null;
    _cancelTimeout();

    final role = UserRole.tryParse(profile.role);
    if (role == null) {
      // PLATFORM: unknown / missing role → not authorized. Never a default.
      _emit(AuthSession.error(
        failure: SessionFailure.unrecognizedRole,
        error: const UnauthorizedRoleException(),
        uid: uid,
      ));
      return;
    }

    _emit(AuthSession.signedIn(
      uid: uid,
      role: role,
      isActive: profile.isActive,
      // SHOP scope only for shop admins; a stray shopId is ignored.
      shopId: role == UserRole.shopAdmin ? profile.shopId : null,
    ));
  }

  Future<void> _repair(String uid) async {
    _repairTimer = null;
    _repairAttempted = true;
    final user = _user;
    if (user == null || user.uid != uid) return;
    try {
      await _users.createCustomerProfile(
        uid,
        email: user.email ?? '',
        // Rules accept '' (Profile then asks for a name) or 2..80 chars.
        name: _repairName(user.displayName),
        phone: null,
      );
      // Success: the profile stream emits the new doc → signed in.
    } catch (error, stackTrace) {
      if (_user?.uid != uid) return;
      _cancelTimeout();
      _emit(AuthSession.error(
        failure: SessionFailure.setupFailed,
        error: FirebaseErrorMapper.map(error, stackTrace),
        uid: uid,
      ));
    }
  }

  static String _repairName(String? displayName) {
    final name = displayName?.trim() ?? '';
    return name.length >= 2 && name.length <= 80 ? name : '';
  }

  void _onTimeout() {
    _timeoutTimer = null;
    if (_last is SignedIn || _last is SessionError) return;
    _emit(AuthSession.error(
      failure: SessionFailure.timeout,
      error: const AccountSetupTimeoutException(),
      uid: _user?.uid,
    ));
  }

  void _onError(Object error, [StackTrace? stackTrace]) {
    final mapped = FirebaseErrorMapper.map(error, stackTrace);
    _cancelTimeout();
    _emit(AuthSession.error(
      failure: mapped is AccountDisabledException
          ? SessionFailure.accountDisabled
          : SessionFailure.loadFailed,
      error: mapped,
      uid: _user?.uid,
    ));
  }

  void _cancelTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  void _emit(AuthSession session) {
    if (_controller.isClosed || session == _last) return;
    _last = session;
    _controller.add(session);
  }
}
