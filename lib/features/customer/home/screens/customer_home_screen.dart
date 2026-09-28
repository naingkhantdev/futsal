import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/booking_list_tile.dart';
import '../../../shared/widgets/preview_body.dart';
import '../../stadiums/widgets/stadium_list_card.dart';

/// `/customer/home` — CUSTOMER scope. Greeting, search, next game and
/// popular venues. PREVIEW: sample data (`DemoData`) until Phase 6.
class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me = DemoData.customer(DemoData.meId);
    final next = DemoData.upcoming(DemoData.bookingsOfCustomer(me.id));
    final styles = context.textStyles;
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: PreviewBody(
          children: [
            Text(
              l.homeGreeting(me.name.split(' ').first),
              style: styles.bodyLarge
                  ?.copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(l.homeReady, style: styles.headlineMedium),
            const SizedBox(height: AppSpacing.lg),
            // Tapping the search opens Explore, where filtering happens.
            GestureDetector(
              onTap: () => context.go(AppRoutes.customerExplore),
              child: AbsorbPointer(
                child: SearchField(hintText: l.homeSearchHint),
              ),
            ),
            PreviewSectionTitle(
              l.homeNextGame,
              action: next.length > 1
                  ? TextButton(
                      onPressed: () => context.go(AppRoutes.customerBookings),
                      child: Text(l.homeAllBookings),
                    )
                  : null,
            ),
            if (next.isEmpty)
              Text(
                l.homeNoGames,
                style: styles.bodyMedium
                    ?.copyWith(color: context.colors.onSurfaceVariant),
              )
            else
              BookingListTile(
                booking: next.first,
                onTap: () =>
                    context.push(AppRoutes.customerBooking(next.first.id)),
              ),
            PreviewSectionTitle(
              l.homePopular,
              action: TextButton(
                onPressed: () => context.go(AppRoutes.customerExplore),
                child: Text(l.commonSeeAll),
              ),
            ),
            for (final stadium in DemoData.stadiums.take(3)) ...[
              StadiumListCard(stadium: stadium),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}
