import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/detail_row.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/shop-admin/settings/shop-profile` — SHOP scope: the public profile of
/// the admin's own shop. Status and listing are set by the superadmin only.
/// PREVIEW: sample data; editing arrives with the shop profile phase.
class ShopProfileScreen extends StatelessWidget {
  const ShopProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = DemoData.shop(DemoData.myShopId);
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop profile'),
        actions: [
          TextButton(
            onPressed: () => showPreviewOnly(context, 'Edit shop profile'),
            child: const Text('Edit'),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: PreviewBody(
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
                  label: 'Phone',
                  value: shop.phone,
                ),
                DetailRow(
                  icon: Icons.mail_outline,
                  label: 'Email',
                  value: shop.email,
                ),
                DetailRow(
                  icon: Icons.place_outlined,
                  label: 'Address',
                  value: [shop.address, shop.township, shop.city]
                      .whereType<String>()
                      .join(', '),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Status and listing are managed by the platform team.',
            style: styles.bodySmall?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}
