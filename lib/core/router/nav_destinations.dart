import 'package:flutter/material.dart';

import '../constants/domain_enums.dart';
import '../widgets/adaptive_nav_shell.dart';

/// Per-role top-level destinations (design_system.md §8.1). Order must match
/// the branch order of the role's `StatefulShellRoute` in app_router.dart.
abstract final class NavDestinations {
  static const List<NavDestination> customer = [
    NavDestination(label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home),
    NavDestination(label: 'Explore', icon: Icons.explore_outlined, selectedIcon: Icons.explore),
    NavDestination(label: 'Bookings', icon: Icons.calendar_month_outlined, selectedIcon: Icons.calendar_month),
    NavDestination(label: 'Notifications', icon: Icons.notifications_outlined, selectedIcon: Icons.notifications),
    NavDestination(label: 'Profile', icon: Icons.person_outline, selectedIcon: Icons.person),
  ];

  /// Courts are managed inside Stadiums; blocked slots from Bookings.
  static const List<NavDestination> shopAdmin = [
    NavDestination(label: 'Dashboard', icon: Icons.space_dashboard_outlined, selectedIcon: Icons.space_dashboard),
    NavDestination(label: 'Bookings', icon: Icons.calendar_month_outlined, selectedIcon: Icons.calendar_month),
    NavDestination(label: 'Stadiums', icon: Icons.stadium_outlined, selectedIcon: Icons.stadium),
    NavDestination(label: 'Customers', icon: Icons.groups_outlined, selectedIcon: Icons.groups),
    NavDestination(label: 'Settings', icon: Icons.settings_outlined, selectedIcon: Icons.settings),
  ];

  /// Onboarding requests live in the Shops tab.
  static const List<NavDestination> superadmin = [
    NavDestination(label: 'Dashboard', icon: Icons.space_dashboard_outlined, selectedIcon: Icons.space_dashboard),
    NavDestination(label: 'Shops', icon: Icons.storefront_outlined, selectedIcon: Icons.storefront),
    NavDestination(label: 'Bookings', icon: Icons.calendar_month_outlined, selectedIcon: Icons.calendar_month),
    NavDestination(label: 'Customers', icon: Icons.groups_outlined, selectedIcon: Icons.groups),
    NavDestination(label: 'Settings', icon: Icons.settings_outlined, selectedIcon: Icons.settings),
  ];

  static List<NavDestination> forRole(UserRole role) => switch (role) {
        UserRole.customer => customer,
        UserRole.shopAdmin => shopAdmin,
        UserRole.superadmin => superadmin,
      };

  /// Index of the destination that carries the role's count badge:
  /// unread notifications / pending bookings / pending onboarding.
  static int badgeIndexFor(UserRole role) => switch (role) {
        UserRole.customer => 3,
        UserRole.shopAdmin => 1,
        UserRole.superadmin => 1,
      };
}
