import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_labels.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/customer/stadiums/:stadiumId` — CUSTOMER scope: venue info, courts and
/// the "Book a court" CTA. PREVIEW: sample data (`DemoData`) until Phase 7.
class StadiumDetailsScreen extends StatelessWidget {
  const StadiumDetailsScreen({super.key, required this.stadiumId});

  final String stadiumId;

  @override
  Widget build(BuildContext context) {
    final s = DemoData.stadium(stadiumId);
    final shop = DemoData.shop(s.shopId);
    final courts = DemoData.courtsOf(s.id);
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
    final location =
        [s.address, s.township, s.city].whereType<String>().join(', ');

    return Scaffold(
      appBar: AppBar(title: Text(s.name)),
      bottomNavigationBar: StickyBottomBar(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.priceFrom,
                    style: styles.labelMedium?.copyWith(color: muted),
                  ),
                  Text(
                    l.pricePerHour(Money.formatMmk(s.minHourlyPrice ?? 0)),
                    style: styles.titleMedium,
                  ),
                ],
              ),
            ),
            PrimaryButton(
              label: l.bookACourt,
              onPressed: () => context.push(AppRoutes.customerBookStadium(s.id)),
            ),
          ],
        ),
      ),
      body: PreviewBody(
        children: [
          ClipRRect(
            borderRadius: AppRadius.lgAll,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ColoredBox(
                color: context.appColors.imagePlaceholder,
                child: Icon(
                  Icons.sports_soccer_outlined,
                  size: AppSizes.iconEmptyState,
                  color: muted,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(s.name, style: styles.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.byShop(shop.name),
            style: styles.bodyMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoLine(icon: Icons.place_outlined, text: location),
          const SizedBox(height: AppSpacing.sm),
          _InfoLine(
            icon: Icons.schedule,
            text: l.openDaily(
              DisplayFormat.timeRange(s.openMinute, s.closeMinute),
            ),
          ),
          if (shop.phone != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoLine(icon: Icons.phone_outlined, text: shop.phone!),
          ],
          if (s.description != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(s.description!, style: styles.bodyMedium),
          ],
          PreviewSectionTitle(l.facilitiesTitle),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final f in s.facilities)
                Chip(
                  avatar: Icon(f.icon, size: AppSizes.iconSm),
                  label: Text(f.labelIn(l)),
                ),
            ],
          ),
          PreviewSectionTitle(l.courtsTitle),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (i, c) in courts.indexed) ...[
                  if (i > 0) const Divider(indent: AppSpacing.lg),
                  ListTile(
                    title: Text(c.name),
                    subtitle: Text(
                      [
                        c.surfaceType,
                        if (c.capacity != null) l.upToPlayers(c.capacity!),
                        l.slotLengthLabel(c.slotMinutes),
                      ].whereType<String>().join(' · '),
                    ),
                    trailing: Text(
                      l.pricePerHour(Money.formatMmk(c.hourlyPrice!)),
                      style: styles.labelLarge,
                    ),
                    onTap: () => context.push(
                      Uri(
                        path: AppRoutes.customerBookStadium(s.id),
                        queryParameters: {AppRoutes.courtIdQuery: c.id},
                      ).toString(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.onSurfaceVariant;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconMd, color: muted),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: context.textStyles.bodyMedium)),
      ],
    );
  }
}
