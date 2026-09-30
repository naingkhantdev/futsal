import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../l10n/l10n.dart';
import '../theme/app_depth.dart';
import '../theme/theme_context_ext.dart';
import 'coach_mark_tour.dart';

/// Top-level destination names, translated at build time.
enum NavLabel {
  home,
  explore,
  bookings,
  notifications,
  profile,
  dashboard,
  stadiums,
  customers,
  settings,
  shops;

  String text(AppLocalizations l) => switch (this) {
        NavLabel.home => l.navHome,
        NavLabel.explore => l.navExplore,
        NavLabel.bookings => l.navBookings,
        NavLabel.notifications => l.navNotifications,
        NavLabel.profile => l.navProfile,
        NavLabel.dashboard => l.navDashboard,
        NavLabel.stadiums => l.navStadiums,
        NavLabel.customers => l.navCustomers,
        NavLabel.settings => l.navSettings,
        NavLabel.shops => l.navShops,
      };
}

/// One top-level destination: same items, same order on bar and rail.
@immutable
class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount = 0,
  });

  final NavLabel label;
  final IconData icon;
  final IconData selectedIcon;
  final int badgeCount;

  /// Tooltip / spoken label, e.g. "Notifications, 3 new".
  String semanticLabelIn(AppLocalizations l) => badgeCount > 0
      ? l.navBadgeNew(label.text(l), badgeCount)
      : label.text(l);

  NavDestination withBadge(int count) => NavDestination(
        label: label,
        icon: icon,
        selectedIcon: selectedIcon,
        badgeCount: count,
      );
}

/// Role shell (design_system.md §5.9): `NavigationBar` below 600dp,
/// `NavigationRail` at ≥ 600dp (extended at ≥ 1200dp). Each tab keeps its own
/// stack; re-tapping the active tab pops it to its root.
class AdaptiveNavShell extends StatefulWidget {
  const AdaptiveNavShell({
    super.key,
    required this.navigationShell,
    required this.destinations,
  });

  final StatefulNavigationShell navigationShell;
  final List<NavDestination> destinations;

  @override
  State<AdaptiveNavShell> createState() => _AdaptiveNavShellState();
}

class _AdaptiveNavShellState extends State<AdaptiveNavShell> {
  /// On the bottom bar, so app tours can point at its tabs.
  final GlobalKey _barKey = GlobalKey();

  StatefulNavigationShell get navigationShell => widget.navigationShell;
  List<NavDestination> get destinations => widget.destinations;

  void _onSelect(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final depth = context.depth;
    final l = context.l10n;

    if (context.isCompact) {
      return NavBarScope._(
        barKey: _barKey,
        count: destinations.length,
        child: _compact(context, depth, l),
      );
    }
    return _rail(context, depth, l);
  }

  Widget _compact(BuildContext context, AppDepth depth, AppLocalizations l) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        // White bar with a hairline on top; no shadow.
        decoration: BoxDecoration(
          color: depth.base,
          border: Border(top: BorderSide(color: depth.edge)),
        ),
        child: NavigationBar(
          key: _barKey,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onSelect,
          destinations: [
            for (final d in destinations)
              NavigationDestination(
                label: d.label.text(l),
                tooltip: d.semanticLabelIn(l),
                icon: _BadgedIcon(icon: d.icon, count: d.badgeCount),
                selectedIcon:
                    _BadgedIcon(icon: d.selectedIcon, count: d.badgeCount),
              ),
          ],
        ),
      ),
    );
  }

  Widget _rail(BuildContext context, AppDepth depth, AppLocalizations l) {
    final extended = context.isLarge;
    return Scaffold(
      body: Row(
        children: [
          // White rail with a hairline on its right edge.
          DecoratedBox(
            decoration: BoxDecoration(
              color: depth.base,
              border: Border(right: BorderSide(color: depth.edge)),
            ),
            child: SafeArea(
              right: false,
              child: NavigationRail(
                extended: extended,
                labelType: extended
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onSelect,
                destinations: [
                  for (final d in destinations)
                    NavigationRailDestination(
                      label: Text(d.label.text(l)),
                      icon: _BadgedIcon(icon: d.icon, count: d.badgeCount),
                      selectedIcon: _BadgedIcon(
                        icon: d.selectedIcon,
                        count: d.badgeCount,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

/// Lets screens inside a phone-layout shell point an app tour at one of its
/// bottom-bar tabs. Absent on tablets (rail), so tab steps are skipped there.
class NavBarScope extends InheritedWidget {
  const NavBarScope._({
    required this.barKey,
    required this.count,
    required super.child,
  });

  final GlobalKey barKey;
  final int count;

  /// Tab [index] of the nearest bottom bar, or `null` without one.
  static CoachMarkTarget? tabTarget(BuildContext context, int index) {
    final scope = context.getInheritedWidgetOfExactType<NavBarScope>();
    if (scope == null || index < 0 || index >= scope.count) return null;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return () async {
      final box = scope.barKey.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.attached || !box.hasSize) return null;
      // Destinations share the bar width equally; skip the safe-area inset.
      final origin = box.localToGlobal(Offset.zero);
      final width = box.size.width / scope.count;
      final height = box.size.height - bottomInset;
      if (height <= 0) return null;
      return Rect.fromLTWH(origin.dx + width * index, origin.dy, width, height);
    };
  }

  @override
  bool updateShouldNotify(NavBarScope old) =>
      old.barKey != barKey || old.count != count;
}

class _BadgedIcon extends StatelessWidget {
  const _BadgedIcon({required this.icon, required this.count});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > AppConstants.maxBadgeCount
        ? '${AppConstants.maxBadgeCount}+'
        : '$count';
    return Badge(
      isLabelVisible: count > 0,
      label: Text(label),
      child: Icon(icon),
    );
  }
}
