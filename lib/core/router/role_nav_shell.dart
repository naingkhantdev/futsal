import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/domain_enums.dart';
import '../widgets/adaptive_nav_shell.dart';
import 'nav_destinations.dart';

/// Count shown on the role's badged nav destination.
///
/// Phase 1 stub returning 0. Later phases override/replace it with real
/// counts (unread notifications, pending bookings, pending onboarding).
final navBadgeCountProvider = Provider.family<int, UserRole>((ref, role) => 0);

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
