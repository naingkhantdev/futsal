import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_labels.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/geo_location.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/grouped_list.dart';
import '../../../../core/widgets/stadium_photo.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../core/widgets/venue_location_card.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../../data/vos/shop_vo.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/page_body.dart';
import '../providers/customer_venue_providers.dart';

/// `/customer/stadiums/:stadiumId` — CUSTOMER scope: venue photo and info,
/// courts and the "Book a court" CTA. Only published stadiums are readable
/// (firestore.rules); anything else shows "not found".
class StadiumDetailsScreen extends ConsumerWidget {
  const StadiumDetailsScreen({super.key, required this.stadiumId});

  final String stadiumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stadium = ref.watch(customerStadiumProvider(stadiumId));
    final s = stadium.valueOrNull;
    if (s != null) return _StadiumDetails(stadium: s);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(),
      body: AsyncValueView<StadiumVO?>(
        value: stadium,
        onRetry: () => ref.invalidate(customerStadiumProvider(stadiumId)),
        isEmpty: (s) => s == null,
        empty: EmptyView(
          icon: Icons.stadium_outlined,
          title: l.stadiumNotFound,
          message: l.notFoundRemoved,
        ),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _StadiumDetails extends ConsumerWidget {
  const _StadiumDetails({required this.stadium});

  final StadiumVO stadium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = stadium;
    final shop = ref.watch(publicShopProvider(s.shopId)).valueOrNull;
    final MapPoint? shopPoint = switch (shop) {
      ShopVO(latitude: final lat?, longitude: final lng?) =>
        (latitude: lat, longitude: lng),
      _ => null,
    };
    final courtsValue = ref.watch(customerCourtsProvider(s.id));
    final courts = (courtsValue.valueOrNull ?? const <CourtVO>[])
        .where((c) => c.hasPrice)
        .toList();
    final styles = context.textStyles;
    final colors = context.colors;
    final muted = colors.onSurfaceVariant;
    final l = context.l10n;
    final address =
        [s.address, s.township, s.city].whereType<String>().join(', ');
    final fromPrice = Money.formatMmk(s.minHourlyPrice ?? 0);
    final canBook = courts.isNotEmpty;

    return Scaffold(
      // The photo runs under the status bar and the floating back button.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
        leading: context.canPop() ? const _FloatingBackButton() : null,
      ),
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
                    l.pricePerHour(fromPrice),
                    style: AppTypography.tabular(styles.titleMedium!),
                  ),
                ],
              ),
            ),
            TourAnchor(
              id: TourIds.primary,
              child: PrimaryButton(
                label: l.bookACourt,
                onPressed: canBook
                    ? () => context.push(AppRoutes.customerBookStadium(s.id))
                    : null,
              ),
            ),
          ],
        ),
      ),
      body: PageBody(
        header: _PhotoHeader(stadium: s, shop: shop),
        children: [
          _FactStrip(
            facts: [
              (
                l.openingHoursTitle,
                DisplayFormat.timeRange(s.openMinute, s.closeMinute),
              ),
              (l.courtsTitle, '${courts.length}'),
              (l.priceFrom, fromPrice),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _InfoLine(icon: Icons.place_outlined, text: address),
          if (shop?.phone != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoLine(icon: Icons.phone_outlined, text: shop!.phone!),
          ],
          if (s.description != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(s.description!, style: styles.bodyLarge),
          ],
          if (s.facilities.isNotEmpty) ...[
            PageSectionTitle(l.facilitiesTitle),
            _FacilityGrid(
              items: [
                for (final f in s.facilities) (f.icon, f.labelIn(l)),
              ],
            ),
          ],
          // Stadium pin first; otherwise the shop's address pin.
          if (s.hasLocation || shopPoint != null || address.isNotEmpty) ...[
            PageSectionTitle(l.locationLabel),
            VenueLocationCard(
              name: s.name,
              address: address,
              point: s.hasLocation
                  ? (latitude: s.latitude!, longitude: s.longitude!)
                  : shopPoint,
            ),
          ],
          PageSectionTitle(l.courtsTitle),
          if (courtsValue.hasValue && courts.isEmpty)
            EmptyView.inline(
              icon: Icons.sports_soccer,
              title: l.noCourtsYet,
            )
          else
          TourAnchor(
            id: TourIds.courts,
            child: GroupedList(
              children: [
                for (final c in courts)
                  ListTile(
                    title: Text(c.name),
                    subtitle: Text(
                      [
                        surfaceText(l, c.surfaceType),
                        if (c.capacity != null) l.upToPlayers(c.capacity!),
                        l.slotLengthLabel(c.slotMinutes),
                      ].whereType<String>().join(' · '),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.pricePerHour(Money.formatMmk(c.hourlyPrice!)),
                          style: AppTypography.tabular(styles.labelLarge!),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(Icons.chevron_right, color: muted),
                      ],
                    ),
                    onTap: () => context.push(
                      Uri(
                        path: AppRoutes.customerBookStadium(s.id),
                        queryParameters: {AppRoutes.courtIdQuery: c.id},
                      ).toString(),
                    ),
                  ),
              ],
            ),
          ),
          // Fine print last: what happens if plans change.
          PageSectionTitle(l.cancelPolicyTitle),
          _InfoLine(
            icon: Icons.policy_outlined,
            text: cancelPolicySummary(l, s.freeCancelHours),
          ),
          if (s.cancellationNote != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              s.cancellationNote!,
              style: styles.bodyMedium?.copyWith(color: muted),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-bleed venue photo with the name, shop and township on the scrim.
class _PhotoHeader extends StatelessWidget {
  const _PhotoHeader({required this.stadium, required this.shop});

  final StadiumVO stadium;
  final ShopVO? shop;

  @override
  Widget build(BuildContext context) {
    final g = context.gradients;
    final styles = context.textStyles;
    final width = MediaQuery.sizeOf(context).width;
    final height = (width * 0.85).clamp(300.0, 460.0).toDouble();
    final place =
        [stadium.township, stadium.city].whereType<String>().join(', ');

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          StadiumPhoto(url: stadium.coverImage),
          DecoratedBox(decoration: BoxDecoration(gradient: g.scrim)),
          Positioned(
            left: 0,
            right: 0,
            bottom: AppSpacing.xl,
            child: ContentConstraint(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (shop != null) ...[
                    Text(
                      context.l10n.byShop(shop!.name),
                      style: styles.labelLarge?.copyWith(color: g.gold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                  Semantics(
                    header: true,
                    child: Text(
                      stadium.name,
                      style: styles.headlineLarge?.copyWith(color: g.onHero),
                    ),
                  ),
                  if (place.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      place,
                      style: styles.bodyMedium?.copyWith(color: g.onHeroMuted),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Round back button that stays legible over the photo and the page.
class _FloatingBackButton extends StatelessWidget {
  const _FloatingBackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Center(
        child: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          style: IconButton.styleFrom(
            backgroundColor: context.depth.base,
            foregroundColor: context.colors.onSurface,
            minimumSize: const Size.square(AppSizes.minTouchTarget),
          ),
          icon: const BackButtonIcon(),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}

/// Key numbers in a row, separated by hairlines: label above, value below.
class _FactStrip extends StatelessWidget {
  const _FactStrip({required this.facts});

  final List<(String label, String value)> facts;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, f) in facts.indexed) ...[
            if (i > 0)
              const VerticalDivider(width: AppSpacing.xl, thickness: 1),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f.$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styles.labelMedium?.copyWith(color: muted),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    f.$2,
                    maxLines: 2,
                    style: AppTypography.tabular(styles.titleSmall!),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Facilities as icon + label in two columns (no chip boxes).
class _FacilityGrid extends StatelessWidget {
  const _FacilityGrid({required this.items});

  final List<(IconData icon, String label)> items;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - AppSpacing.lg) / 2;
        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.md,
          children: [
            for (final (icon, label) in items)
              SizedBox(
                width: itemWidth,
                child: Row(
                  children: [
                    Icon(icon, size: AppSizes.iconMd, color: colors.secondary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(label, style: styles.bodyMedium)),
                  ],
                ),
              ),
          ],
        );
      },
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
