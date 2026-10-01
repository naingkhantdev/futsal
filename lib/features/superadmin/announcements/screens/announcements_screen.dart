import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../data/demo/demo_data.dart';
import '../../console/widgets/console_kit.dart';

/// `/superadmin/settings/announcements` — PLATFORM scope: sent
/// announcements, newest first. PREVIEW: sample data until Phase 12.
class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  static String audienceText(AppLocalizations l, DemoAudience a) => switch (a) {
        DemoAudience.everyone => l.audienceEveryone,
        DemoAudience.customers => l.audienceCustomers,
        DemoAudience.shopAdmins => l.audienceShopAdmins,
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sent = DemoData.announcements;
    int to(DemoAudience a) => sent.where((x) => x.audience == a).length;

    return Scaffold(
      appBar: ConsoleAppBar(
        title: l.announcementsTitle,
        actions: [
          ConsoleBarAction(
            icon: Icons.edit_outlined,
            label: l.newAnnouncementTitle,
            onPressed: () => context.push(AppRoutes.superadminAnnouncementNew),
          ),
        ],
      ),
      body: ConsoleBody(
        demo: true,
        header: ConsoleBand(
          overline: '${l.consolePlatform} · ${l.announcementsTitle}',
          metrics: [
            ConsoleMetric(value: '${sent.length}', label: l.consoleSent),
            for (final a in DemoAudience.values)
              ConsoleMetric(value: '${to(a)}', label: audienceText(l, a)),
          ],
        ),
        children: [
          ConsoleTable(
            columns: [
              ConsoleColumn(l.messageLabel, flex: 6),
              ConsoleColumn(l.audienceLabel, flex: 2, compact: false),
              ConsoleColumn(l.consoleSent, flex: 2, alignEnd: true),
            ],
            rows: [
              for (final a in sent)
                ConsoleRow(
                  cells: [
                    ConsoleCellText(a.title, strong: true, secondary: a.body),
                    ConsoleCellText(audienceText(l, a.audience)),
                    Text(
                      DisplayFormat.timeAgo(a.sentAt, l),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
