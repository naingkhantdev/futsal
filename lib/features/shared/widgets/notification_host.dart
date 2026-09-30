import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/domain_enums.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/push_repository.dart';
import '../../../data/vos/auth_session.dart';
import '../../../data/vos/notification_vo.dart';
import '../../../data/vos/push_message_vo.dart';
import '../../auth/providers/auth_session_provider.dart';
import '../providers/notification_providers.dart';
import 'notification_inbox.dart';

/// App-wide notification plumbing, mounted once in `MaterialApp.builder`
/// (below the ScaffoldMessenger, outside the router's Navigator):
///
/// - FCM: asks permission and subscribes to the role's topics on sign-in,
///   drops them on sign-out; shows foreground pushes as a snackbar; opens
///   the push's `route` (or the inbox) when a push is tapped.
/// - In-app: a snackbar when a new unread notification arrives while the
///   app is open (the Spark-plan stand-in for booking pushes).
///
/// Every failure here is swallowed: notifications must never break the app.
class NotificationHost extends ConsumerStatefulWidget {
  const NotificationHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationHost> createState() => _NotificationHostState();
}

class _NotificationHostState extends ConsumerState<NotificationHost> {
  final List<StreamSubscription<PushMessageVO>> _subscriptions = [];

  /// (role, uid, shopId) the push topics were set up for.
  (UserRole, String, String?)? _pushUser;

  /// Push tapped before the session resolved (cold start); opened once the
  /// user is signed in.
  PushMessageVO? _pendingOpen;

  /// Inbox the [_seen] ids belong to; a new inbox starts a new baseline so
  /// existing notifications don't pop up after sign-in.
  (NotificationAudience, String)? _inbox;
  Set<String>? _seen;

  @override
  void initState() {
    super.initState();
    final push = ref.read(pushRepositoryProvider);
    _subscriptions
      ..add(push.foregroundMessages.listen(_showPush, onError: _ignore))
      ..add(push.openedMessages.listen(_openPush, onError: _ignore));
    push.initialMessage().then((m) {
      if (m != null) _openPush(m);
    }, onError: _ignore);
    ref.listenManual(
      currentAuthSessionProvider,
      (_, session) => _onSession(session),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    super.dispose();
  }

  static void _ignore(Object error) =>
      debugPrint('Push notifications: $error');

  void _onSession(AuthSession session) {
    final push = ref.read(pushRepositoryProvider);
    if (session is SignedIn && session.isActive) {
      final user = (session.role, session.uid, session.shopId);
      if (user != _pushUser) {
        _pushUser = user;
        push
            .enableFor(role: session.role, shopId: session.shopId)
            .catchError(_ignore);
      }
      final pending = _pendingOpen;
      if (pending != null) {
        _pendingOpen = null;
        // Let the router finish its sign-in redirect first.
        WidgetsBinding.instance.addPostFrameCallback((_) => _openPush(pending));
      }
    } else if (session is SignedOut && _pushUser != null) {
      _pushUser = null;
      push.disable().catchError(_ignore);
    }
  }

  // --- FCM ------------------------------------------------------------------

  void _showPush(PushMessageVO m) {
    if (!mounted || !m.hasText) return;
    final route = m.route;
    showAppSnackBar(
      context,
      [m.title, m.body].whereType<String>().where((t) => t.isNotEmpty).join('\n'),
      actionLabel: route == null ? null : context.l10n.notificationView,
      onAction: route == null ? null : () => _go(route),
    );
  }

  void _openPush(PushMessageVO m) {
    final session = ref.read(currentAuthSessionProvider);
    if (session is! SignedIn) {
      _pendingOpen = m;
      return;
    }
    final route = m.route ??
        switch (session.role) {
          UserRole.customer => AppRoutes.customerNotifications,
          UserRole.shopAdmin => AppRoutes.shopAdminNotifications,
          UserRole.superadmin => null,
        };
    if (route != null) _go(route);
  }

  void _go(String route) {
    final router = ref.read(appRouterProvider);
    // Tabs are switched with go(); anything else is pushed on top.
    if (route == AppRoutes.customerNotifications) {
      router.go(route);
    } else {
      router.push(route);
    }
  }

  // --- In-app ---------------------------------------------------------------

  void _onInbox(AsyncValue<List<NotificationVO>> next) {
    // Skip loading states: after an inbox switch they still carry the
    // previous user's list.
    if (next.isLoading || !next.hasValue) return;
    final list = next.requireValue;
    final inbox = ref.read(notificationInboxProvider);
    final ids = {for (final n in list) n.id};
    final seen = _seen;
    if (inbox != _inbox || seen == null) {
      _inbox = inbox;
      _seen = ids;
      return;
    }
    final fresh = [
      for (final n in list)
        if (!n.isRead && !seen.contains(n.id)) n,
    ];
    _seen = {...seen, ...ids};
    if (fresh.isEmpty || !mounted) return;
    final n = fresh.first;
    final l = context.l10n;
    showAppSnackBar(
      context,
      '${notificationTitle(l, n)}\n${notificationBody(l, n)}',
      actionLabel: l.notificationView,
      onAction: () {
        // Straight to the repository: the autoDispose controller would be
        // disposed mid-call with nobody watching it here.
        ref
            .read(notificationRepositoryProvider)
            .markRead([n.id]).catchError(_ignore);
        _go(notificationRoute(n));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(myNotificationsProvider, (_, next) => _onInbox(next));
    return widget.child;
  }
}
