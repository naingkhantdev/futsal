import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/language_picker.dart';
import '../../../auth/widgets/sign_out_button.dart';
import '../../../customer/profile/providers/current_user_profile_provider.dart';
import '../../console/widgets/console_kit.dart';

/// `/superadmin/settings` — PLATFORM scope: announcements, shop onboarding,
/// language and log out.
class SuperadminSettingsScreen extends ConsumerWidget {
  const SuperadminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProfileProvider).valueOrNull;

    return Scaffold(
      appBar: ConsoleAppBar(title: l.navSettings),
      body: ConsoleBody(
        width: ContentWidth.form,
        header: ConsoleBand(
          overline: l.consolePlatform,
          title: l.navSettings,
          subtitle: user?.email,
          width: ContentWidth.form,
        ),
        children: [
          ConsolePanel(
            title: l.consolePlatform,
            child: Column(
              children: [
                ConsoleLinkRow(
                  icon: Icons.campaign_outlined,
                  label: l.announcementsTitle,
                  detail: l.announcementsSub,
                  onTap: () => context.push(AppRoutes.superadminAnnouncements),
                ),
                ConsoleLinkRow(
                  icon: Icons.pending_actions_outlined,
                  label: l.shopsPendingReview,
                  last: true,
                  onTap: () => context.go(
                    Uri(
                      path: AppRoutes.superadminShops,
                      queryParameters: {
                        AppRoutes.tabQuery: AppRoutes.tabOnboarding,
                      },
                    ).toString(),
                  ),
                ),
              ],
            ),
          ),
          consoleGap,
          ConsolePanel(
            title: l.consolePreferences,
            child: const LanguageTile(),
          ),
          consoleGap,
          ConsolePanel(
            title: l.accountPrefix,
            child: ConsoleLinkRow(
              icon: Icons.logout,
              label: l.logOut,
              destructive: true,
              last: true,
              onTap: () => confirmAndSignOut(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}
