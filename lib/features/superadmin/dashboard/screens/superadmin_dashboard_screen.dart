import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../console/widgets/console_booking_table.dart';
import '../../console/widgets/console_kit.dart';

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
    final pending = shops.where((s) => s.status == ShopStatus.pending).toList();
    final bookings = DemoData.allBookings();
    final recent = bookings.take(6).toList();
    final l = context.l10n;
    final today = DisplayFormat.fullDate(DateKey.fromDate(DateTime.now()));

    return Scaffold(
      appBar: ConsoleAppBar(title: l.navDashboard),
      body: ConsoleBody(
        demo: true,
        header: ConsoleBand(
          overline: '${l.consolePlatform} · $today',
          title: l.consoleOverview,
          subtitle: l.platformSummary(active, pending.length),
          metrics: [
            ConsoleMetric(
              value: '$active',
              label: l.activeShops,
              onTap: () => context.go(AppRoutes.superadminShops),
            ),
            ConsoleMetric(
              value: '${pending.length}',
              label: l.toReview,
              attention: pending.isNotEmpty,
              onTap: () => context.go(_onboarding),
            ),
            ConsoleMetric(
              value: '${bookings.length}',
              label: '${l.navBookings} · ${l.lastTwoWeeks}',
              onTap: () => context.go(AppRoutes.superadminBookings),
            ),
            ConsoleMetric(
              value: '${DemoData.customers.length}',
              label: l.navCustomers,
              onTap: () => context.go(AppRoutes.superadminCustomers),
            ),
          ],
        ),
        children: [
          ConsoleHeading(
            l.waitingForReview,
            count: pending.length,
            action: TextButton(
              onPressed: () => context.go(_onboarding),
              child: Text(l.reviewAction),
            ),
          ),
          if (pending.isEmpty)
            EmptyView.inline(
              icon: Icons.inbox_outlined,
              title: l.nothingToReview,
            )
          else
            ConsoleTable(
              columns: [
                ConsoleColumn(l.shopLabel, flex: 4),
                ConsoleColumn(l.locationLabel, flex: 3, compact: false),
                ConsoleColumn(l.consoleStatus, flex: 3),
              ],
              rows: [
                for (final s in pending)
                  ConsoleRow(
                    onTap: () => context.push(AppRoutes.superadminShop(s.id)),
                    cells: [
                      ConsoleCellText(
                        s.name,
                        strong: true,
                        secondary: context.isCompact ? s.city : s.phone,
                      ),
                      ConsoleCellText(
                        [s.township, s.city].whereType<String>().join(', '),
                      ),
                      StatusBadge.fromVisual(
                        s.status.visual,
                        semanticsPrefix: l.shopStatusPrefix,
                        plain: true,
                      ),
                    ],
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
          ConsoleHeading(
            l.latestBookings,
            action: TextButton(
              onPressed: () => context.go(AppRoutes.superadminBookings),
              child: Text(l.homeAllBookings),
            ),
          ),
          ConsoleBookingTable(
            bookings: recent,
            shopNameOf: (b) => DemoData.shop(b.shopId).name,
            onOpen: (b) => context.push(AppRoutes.superadminBooking(b.id)),
          ),
        ],
      ),
    );
  }
}
