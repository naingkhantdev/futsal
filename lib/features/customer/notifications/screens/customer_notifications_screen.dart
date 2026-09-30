import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/notification_inbox.dart';

/// `/customer/notifications` — CUSTOMER scope: own notifications (booking
/// confirmed / declined), newest first, unread marked with a dot. Tap opens
/// the booking.
class CustomerNotificationsScreen extends StatelessWidget {
  const CustomerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.navNotifications),
        actions: const [
          TourHelpButton(),
          TourAnchor(
            id: TourIds.markAll,
            child: MarkAllReadButton(),
          ),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: NotificationInbox(emptyMessage: l.notificationsEmptyMessage),
    );
  }
}
