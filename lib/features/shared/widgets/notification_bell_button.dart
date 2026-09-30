import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../providers/notification_providers.dart';

/// App bar bell with the unread count; opens [route].
class NotificationBellButton extends ConsumerWidget {
  const NotificationBellButton({super.key, required this.route});

  final String route;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final unread = ref.watch(unreadNotificationCountProvider);
    return IconButton(
      tooltip: l.notificationsOpen,
      onPressed: () => context.push(route),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > 99 ? '99+' : '$unread'),
        child: Icon(
          unread > 0 ? Icons.notifications : Icons.notifications_outlined,
        ),
      ),
    );
  }
}
