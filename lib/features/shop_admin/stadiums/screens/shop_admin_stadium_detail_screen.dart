import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/geo_location.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/detail_row.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/venue_location_card.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../providers/shop_venue_providers.dart';
import '../widgets/shop_visibility_banner.dart';
import '../widgets/stadium_admin_card.dart';

/// `/shop-admin/stadiums/:stadiumId` — SHOP scope: stadium summary and its
/// courts (active and inactive).
class ShopAdminStadiumDetailScreen extends ConsumerWidget {
  const ShopAdminStadiumDetailScreen({super.key, required this.stadiumId});

  final String stadiumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stadium = ref.watch(adminStadiumProvider(stadiumId));
    final found = stadium.valueOrNull != null;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(stadium.valueOrNull?.name ?? l.stadiumLabel),
        actions: [
          if (found)
            IconButton(
              tooltip: l.stadiumEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push(AppRoutes.shopAdminStadiumEdit(stadiumId)),
            ),
        ],
      ),
      floatingActionButton: found
          ? FloatingActionButton.extended(
              onPressed: () =>
                  context.push(AppRoutes.shopAdminCourtNew(stadiumId)),
              icon: const Icon(Icons.add),
              label: Text(l.addCourt),
            )
          : null,
      body: AsyncValueView<StadiumVO?>(
        value: stadium,
        onRetry: () => ref.invalidate(adminStadiumProvider(stadiumId)),
        isEmpty: (s) => s == null,
        empty: EmptyView(
          icon: Icons.stadium_outlined,
          title: l.stadiumNotFound,
          message: l.notFoundRemoved,
        ),
        data: (s) => _StadiumBody(stadium: s!),
      ),
    );
  }
}

class _StadiumBody extends ConsumerWidget {
  const _StadiumBody({required this.stadium});

  final StadiumVO stadium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courts = ref.watch(adminCourtsProvider(stadium.id));
    final l = context.l10n;
    final facilities = stadium.facilities.map((f) => f.labelIn(l)).join(', ');
    final MapPoint? location = stadium.hasLocation
        ? (latitude: stadium.latitude!, longitude: stadium.longitude!)
        : null;

    return ListView(
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.xxxl + AppSpacing.xxl,
      ),
      children: [
        const ShopVisibilityBanner(),
        ContentConstraint(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StadiumAdminCard(stadium: stadium),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    DetailRow(
                      icon: Icons.place_outlined,
                      label: l.addressLabel,
                      value: stadium.address,
                    ),
                    DetailRow(
                      icon: Icons.map_outlined,
                      label: l.locationLabel,
                      value: location == null
                          ? null
                          : GeoLocation.format(location),
                      emptyText: l.locationNotSet,
                    ),
                    DetailRow(
                      icon: Icons.local_activity_outlined,
                      label: l.facilitiesTitle,
                      value: facilities,
                      emptyText: l.noneListed,
                    ),
                    if ((stadium.description ?? '').trim().isNotEmpty)
                      DetailRow(
                        icon: Icons.notes,
                        label: l.descriptionLabel,
                        value: stadium.description,
                      ),
                  ],
                ),
              ),
              if (location != null) ...[
                const SizedBox(height: AppSpacing.md),
                VenueLocationCard(
                  name: stadium.name,
                  point: location,
                  address: stadium.address,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: l.courtsTitle),
              const SizedBox(height: AppSpacing.sm),
              switch (courts) {
                AsyncValue(:final valueOrNull?) => valueOrNull.isEmpty
                    ? AppCard(
                        padding: EdgeInsets.zero,
                        child: EmptyView.inline(
                          icon: Icons.sports_soccer,
                          title: l.noCourtsYet,
                          message: l.noCourtsMessage,
                        ),
                      )
                    : Column(
                        children: [
                          for (final (i, court) in valueOrNull.indexed)
                            FadeSlideIn(
                              index: i,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                child: _CourtCard(court: court),
                              ),
                            ),
                        ],
                      ),
                AsyncValue(:final error?) => ErrorView.inline(
                    error: error is AppException
                        ? error
                        : UnknownException(cause: error),
                    onRetry: () =>
                        ref.invalidate(adminCourtsProvider(stadium.id)),
                  ),
                _ => const Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: LoadingView(),
                  ),
              },
            ],
          ),
        ),
      ],
    );
  }
}

class _CourtCard extends StatelessWidget {
  const _CourtCard({required this.court});

  final CourtVO court;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.onSurfaceVariant;
    final price = court.hourlyPrice;
    final l = context.l10n;
    return AppCard(
      onTap: () =>
          context.push(AppRoutes.shopAdminCourt(court.stadiumId, court.id)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(court.name, style: context.textStyles.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  [
                    price == null
                        ? l.noPrice
                        : l.pricePerHour(Money.formatMmk(price)),
                    l.slotLengthLabel(court.slotMinutes),
                  ].join(' · '),
                  style: context.textStyles.bodyMedium?.copyWith(color: muted),
                ),
                const SizedBox(height: AppSpacing.sm),
                court.isActive
                    ? StatusBadge(
                        tone: StatusTone.success,
                        icon: Icons.check_circle,
                        label: l.bookableLabel,
                        semanticsPrefix: l.courtLabel,
                      )
                    : StatusBadge(
                        tone: StatusTone.neutral,
                        icon: Icons.pause_circle_outline,
                        label: l.venueInactive,
                        semanticsPrefix: l.courtLabel,
                      ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: AppSizes.iconLg, color: muted),
        ],
      ),
    );
  }
}
