import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/domain_enums.dart';
import '../../../core/router/app_routes.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/vos/auth_session.dart';
import '../../../data/vos/notification_vo.dart';
import '../../auth/providers/auth_session_provider.dart';

/// Whose inbox the signed-in user reads: a customer their own (uid), a shop
/// admin their shop's (users/{uid}.shopId). `null` for anyone else. UX only;
/// firestore.rules check the same fields on every read.
final notificationInboxProvider =
    Provider<(NotificationAudience, String)?>((ref) {
  return ref.watch(
    currentAuthSessionProvider.select((s) {
      if (s is! SignedIn || !s.isActive) return null;
      return switch (s.role) {
        UserRole.customer => (NotificationAudience.customer, s.uid),
        UserRole.shopAdmin when (s.shopId ?? '').isNotEmpty =>
          (NotificationAudience.shop, s.shopId!),
        _ => null,
      };
    }),
  );
});

/// CUSTOMER / SHOP scope: the inbox, newest first. Kept alive (not
/// autoDispose) because the nav badge and the in-app banner listen all the
/// time while signed in.
final myNotificationsProvider = StreamProvider<List<NotificationVO>>((ref) {
  final inbox = ref.watch(notificationInboxProvider);
  if (inbox == null) return Stream.value(const <NotificationVO>[]);
  final (audience, recipientId) = inbox;
  return ref
      .watch(notificationRepositoryProvider)
      .watchInbox(audience, recipientId);
});

final unreadNotificationCountProvider = Provider<int>(
  (ref) =>
      ref
          .watch(myNotificationsProvider)
          .valueOrNull
          ?.where((n) => !n.isRead)
          .length ??
      0,
);

/// Where tapping a notification goes: the booking it is about.
String notificationRoute(NotificationVO n) => switch (n.audience) {
      NotificationAudience.customer => AppRoutes.customerBooking(n.bookingId),
      NotificationAudience.shop => AppRoutes.shopAdminBooking(n.bookingId),
    };

/// Marks notifications read. Returns `true` on success; on failure the
/// error is in `state`.
class NotificationsController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> markRead(NotificationVO n) =>
      n.isRead ? Future.value(true) : _mark([n.id]);

  Future<bool> markAllRead() {
    final unread = <String>[
      for (final n in ref.read(myNotificationsProvider).valueOrNull ??
          const <NotificationVO>[])
        if (!n.isRead) n.id,
    ];
    return unread.isEmpty ? Future.value(true) : _mark(unread);
  }

  Future<bool> _mark(List<String> ids) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(notificationRepositoryProvider).markRead(ids),
    );
    return !state.hasError;
  }
}

final notificationsControllerProvider =
    AsyncNotifierProvider.autoDispose<NotificationsController, void>(
  NotificationsController.new,
);
