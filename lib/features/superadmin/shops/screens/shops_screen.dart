import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/shop_vo.dart';
import '../providers/shops_providers.dart';

/// `/superadmin/shops` (`?tab=onboarding` → shops pending review).
/// PLATFORM scope: every shop on the platform.
class ShopsScreen extends ConsumerWidget {
  const ShopsScreen({super.key, this.showOnboarding = false});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shops = ref.watch(allShopsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Shops')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.superadminShopNew),
        icon: const Icon(Icons.add_business_outlined),
        label: const Text('New shop'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: ContentConstraint(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('All')),
                    ButtonSegment(value: true, label: Text('Pending review')),
                  ],
                  selected: {showOnboarding},
                  onSelectionChanged: (s) => context.go(
                    s.first
                        ? Uri(
                            path: AppRoutes.superadminShops,
                            queryParameters: {
                              AppRoutes.tabQuery: AppRoutes.tabOnboarding,
                            },
                          ).toString()
                        : AppRoutes.superadminShops,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: AsyncValueView<List<ShopVO>>(
              value: shops.whenData(
                (list) => showOnboarding
                    ? list.where((s) => s.status == ShopStatus.pending).toList()
                    : list,
              ),
              onRetry: () => ref.invalidate(allShopsProvider),
              loading: const _ShopsSkeleton(),
              isEmpty: (list) => list.isEmpty,
              empty: showOnboarding
                  ? const EmptyView(
                      icon: Icons.inbox_outlined,
                      title: 'Nothing to review',
                      message: 'New shops appear here until you approve '
                          'or reject them.',
                    )
                  : EmptyView(
                      icon: Icons.storefront_outlined,
                      title: 'No shops yet',
                      message: 'Create the first shop, then assign its admin.',
                      actionLabel: 'New shop',
                      onAction: () => context.push(AppRoutes.superadminShopNew),
                    ),
              data: (list) => ListView.separated(
                // Room for the FAB under the last card.
                padding: const EdgeInsets.fromLTRB(
                  0,
                  AppSpacing.lg,
                  0,
                  AppSpacing.xxxl + AppSpacing.xxl,
                ),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) => ContentConstraint(
                  child: _ShopCard(shop: list[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop});

  final ShopVO shop;

  @override
  Widget build(BuildContext context) {
    final location = [shop.township, shop.city]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(', ');
    return AppCard(
      onTap: () => context.push(AppRoutes.superadminShop(shop.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(shop.name, style: context.textStyles.titleMedium),
          if (location.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              location,
              style: context.textStyles.bodyMedium
                  ?.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatusBadge.fromVisual(
                shop.status.visual,
                semanticsPrefix: 'Shop status',
              ),
              StatusBadge.fromVisual(
                shopListingVisual(isListed: shop.isListed),
                semanticsPrefix: 'Listing',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShopsSkeleton extends StatelessWidget {
  const _ShopsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      children: [
        for (var i = 0; i < 5; i++)
          const ContentConstraint(child: SkeletonListTile()),
      ],
    );
  }
}
