import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../providers/shop_venue_providers.dart';
import '../widgets/shop_visibility_banner.dart';
import '../widgets/stadium_admin_card.dart';

/// `/shop-admin/stadiums` — SHOP scope: every stadium of the admin's shop
/// (active or not). `?view=courts` is accepted for older links and shows
/// the same list; courts are managed inside each stadium.
class ShopAdminStadiumsScreen extends ConsumerWidget {
  const ShopAdminStadiumsScreen({super.key, this.showCourts = false});

  final bool showCourts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stadiums = ref.watch(myStadiumsProvider);
    void addStadium() => context.push(AppRoutes.shopAdminStadiumNew);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navStadiums),
        actions: const [TourHelpButton()],
      ),
      floatingActionButton: TourAnchor(
        id: TourIds.fab,
        child: FloatingActionButton.extended(
          onPressed: addStadium,
          icon: const Icon(Icons.add),
          label: Text(l.stadiumNew),
        ),
      ),
      body: AsyncValueView<List<StadiumVO>>(
        value: stadiums,
        onRetry: () => ref.invalidate(myStadiumsProvider),
        loading: const _StadiumsSkeleton(),
        isEmpty: (list) => list.isEmpty,
        empty: Column(
          children: [
            const ShopVisibilityBanner(),
            Expanded(
              child: EmptyView(
                icon: Icons.stadium_outlined,
                title: l.stadiumsEmptyTitle,
                message: l.stadiumsEmptyMessage,
                actionLabel: l.stadiumNew,
                onAction: addStadium,
              ),
            ),
          ],
        ),
        data: (list) => ListView(
          // Room for the FAB under the last card.
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: AppSpacing.xxxl + AppSpacing.xxl,
          ),
          children: [
            const ShopVisibilityBanner(),
            for (final (i, stadium) in list.indexed)
              FadeSlideIn(
                index: i,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ContentConstraint(
                    child: StadiumAdminCard(
                      stadium: stadium,
                      onTap: () =>
                          context.push(AppRoutes.shopAdminStadium(stadium.id)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StadiumsSkeleton extends StatelessWidget {
  const _StadiumsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      children: [
        for (var i = 0; i < 4; i++)
          const ContentConstraint(child: SkeletonListTile()),
      ],
    );
  }
}
