import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../shared/widgets/settings_list.dart';

/// `/superadmin/settings` — PLATFORM scope: announcements, shop onboarding
/// and log out.
class SuperadminSettingsScreen extends StatelessWidget {
  const SuperadminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        items: [
          SettingsItem(
            icon: Icons.campaign_outlined,
            title: 'Announcements',
            subtitle: 'Messages to customers and shops',
            onTap: () => context.push(AppRoutes.superadminAnnouncements),
          ),
          SettingsItem(
            icon: Icons.pending_actions_outlined,
            title: 'Shops pending review',
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
