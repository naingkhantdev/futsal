import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/vos/announcement_vo.dart';
import '../../console/widgets/console_kit.dart';
import '../../shared/providers/platform_providers.dart';

/// `/superadmin/settings/announcements` — PLATFORM scope: sent
/// announcements, newest first.
class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  static String audienceText(AppLocalizations l, AnnouncementAudience a) =>
      switch (a) {
        AnnouncementAudience.everyone => l.audienceEveryone,
        AnnouncementAudience.customers => l.audienceCustomers,
        AnnouncementAudience.shopAdmins => l.audienceShopAdmins,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
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
      body: AsyncValueView<List<AnnouncementVO>>(
        value: ref.watch(announcementsProvider),
        onRetry: () => ref.invalidate(announcementsProvider),
        data: (sent) => _Sent(sent: sent),
      ),
    );
  }
}

class _Sent extends StatelessWidget {
  const _Sent({required this.sent});

  final List<AnnouncementVO> sent;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    int to(AnnouncementAudience a) => sent.where((x) => x.audience == a).length;
    return ConsoleBody(
      header: ConsoleBand(
        overline: '${l.consolePlatform} · ${l.announcementsTitle}',
        metrics: [
          ConsoleMetric(value: '${sent.length}', label: l.consoleSent),
          for (final a in AnnouncementAudience.values)
            ConsoleMetric(
              value: '${to(a)}',
              label: AnnouncementsScreen.audienceText(l, a),
            ),
        ],
      ),
      children: [
        if (sent.isEmpty)
          EmptyView.inline(
            icon: Icons.campaign_outlined,
            title: l.noAnnouncementsYet,
          )
        else
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
                    ConsoleCellText(
                      AnnouncementsScreen.audienceText(l, a.audience),
                    ),
                    Text(
                      a.createdAt == null
                          ? '—'
                          : DisplayFormat.timeAgo(a.createdAt!, l),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
