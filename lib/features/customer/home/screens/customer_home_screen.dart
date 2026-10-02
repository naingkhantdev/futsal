import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/day_strip.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/hero_header.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../../../shared/providers/booking_providers.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/booking_ticket.dart';
import '../../../shared/widgets/page_body.dart';
import '../../../shared/widgets/person_tile.dart';
import '../../bookings/providers/customer_bookings_providers.dart';
import '../../profile/providers/current_user_profile_provider.dart';
import '../../stadiums/providers/customer_venue_providers.dart';
import '../../stadiums/widgets/stadium_list_card.dart';

/// `/customer/home` — CUSTOMER scope. Built around the booking: search,
/// the next game as a ticket, then a day picker and venues with their next
/// open start times (one tap into the slot grid with court + day set).
class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() =>
      _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  String _date = DateKey.fromDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(currentUserProfileProvider).valueOrNull?.name ?? '';
    final next = upcomingOf(ref.watch(myBookingsProvider).valueOrNull ?? []);
    final stadiums = ref.watch(publishedStadiumsProvider);
    final l = context.l10n;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: PageBody(
          children: [
            HeroHeader(
              eyebrow: l.homeGreeting(name.split(' ').first),
              title: l.bookACourt,
              trailing: _ProfileButton(name: name),
              // Tapping the search opens Explore, where filtering happens.
              bottom: TourAnchor(
                id: TourIds.search,
                child: Semantics(
                  button: true,
                  label: l.homeSearchHint,
                  excludeSemantics: true,
                  onTap: () => context.go(AppRoutes.customerExplore),
                  child: GestureDetector(
                    onTap: () => context.go(AppRoutes.customerExplore),
                    child: AbsorbPointer(
                      child: SearchField(hintText: l.homeSearchHint),
                    ),
                  ),
                ),
              ),
            ),
            if (next.isNotEmpty) ...[
              PageSectionTitle(
                l.homeNextGame,
                action: next.length > 1
                    ? TextButton(
                        onPressed: () => context.go(AppRoutes.customerBookings),
                        child: Text(l.homeAllBookings),
                      )
                    : null,
              ),
              BookingTicket(
                booking: next.first,
                onTap: () =>
                    context.push(AppRoutes.customerBooking(next.first.id)),
              ),
            ],
            PageSectionTitle(
              l.homeOpenSlots(DisplayFormat.dayLabel(_date, l)),
              action: TextButton(
                onPressed: () => context.go(AppRoutes.customerExplore),
                child: Text(l.commonSeeAll),
              ),
            ),
            TourAnchor(
              id: TourIds.dayStrip,
              child: DayStrip(
                selected: _date,
                onSelected: (d) => setState(() => _date = d),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TourAnchor(
              id: TourIds.venues,
              child: switch (stadiums) {
                AsyncValue(:final valueOrNull?) => valueOrNull.isEmpty
                    ? EmptyView.inline(
                        icon: Icons.stadium_outlined,
                        title: l.homeNoVenuesTitle,
                        message: l.homeNoVenuesMessage,
                      )
                    : _VenueCarousel(stadiums: valueOrNull, date: _date),
                AsyncValue(:final error?) => ErrorView.inline(
                    error: error is AppException
                        ? error
                        : UnknownException(cause: error),
                    onRetry: () => ref.invalidate(publishedStadiumsProvider),
                  ),
                _ => const Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: LoadingView(),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontally scrolling venues, each with its next open times on [date].
class _VenueCarousel extends StatelessWidget {
  const _VenueCarousel({required this.stadiums, required this.date});

  final List<StadiumVO> stadiums;
  final String date;

  static const double _itemWidth = 280;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, s) in stadiums.indexed) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: _itemWidth,
              child: _OpenVenue(stadium: s, date: date),
            ),
          ],
        ],
      ),
    );
  }
}

class _OpenVenue extends ConsumerWidget {
  const _OpenVenue({required this.stadium, required this.date});

  final StadiumVO stadium;
  final String date;

  void _book(BuildContext context, CourtVO court) {
    context.push(
      Uri(
        path: AppRoutes.customerBookStadium(stadium.id),
        queryParameters: {
          AppRoutes.courtIdQuery: court.id,
          AppRoutes.dateQuery: date,
        },
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final openValue =
        ref.watch(openStartsProvider((stadium: stadium, date: date)));
    final open = openValue.valueOrNull ?? const <OpenStart>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StadiumListCard(stadium: stadium, aspectRatio: 4 / 3),
        const SizedBox(height: AppSpacing.xs),
        if (!openValue.hasValue)
          const SizedBox(height: AppSizes.minTouchTarget)
        else if (open.isEmpty)
          SizedBox(
            height: AppSizes.minTouchTarget,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l.homeNoOpenSlots,
                style: context.textStyles.bodyMedium
                    ?.copyWith(color: context.colors.onSurfaceVariant),
              ),
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final o in open)
                _TimeChip(
                  time: formatMinuteOfDay(o.startMinute),
                  semanticLabel:
                      l.bookSlotAt(o.court.name, formatMinuteOfDay(o.startMinute)),
                  onTap: () => _book(context, o.court),
                ),
            ],
          ),
      ],
    );
  }
}

/// An open start time: outlined pill inside a 48dp tap target.
class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.time,
    required this.semanticLabel,
    required this.onTap,
  });

  final String time;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.fullAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSizes.minTouchTarget,
            minWidth: AppSizes.minTouchTarget,
          ),
          child: Center(
            widthFactor: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                borderRadius: AppRadius.fullAll,
                border: Border.all(color: c.outline),
              ),
              child: Text(
                time,
                style: AppTypography.tabular(context.textStyles.labelLarge!)
                    .copyWith(color: c.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Initials avatar that opens the profile (48dp target).
class _ProfileButton extends StatelessWidget {
  const _ProfileButton({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    void open() => context.go(AppRoutes.customerProfile);
    return Semantics(
      button: true,
      label: context.l10n.navProfile,
      // excludeSemantics drops the InkWell's action; re-expose it here.
      onTap: open,
      excludeSemantics: true,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: open,
        child: SizedBox.square(
          dimension: AppSizes.minTouchTarget,
          child: Center(child: InitialsAvatar(name: name, size: 44)),
        ),
      ),
    );
  }
}
