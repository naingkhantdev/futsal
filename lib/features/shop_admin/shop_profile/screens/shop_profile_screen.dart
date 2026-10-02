import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/detail_row.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/venue_location_card.dart';
import '../../../../data/vos/shop_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/page_body.dart';
import '../../stadiums/providers/shop_venue_providers.dart';

/// `/shop-admin/settings/shop-profile` — SHOP scope: the public profile of
/// the admin's own shop. Read-only here: the profile, status and listing
/// are written by the superadmin only (firestore.rules).
class ShopProfileScreen extends ConsumerWidget {
  const ShopProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shop = ref.watch(myShopProvider);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsShopProfile),
        actions: const [TourHelpButton()],
      ),
      body: AsyncValueView<ShopVO?>(
        value: shop,
        onRetry: () => ref.invalidate(myShopProvider),
        isEmpty: (s) => s == null,
        empty: EmptyView(
          icon: Icons.storefront,
          title: l.shopNotFound,
          message: l.notFoundRemoved,
        ),
        data: (s) => _ShopProfile(shop: s!),
      ),
    );
  }
}

class _ShopProfile extends StatelessWidget {
  const _ShopProfile({required this.shop});

  final ShopVO shop;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
    return PageBody(
        width: ContentWidth.form,
        children: [
          Row(
            children: [
              Container(
                width: AppSizes.avatarLarge,
                height: AppSizes.avatarLarge,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Icon(
                  Icons.storefront,
                  color: context.colors.onPrimary,
                  size: AppSizes.iconXl,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: styles.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        StatusBadge.fromVisual(
                          shop.status.visual,
                          semanticsPrefix: l.shopStatusPrefix,
                        ),
                        StatusBadge.fromVisual(
                          shopListingVisual(isListed: shop.isListed),
                          semanticsPrefix: l.listingPrefix,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (shop.description != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(shop.description!, style: styles.bodyMedium),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                DetailRow(
                  icon: Icons.phone_outlined,
                  label: l.profilePhone,
                  value: shop.phone,
                ),
                DetailRow(
                  icon: Icons.mail_outline,
                  label: l.emailLabel,
                  value: shop.email,
                ),
                DetailRow(
                  icon: Icons.place_outlined,
                  label: l.addressLabel,
                  value: [shop.address, shop.township, shop.city]
                      .whereType<String>()
                      .join(', '),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Where customers come to; the pin is set by the superadmin.
          VenueLocationCard(
            name: shop.name,
            address: [shop.address, shop.township, shop.city]
                .whereType<String>()
                .join(', '),
            point: shop.latitude != null && shop.longitude != null
                ? (latitude: shop.latitude!, longitude: shop.longitude!)
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.statusManagedByPlatform,
            style: styles.bodySmall?.copyWith(color: muted),
          ),
        ],
    );
  }
}
