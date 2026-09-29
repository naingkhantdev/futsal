import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
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
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.announcementsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.superadminAnnouncementNew),
        icon: const Icon(Icons.edit_outlined),
        label: Text(l.newShort),
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
                        label: switch (a.audience) {
                          DemoAudience.everyone => l.audienceEveryone,
                          DemoAudience.customers => l.audienceCustomers,
                          DemoAudience.shopAdmins => l.audienceShopAdmins,
                        },
                        semanticsPrefix: l.sentToPrefix,
                      ),
                      const Spacer(),
                      Text(
                        DisplayFormat.timeAgo(a.sentAt, l),
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
