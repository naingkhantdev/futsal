import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_agents/auth_data_agent_impl.dart';
import '../data_agents/user_data_agent_impl.dart';
import '../vos/auth_session.dart';
import 'firebase_auth_session_source.dart';

/// Source of the current [AuthSession].
abstract interface class AuthSessionSource {
  /// Emits the current session and every change to it. Each subscription
  /// resolves from scratch, so re-subscribing (invalidating
  /// `authSessionProvider`) is the "Try again" action.
  Stream<AuthSession> watchSession();
}

final authSessionSourceProvider = Provider<AuthSessionSource>(
  (ref) => FirebaseAuthSessionSource(
    authDataAgent: ref.watch(authDataAgentProvider),
    userDataAgent: ref.watch(userDataAgentProvider),
  ),
);
