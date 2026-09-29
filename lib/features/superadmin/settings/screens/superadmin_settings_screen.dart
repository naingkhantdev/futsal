import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../shared/widgets/settings_list.dart';

/// `/superadmin/settings` — PLATFORM scope: announcements, shop onboarding
/// and log out.
class SuperadminSettingsScreen extends StatelessWidget {
  const SuperadminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.navSettings)),
      body: SettingsList(
        items: [
          SettingsItem(
            icon: Icons.campaign_outlined,
            title: l.announcementsTitle,
            subtitle: l.announcementsSub,
            onTap: () => context.push(AppRoutes.superadminAnnouncements),
          ),
          SettingsItem(
            icon: Icons.pending_actions_outlined,
            title: l.shopsPendingReview,
            onTap: () => context.go(
              Uri(
                path: AppRoutes.superadminShops,
                queryParameters: {AppRoutes.tabQuery: AppRoutes.tabOnboarding},
              ).toString(),
            ),
          ),
        ],
      ),
    );
  }
}
