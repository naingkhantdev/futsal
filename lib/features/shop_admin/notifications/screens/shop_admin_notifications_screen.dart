import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/notification_inbox.dart';

/// `/shop-admin/notifications` — SHOP scope: the shop's inbox (new booking
/// requests, customer cancellations), shared by all admins of the shop.
/// Tap opens the booking.
class ShopAdminNotificationsScreen extends StatelessWidget {
  const ShopAdminNotificationsScreen({super.key});

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
      body: NotificationInbox(emptyMessage: l.notificationsEmptyMessageShop),
    );
  }
}
