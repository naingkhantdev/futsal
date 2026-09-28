import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/customer/notifications` — CUSTOMER scope: own notifications, newest
/// first, unread marked with a dot. PREVIEW: sample data until Phase 12.
class CustomerNotificationsScreen extends StatelessWidget {
  const CustomerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = DemoData.notifications;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.navNotifications),
        actions: [
          TextButton(
            onPressed: () => showPreviewOnly(context, l.markAllReadAction),
            child: Text(l.markAllRead),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: PreviewBody(
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (i, n) in items.indexed) ...[
                  if (i > 0) const Divider(indent: 72),
                  _NotificationTile(item: n),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final DemoNotification item;

  @override
  Widget build(BuildContext context) {
    final (icon, tone) = switch (item.kind) {
      DemoNotificationKind.booking => (Icons.check_circle, StatusTone.success),
      DemoNotificationKind.reminder => (Icons.alarm, StatusTone.info),
      DemoNotificationKind.cancelled => (Icons.event_busy, StatusTone.neutral),
      DemoNotificationKind.announcement => (Icons.campaign_outlined, StatusTone.brand),
    };
    final colors = tone.colorsFor(context);
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
    return Semantics(
      label: '${item.isRead ? '' : '${l.unreadPrefix} '}'
          '${item.title}. ${item.body}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colors.background,
              child: Icon(icon, size: AppSizes.iconMd, color: colors.foreground),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: styles.titleSmall?.copyWith(
                            fontWeight:
                                item.isRead ? FontWeight.w600 : FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        DisplayFormat.timeAgo(item.at, l),
                        style: styles.labelSmall?.copyWith(color: muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.body,
                    style: styles.bodyMedium?.copyWith(color: muted),
                  ),
                ],
              ),
            ),
            if (!item.isRead) ...[
              const SizedBox(width: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: context.colors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
