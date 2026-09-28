import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/superadmin/settings/announcements` — PLATFORM scope: sent
/// announcements, newest first. PREVIEW: sample data until Phase 12.
class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.superadminAnnouncementNew),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('New'),
      ),
      body: PreviewBody(
        bottomPadding: 96,
        children: [
          for (final a in DemoData.announcements) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusBadge(
                        tone: StatusTone.brand,
                        icon: Icons.group_outlined,
                        label: a.audience.label,
                        semanticsPrefix: 'Sent to',
                      ),
                      const Spacer(),
                      Text(
                        DisplayFormat.timeAgo(a.sentAt),
                        style: styles.labelSmall?.copyWith(color: muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(a.title, style: styles.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(a.body, style: styles.bodyMedium?.copyWith(color: muted)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
