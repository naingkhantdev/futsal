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
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        items: [
          SettingsItem(
            icon: Icons.storefront_outlined,
            title: 'Shop profile',
            subtitle: 'Name, contact and address',
            onTap: () => context.push(AppRoutes.shopAdminShopProfile),
          ),
          SettingsItem(
            icon: Icons.block,
            title: 'Blocked times',
            subtitle: 'Maintenance, events, closures',
            onTap: () => context.push(AppRoutes.shopAdminBlockedSlots),
          ),
          SettingsItem(
            icon: Icons.person_off_outlined,
            title: context.l10n.blacklistTitle,
            subtitle: context.l10n.blacklistSubtitle,
            onTap: () => context.push(AppRoutes.shopAdminBlacklist),
          ),
          SettingsItem(
            icon: Icons.stadium_outlined,
            title: 'Stadiums & courts',
            onTap: () => context.go(AppRoutes.shopAdminStadiums),
          ),
        ],
      ),
    );
  }
}
