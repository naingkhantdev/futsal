import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_labels.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/detail_row.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_badge.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(stadium.valueOrNull?.name ?? 'Stadium'),
        actions: [
          if (found)
            IconButton(
              tooltip: 'Edit stadium',
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
              label: const Text('Add court'),
            )
          : null,
      body: AsyncValueView<StadiumVO?>(
        value: stadium,
        onRetry: () => ref.invalidate(adminStadiumProvider(stadiumId)),
        isEmpty: (s) => s == null,
        empty: const EmptyView(
          icon: Icons.stadium_outlined,
          title: 'Stadium not found',
          message: 'It may have been removed.',
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
    final facilities = stadium.facilities.map((f) => f.label).join(', ');

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
                      label: 'Address',
                      value: stadium.address,
                    ),
                    DetailRow(
                      icon: Icons.local_activity_outlined,
                      label: 'Facilities',
                      value: facilities,
                      emptyText: 'None listed',
                    ),
                    if ((stadium.description ?? '').trim().isNotEmpty)
                      DetailRow(
                        icon: Icons.notes,
                        label: 'Description',
                        value: stadium.description,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'Courts'),
              const SizedBox(height: AppSpacing.sm),
              switch (courts) {
                AsyncValue(:final valueOrNull?) => valueOrNull.isEmpty
                    ? const AppCard(
                        padding: EdgeInsets.zero,
                        child: EmptyView.inline(
                          icon: Icons.sports_soccer,
                          title: 'No courts yet',
                          message: 'Add a court with its price and slot '
                              'length so customers can book it.',
                        ),
                      )
                    : Column(
                        children: [
                          for (final court in valueOrNull)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
                              child: _CourtCard(court: court),
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
                    price == null ? 'No price' : '${Money.formatMmk(price)}/h',
                    '${court.slotMinutes}-min slots',
                  ].join(' · '),
                  style: context.textStyles.bodyMedium?.copyWith(color: muted),
                ),
                const SizedBox(height: AppSpacing.sm),
                court.isActive
                    ? const StatusBadge(
                        tone: StatusTone.success,
                        icon: Icons.check_circle,
                        label: 'Bookable',
                        semanticsPrefix: 'Court',
                      )
                    : const StatusBadge(
                        tone: StatusTone.neutral,
                        icon: Icons.pause_circle_outline,
                        label: 'Inactive',
                        semanticsPrefix: 'Court',
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
