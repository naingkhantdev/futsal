import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../theme/app_depth.dart';
import '../theme/theme_context_ext.dart';

/// One top-level destination: same items, same order on bar and rail.
@immutable
class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount = 0,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int badgeCount;

  /// Tooltip / spoken label, e.g. "Notifications, 3 new".
  String get semanticLabel =>
      badgeCount > 0 ? '$label, $badgeCount new' : label;

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
class AdaptiveNavShell extends StatelessWidget {
  const AdaptiveNavShell({
    super.key,
    required this.navigationShell,
    required this.destinations,
  });

  final StatefulNavigationShell navigationShell;
  final List<NavDestination> destinations;

  void _onSelect(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final depth = context.depth;

    if (context.isCompact) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: DecoratedBox(
          // Soft upward lift instead of a divider line.
          decoration: BoxDecoration(
            color: depth.base,
            boxShadow: [
              BoxShadow(
                color: depth.shade.withOpacity(0.35),
                offset: Offset(0, -DepthLevel.low.distance),
                blurRadius: DepthLevel.high.blur,
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onSelect,
            destinations: [
              for (final d in destinations)
                NavigationDestination(
                  label: d.label,
                  tooltip: d.semanticLabel,
                  icon: _BadgedIcon(icon: d.icon, count: d.badgeCount),
                  selectedIcon:
                      _BadgedIcon(icon: d.selectedIcon, count: d.badgeCount),
                ),
            ],
          ),
        ),
      );
    }

    final extended = context.isLarge;
    return Scaffold(
      body: Row(
        children: [
          // Borderless rail on the shared surface: whitespace separates it.
          ColoredBox(
            color: depth.base,
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
                      label: Text(d.label),
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
