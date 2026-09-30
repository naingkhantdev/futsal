import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/shared/providers/notification_providers.dart';
import '../constants/domain_enums.dart';
import '../widgets/adaptive_nav_shell.dart';
import 'nav_destinations.dart';

/// Count shown on the role's badged nav destination: unread notifications
/// for customers. Pending bookings (shop admin) and pending onboarding
/// (superadmin) are still 0 until those lists are live (Phase 11 / 14).
final navBadgeCountProvider = Provider.family<int, UserRole>(
  (ref, role) => switch (role) {
    UserRole.customer => ref.watch(unreadNotificationCountProvider),
    UserRole.shopAdmin || UserRole.superadmin => 0,
  },
);

/// Binds a role's destinations and badge count to [AdaptiveNavShell].
class RoleNavShell extends ConsumerWidget {
  const RoleNavShell({
    super.key,
    required this.role,
    required this.navigationShell,
  });

  final UserRole role;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(navBadgeCountProvider(role));
    final badgeIndex = NavDestinations.badgeIndexFor(role);
    final destinations = [
      for (final (i, d) in NavDestinations.forRole(role).indexed)
        i == badgeIndex ? d.withBadge(count) : d,
    ];
    return AdaptiveNavShell(
      navigationShell: navigationShell,
      destinations: destinations,
    );
  }
}
