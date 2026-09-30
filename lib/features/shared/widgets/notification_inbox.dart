import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/domain_enums.dart';
import '../../../core/extensions/async_value_ext.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/l10n_labels.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_tone.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/display_format.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/content_constraint.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../data/vos/notification_vo.dart';
import '../providers/notification_providers.dart';

/// Localized title of a notification (built from its type, so it follows
/// the app language).
String notificationTitle(AppLocalizations l, NotificationVO n) =>
    switch (n.type) {
      NotificationType.bookingRequested => l.notifBookingRequestedTitle,
      NotificationType.bookingCancelled => l.notifBookingCancelledTitle,
      NotificationType.bookingConfirmed => l.notifBookingConfirmedTitle,
      NotificationType.bookingRejected => l.notifBookingRejectedTitle,
    };

/// "Customer · Stadium, Court · Date, time" (customer name only for shops),
/// plus the reason on its own line when there is one.
String notificationBody(AppLocalizations l, NotificationVO n) {
  final when = '${DisplayFormat.dayLabel(n.bookingDate, l)}, '
      '${DisplayFormat.timeRange(n.startMinute, n.endMinute)}';
  final summary = [
    if (n.audience == NotificationAudience.shop && n.customerName.isNotEmpty)
      n.customerName,
    '${n.stadiumName}, ${n.courtName}',
    when,
  ].join(' · ');
  final reason = n.reason;
  return reason == null ? summary : '$summary\n${l.notifReason(reason)}';
}

/// CUSTOMER / SHOP scope inbox body: newest first, unread marked with a dot
/// and bold title; tap marks read and opens the booking.
class NotificationInbox extends ConsumerWidget {
  const NotificationInbox({super.key, required this.emptyMessage});

  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncValueView<List<NotificationVO>>(
      value: ref.watch(myNotificationsProvider),
      onRetry: () => ref.invalidate(myNotificationsProvider),
      isEmpty: (list) => list.isEmpty,
      empty: EmptyView(
        icon: Icons.notifications_none,
        title: l.notificationsEmptyTitle,
        message: emptyMessage,
      ),
      data: (list) => ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        children: [
          ContentConstraint(
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (i, n) in list.indexed) ...[
                    if (i > 0) const Divider(indent: 72),
                    _NotificationTile(item: n),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// App bar action: "Mark all read", disabled when nothing is unread.
class MarkAllReadButton extends ConsumerWidget {
  const MarkAllReadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final unread = ref.watch(unreadNotificationCountProvider);
    final busy = ref.watch(notificationsControllerProvider).isLoading;
    return TextButton(
      onPressed: unread == 0 || busy
          ? null
          : () async {
              final ok = await ref
                  .read(notificationsControllerProvider.notifier)
                  .markAllRead();
              if (ok || !context.mounted) return;
              final error = ref.read(notificationsControllerProvider).appError;
              showAppSnackBar(
                context,
                error?.messageIn(l) ?? l.errUnknown,
                tone: SnackTone.error,
              );
            },
      child: Text(l.markAllRead, semanticsLabel: l.markAllReadAction),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.item});

  final NotificationVO item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, tone) = switch (item.type) {
      NotificationType.bookingRequested => (Icons.event_available, StatusTone.brand),
      NotificationType.bookingConfirmed => (Icons.check_circle, StatusTone.success),
      NotificationType.bookingCancelled => (Icons.event_busy, StatusTone.neutral),
      NotificationType.bookingRejected => (Icons.cancel_outlined, StatusTone.neutral),
    };
    final colors = tone.colorsFor(context);
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
    final title = notificationTitle(l, item);
    final body = notificationBody(l, item);
    final at = item.createdAt;
    return Semantics(
      button: true,
      label: '${item.isRead ? '' : '${l.unreadPrefix} '}$title. $body',
      excludeSemantics: true,
      child: InkWell(
        onTap: () => _open(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.background,
                child:
                    Icon(icon, size: AppSizes.iconMd, color: colors.foreground),
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
                            title,
                            style: styles.titleSmall?.copyWith(
                              fontWeight: item.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                            ),
                          ),
                        ),
                        if (at != null)
                          Text(
                            DisplayFormat.timeAgo(at, l),
                            style: styles.labelSmall?.copyWith(color: muted),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      body,
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
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref) {
    // Fire and forget: opening the booking must not wait on the network.
    ref.read(notificationsControllerProvider.notifier).markRead(item);
    context.push(notificationRoute(item));
  }
}
