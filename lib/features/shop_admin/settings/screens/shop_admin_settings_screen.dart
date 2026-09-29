import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../shared/widgets/settings_list.dart';

/// `/shop-admin/settings` — SHOP scope: shop profile, blocked times, venues
/// and log out.
class ShopAdminSettingsScreen extends StatelessWidget {
  const ShopAdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.navSettings)),
      body: SettingsList(
        items: [
          SettingsItem(
            icon: Icons.storefront_outlined,
            title: l.settingsShopProfile,
            subtitle: l.settingsShopProfileSub,
            onTap: () => context.push(AppRoutes.shopAdminShopProfile),
          ),
          SettingsItem(
            icon: Icons.block,
            title: l.blockedTimesTitle,
            subtitle: l.blockedTimesSub,
            onTap: () => context.push(AppRoutes.shopAdminBlockedSlots),
          ),
          SettingsItem(
            icon: Icons.person_off_outlined,
            title: l.blacklistTitle,
            subtitle: l.blacklistSubtitle,
            onTap: () => context.push(AppRoutes.shopAdminBlacklist),
          ),
          SettingsItem(
            icon: Icons.stadium_outlined,
            title: l.stadiumsAndCourts,
            onTap: () => context.go(AppRoutes.shopAdminStadiums),
          ),
        ],
      ),
    );
  }
}
