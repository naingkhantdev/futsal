import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
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
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/court_vo.dart';
import '../../stadiums/providers/shop_venue_providers.dart';

/// `/shop-admin/stadiums/:stadiumId/courts/:courtId` — SHOP scope: court
/// details, edit, and a shortcut to block time on it.
class CourtDetailScreen extends ConsumerWidget {
  const CourtDetailScreen({
    super.key,
    required this.stadiumId,
    required this.courtId,
  });

  final String stadiumId;
  final String courtId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (stadiumId: stadiumId, courtId: courtId);
    final court = ref.watch(adminCourtProvider(key));
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(court.valueOrNull?.name ?? l.courtLabel),
        actions: [
          if (court.valueOrNull != null)
            IconButton(
              tooltip: l.courtEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context
                  .push(AppRoutes.shopAdminCourtEdit(stadiumId, courtId)),
            ),
        ],
      ),
      body: AsyncValueView<CourtVO?>(
        value: court,
        onRetry: () => ref.invalidate(adminCourtProvider(key)),
        isEmpty: (c) => c == null,
        empty: EmptyView(
          icon: Icons.sports_soccer,
          title: l.courtNotFound,
          message: l.notFoundRemoved,
        ),
        data: (c) => _CourtBody(court: c!),
      ),
    );
  }
}

class _CourtBody extends StatelessWidget {
  const _CourtBody({required this.court});

  final CourtVO court;

  @override
  Widget build(BuildContext context) {
    final price = court.hourlyPrice;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      children: [
        ContentConstraint(
          width: ContentWidth.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: court.isActive
                    ? StatusBadge(
                        tone: StatusTone.success,
                        icon: Icons.check_circle,
                        label: l.bookableLabel,
                        semanticsPrefix: l.courtLabel,
                        size: StatusBadgeSize.medium,
                      )
                    : StatusBadge(
                        tone: StatusTone.neutral,
                        icon: Icons.pause_circle_outline,
                        label: l.venueInactive,
                        semanticsPrefix: l.courtLabel,
                        size: StatusBadgeSize.medium,
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    DetailRow(
                      icon: Icons.payments_outlined,
                      label: l.pricePerHourTitle,
                      value: price == null ? null : Money.formatMmk(price),
                      emptyText: l.noPriceSet,
                    ),
                    DetailRow(
                      icon: Icons.timelapse,
                      label: l.slotLengthTitle,
                      value: l.slotMinutesValue(court.slotMinutes),
                    ),
                    DetailRow(
                      icon: Icons.groups_outlined,
                      label: l.playersLabel,
                      value: court.capacity?.toString(),
                    ),
                    DetailRow(
                      icon: Icons.grass,
                      label: l.surfaceLabel,
                      value: court.surfaceType,
                    ),
                    if ((court.description ?? '').trim().isNotEmpty)
                      DetailRow(
                        icon: Icons.notes,
                        label: l.descriptionLabel,
                        value: court.description,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.block, size: AppSizes.iconLg),
                  title: Text(l.blockTimeTitle),
                  subtitle: Text(l.blockCourtSub),
                  trailing: Icon(Icons.chevron_right, color: muted),
                  onTap: () => context.push(
                    Uri(
                      path: AppRoutes.shopAdminBlockedSlotNew,
                      queryParameters: {
                        AppRoutes.stadiumIdQuery: court.stadiumId,
                        AppRoutes.courtIdQuery: court.id,
                      },
                    ).toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
