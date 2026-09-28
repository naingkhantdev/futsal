import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/booking_list_tile.dart';
import '../../../shared/widgets/preview_body.dart';
import '../../../shared/widgets/stat_grid.dart';

/// `/superadmin/dashboard` — PLATFORM scope: shops, bookings and customers
/// across every shop, plus shops waiting for review.
/// PREVIEW: sample data (`DemoData`) until Phase 14.
class SuperadminDashboardScreen extends StatelessWidget {
  const SuperadminDashboardScreen({super.key});

  static String get _onboarding => Uri(
        path: AppRoutes.superadminShops,
        queryParameters: {AppRoutes.tabQuery: AppRoutes.tabOnboarding},
      ).toString();

  @override
  Widget build(BuildContext context) {
    final shops = DemoData.shops;
    final active = shops.where((s) => s.status == ShopStatus.active).length;
    final pending =
        shops.where((s) => s.status == ShopStatus.pending).toList();
    final bookings = DemoData.allBookings();
    final recent = bookings.take(4).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: PreviewBody(
        width: ContentWidth.dashboard,
        children: [
          StatGrid(
            children: [
              StatCard(
                icon: Icons.storefront_outlined,
                label: 'Active shops',
                value: '$active',
                footer: 'of ${shops.length}',
                onTap: () => context.go(AppRoutes.superadminShops),
              ),
              StatCard(
                icon: Icons.pending_actions_outlined,
                label: 'To review',
                value: '${pending.length}',
                footer: 'new shops',
                tone: pending.isEmpty ? StatusTone.brand : StatusTone.warning,
                onTap: () => context.go(_onboarding),
              ),
              StatCard(
                icon: Icons.event_note_outlined,
                label: 'Bookings',
                value: '${bookings.length}',
                footer: 'last 2 weeks',
                onTap: () => context.go(AppRoutes.superadminBookings),
              ),
              StatCard(
                icon: Icons.people_outline,
                label: 'Customers',
                value: '${DemoData.customers.length}',
                onTap: () => context.go(AppRoutes.superadminCustomers),
              ),
            ],
          ),
          if (pending.isNotEmpty) ...[
            PreviewSectionTitle(
              'Waiting for review',
              action: TextButton(
                onPressed: () => context.go(_onboarding),
                child: const Text('Review'),
              ),
            ),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final s in pending)
                    ListTile(
                      leading: const Icon(Icons.storefront_outlined),
                      title: Text(s.name),
                      subtitle: Text(
                        [s.township, s.city].whereType<String>().join(', '),
                      ),
                      trailing: StatusBadge.fromVisual(
                        s.status.visual,
                        semanticsPrefix: 'Shop status',
                      ),
                      onTap: () => context.go(_onboarding),
                    ),
                ],
              ),
            ),
          ],
          PreviewSectionTitle(
            'Latest bookings',
            action: TextButton(
              onPressed: () => context.go(AppRoutes.superadminBookings),
              child: const Text('All bookings'),
            ),
          ),
          for (final b in recent) ...[
            BookingListTile(
              booking: b,
              showCustomer: true,
              onTap: () => context.push(AppRoutes.superadminBooking(b.id)),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
