import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/hero_header.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
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
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navDashboard),
        actions: const [TourHelpButton()],
      ),
      body: PreviewBody(
        width: ContentWidth.dashboard,
        children: [
          HeroHeader(
            eyebrow: DisplayFormat.fullDate(DateKey.fromDate(DateTime.now())),
            title: l.shopCount(shops.length),
            subtitle: l.platformSummary(active, pending.length),
          ),
          const SizedBox(height: AppSpacing.xl),
          TourAnchor(
            id: TourIds.stats,
            child: StatGrid(
              children: [
                StatCard(
                  icon: Icons.storefront_outlined,
                  label: l.activeShops,
                  value: '$active',
                  footer: l.ofTotal(shops.length),
                  onTap: () => context.go(AppRoutes.superadminShops),
                ),
                StatCard(
                  icon: Icons.pending_actions_outlined,
                  label: l.toReview,
                  value: '${pending.length}',
                  footer: l.newShopsFooter,
                  highlight: pending.isNotEmpty,
                  onTap: () => context.go(_onboarding),
                ),
                StatCard(
                  icon: Icons.event_note_outlined,
                  label: l.navBookings,
                  value: '${bookings.length}',
                  footer: l.lastTwoWeeks,
                  onTap: () => context.go(AppRoutes.superadminBookings),
                ),
                StatCard(
                  icon: Icons.people_outline,
                  label: l.navCustomers,
                  value: '${DemoData.customers.length}',
                  onTap: () => context.go(AppRoutes.superadminCustomers),
                ),
              ],
            ),
          ),
          if (pending.isNotEmpty) ...[
            PreviewSectionTitle(
              l.waitingForReview,
              action: TextButton(
                onPressed: () => context.go(_onboarding),
                child: Text(l.reviewAction),
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
                        semanticsPrefix: l.shopStatusPrefix,
                      ),
                      onTap: () => context.go(_onboarding),
                    ),
                ],
              ),
            ),
          ],
          PreviewSectionTitle(
            l.latestBookings,
            action: TextButton(
              onPressed: () => context.go(AppRoutes.superadminBookings),
              child: Text(l.homeAllBookings),
            ),
          ),
          BookingGroup(
            bookings: recent,
            showCustomer: true,
            onOpen: (b) => context.push(AppRoutes.superadminBooking(b.id)),
          ),
        ],
      ),
    );
  }
}
