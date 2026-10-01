import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/nav_destinations.dart';
import '../../../../core/router/role_nav_shell.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../auth/widgets/sign_out_button.dart';
import '../../../customer/profile/providers/current_user_profile_provider.dart';

/// PLATFORM scope. Superadmin shell: a navy side menu instead of the bottom
/// bar. Below 840dp it is a drawer opened by [SuperadminMenuButton]; at
/// ≥ 840dp it stays open as a sidebar. Branch order follows
/// `NavDestinations.superadmin`.
class SuperadminShell extends StatefulWidget {
  const SuperadminShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<SuperadminShell> createState() => _SuperadminShellState();
}

class _SuperadminShellState extends State<SuperadminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final permanent = context.isExpanded;
    final panel = _SuperadminNavPanel(
      navigationShell: widget.navigationShell,
      inDrawer: !permanent,
    );
    return _SuperadminShellScope(
      openMenu:
          permanent ? null : () => _scaffoldKey.currentState?.openDrawer(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: permanent
            ? null
            : Drawer(
                width: AppSizes.adminSidebarWidth,
                shape: const RoundedRectangleBorder(),
                child: panel,
              ),
        // Always a Row so the branch stack survives crossing the breakpoint.
        body: Row(
          children: [
            if (permanent)
              SizedBox(width: AppSizes.adminSidebarWidth, child: panel),
            Expanded(child: widget.navigationShell),
          ],
        ),
      ),
    );
  }
}

class _SuperadminShellScope extends InheritedWidget {
  const _SuperadminShellScope({required this.openMenu, required super.child});

  /// `null` while the sidebar is permanently visible.
  final VoidCallback? openMenu;

  @override
  bool updateShouldNotify(_SuperadminShellScope old) =>
      (old.openMenu == null) != (openMenu == null);
}

/// App bar "☰" for the superadmin's top-level screens. Renders nothing when
/// the sidebar is already visible, so use it via [maybeOf] as `leading`.
class SuperadminMenuButton extends StatelessWidget {
  const SuperadminMenuButton._(this.onPressed);

  final VoidCallback onPressed;

  /// The menu button, or `null` (wide layout / outside the shell).
  static Widget? maybeOf(BuildContext context) {
    final open = context
        .dependOnInheritedWidgetOfExactType<_SuperadminShellScope>()
        ?.openMenu;
    return open == null ? null : SuperadminMenuButton._(open);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      onPressed: onPressed,
    );
  }
}

/// The navy menu: brand + signed-in admin, sections, sign out.
class _SuperadminNavPanel extends ConsumerWidget {
  const _SuperadminNavPanel({
    required this.navigationShell,
    required this.inDrawer,
  });

  final StatefulNavigationShell navigationShell;
  final bool inDrawer;

  void _closeDrawer(BuildContext context) {
    if (inDrawer) Navigator.of(context).pop();
  }

  void _goBranch(BuildContext context, int index) {
    _closeDrawer(context);
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final g = context.gradients;
    final badgeIndex = NavDestinations.badgeIndexFor(UserRole.superadmin);
    final badgeCount = ref.watch(navBadgeCountProvider(UserRole.superadmin));
    const destinations = NavDestinations.superadmin;

    return DecoratedBox(
      decoration: BoxDecoration(gradient: g.hero),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _PanelHeader(),
            Divider(height: 1, color: g.onHero.withOpacity(0.12)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.lg,
                ),
                children: [
                  for (final (i, d) in destinations.indexed)
                    _PanelItem(
                      icon: d.icon,
                      selectedIcon: d.selectedIcon,
                      label: d.label.text(l),
                      badgeCount: i == badgeIndex ? badgeCount : 0,
                      selected: i == navigationShell.currentIndex,
                      onTap: () => _goBranch(context, i),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  _PanelItem(
                    icon: Icons.campaign_outlined,
                    selectedIcon: Icons.campaign,
                    label: l.announcementsTitle,
                    selected: false,
                    onTap: () {
                      _closeDrawer(context);
                      context.push(AppRoutes.superadminAnnouncements);
                    },
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: g.onHero.withOpacity(0.12)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _PanelItem(
                icon: Icons.logout,
                selectedIcon: Icons.logout,
                label: l.logOut,
                selected: false,
                onTap: () => confirmAndSignOut(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelHeader extends ConsumerWidget {
  const _PanelHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final g = context.gradients;
    final text = context.textStyles;
    final user = ref.watch(currentUserProfileProvider).valueOrNull;
    final name = user != null && user.hasName ? user.name : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSizes.railLogo + AppSpacing.sm,
                height: AppSizes.railLogo + AppSpacing.sm,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: g.gold.withOpacity(0.6)),
                ),
                child: Icon(Icons.sports_soccer, color: g.gold),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium?.copyWith(
                        color: g.onHero,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      UserRole.superadmin.labelIn(l).toUpperCase(),
                      style: AppTypography.overline(text.labelSmall!)
                          .copyWith(color: g.gold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (user != null) ...[
            const SizedBox(height: AppSpacing.lg),
            if (name != null)
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodyMedium?.copyWith(
                  color: g.onHero,
                  fontWeight: FontWeight.w600,
                ),
              ),
            Text(
              user.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall?.copyWith(color: g.onHeroMuted),
            ),
          ],
        ],
      ),
    );
  }
}

/// One menu row. Selected = gold bar + filled icon + bold label + tint, so
/// the state never relies on color alone.
class _PanelItem extends StatelessWidget {
  const _PanelItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final g = context.gradients;
    final fg = selected ? g.onHero : g.onHeroMuted;
    final badge = badgeCount > AppConstants.maxBadgeCount
        ? '${AppConstants.maxBadgeCount}+'
        : '$badgeCount';

    return Semantics(
      selected: selected,
      button: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.mdAll,
            child: AnimatedContainer(
              duration: AppMotion.state,
              constraints:
                  const BoxConstraints(minHeight: AppSizes.minTouchTarget),
              decoration: BoxDecoration(
                color:
                    selected ? g.onHero.withOpacity(0.08) : Colors.transparent,
                borderRadius: AppRadius.mdAll,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: AppMotion.state,
                    width: AppSizes.navIndicatorWidth,
                    height: AppSizes.iconLg,
                    decoration: BoxDecoration(
                      color: selected ? g.gold : Colors.transparent,
                      borderRadius: AppRadius.fullAll,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Icon(
                    selected ? selectedIcon : icon,
                    size: AppSizes.iconLg,
                    color: selected ? g.gold : fg,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Text(
                      label,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: fg,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (badgeCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: Badge(
                        label: Text(badge),
                        backgroundColor: g.gold,
                        textColor: _onGold(g),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Navy text on the gold badge.
  static Color _onGold(AppGradients g) => g.hero.colors.last;
}
