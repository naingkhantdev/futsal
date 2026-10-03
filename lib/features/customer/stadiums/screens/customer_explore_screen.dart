import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/page_body.dart';
import '../providers/customer_venue_providers.dart';
import '../providers/explore_providers.dart';
import '../widgets/explore_filter_sheet.dart';
import '../widgets/stadium_list_card.dart';
import '../widgets/stadiums_map.dart';

/// `/customer/explore` — CUSTOMER scope: search, filter (facilities,
/// surface, price, free at a time), sort (name, price, distance) and browse
/// published stadiums as a list or on a map. Read-only; no shopId impact.
class CustomerExploreScreen extends ConsumerStatefulWidget {
  const CustomerExploreScreen({super.key});

  @override
  ConsumerState<CustomerExploreScreen> createState() =>
      _CustomerExploreScreenState();
}

class _CustomerExploreScreenState extends ConsumerState<CustomerExploreScreen> {
  bool _showMap = false;

  Future<void> _openFilters() async {
    final current = ref.read(exploreFilterProvider);
    final next = await showAppBottomSheet<ExploreFilter>(
      context,
      title: context.l10n.exploreFiltersTitle,
      content: ExploreFilterSheet(initial: current),
    );
    if (next != null) {
      ref.read(exploreFilterProvider.notifier).update((_) => next);
    }
  }

  Future<void> _setSort(ExploreSort sort) async {
    final notifier = ref.read(exploreFilterProvider.notifier);
    if (sort == ExploreSort.distance &&
        ref.read(myLocationProvider).valueOrNull == null) {
      final ok = await ref.read(myLocationProvider.notifier).locate();
      if (!mounted) return;
      if (!ok) {
        final error = ref.read(myLocationProvider).error;
        final failure = error is AppException
            ? error
            : const LocationUnavailableException();
        showAppSnackBar(
          context,
          failure.messageIn(context.l10n),
          tone: SnackTone.error,
        );
        return;
      }
    }
    notifier.update((f) => f.copyWith(sort: sort));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final results = ref.watch(exploreResultsProvider);
    final filter = ref.watch(exploreFilterProvider);
    final locating = ref.watch(myLocationProvider).isLoading;

    final controls = <Widget>[
      TourAnchor(
        id: TourIds.search,
        child: SearchField(
          hintText: l.homeSearchHint,
          onChanged: (v) => ref
              .read(exploreFilterProvider.notifier)
              .update((f) => f.copyWith(query: v)),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      TourAnchor(
        id: TourIds.filters,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ActionChip(
                avatar: const Icon(Icons.tune, size: AppSizes.iconSm),
                label: Text(
                  filter.activeCount == 0
                      ? l.exploreFiltersTitle
                      : l.exploreFiltersCount(filter.activeCount),
                ),
                onPressed: _openFilters,
              ),
              const SizedBox(width: AppSpacing.md),
              for (final s in ExploreSort.values) ...[
                ChoiceChip(
                  avatar: s == ExploreSort.distance && locating
                      ? const SizedBox.square(
                          dimension: AppSizes.iconSm,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  label: Text(switch (s) {
                    ExploreSort.name => l.sortByName,
                    ExploreSort.price => l.sortByPrice,
                    ExploreSort.distance => l.sortByDistance,
                  }),
                  selected: filter.sort == s,
                  onSelected: locating ? null : (_) => _setSort(s),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
        ),
      ),
      if (filter.hasTime) ...[
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: InputChip(
            avatar: const Icon(Icons.schedule, size: AppSizes.iconSm),
            label: Text(l.exploreFreeAtChip(
              DisplayFormat.dayLabel(filter.date!, l),
              formatMinuteOfDay(filter.startMinute!),
            )),
            onDeleted: () => ref.read(exploreFilterProvider.notifier).update(
                  (f) => f.copyWith(date: () => null, startMinute: () => null),
                ),
          ),
        ),
      ],
      const SizedBox(height: AppSpacing.lg),
    ];

    final Widget resultsView = switch (results) {
      AsyncValue(:final valueOrNull?) when !results.isLoading => _showMap
          ? StadiumsMap(
              hits: valueOrNull,
              me: ref.watch(myLocationProvider).valueOrNull,
            )
          : _Results(hits: valueOrNull, onClear: _clearFilters),
      AsyncValue(:final error?) => ErrorView.inline(
          error: error is AppException ? error : UnknownException(cause: error),
          onRetry: () => ref.invalidate(publishedStadiumsProvider),
        ),
      _ => Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: LoadingView(
            caption: filter.hasTime ? l.exploreCheckingTimes : null,
          ),
        ),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navExplore),
        actions: [
          IconButton(
            tooltip: _showMap ? l.exploreShowList : l.exploreShowMap,
            icon: Icon(_showMap ? Icons.view_list : Icons.map_outlined),
            onPressed: () => setState(() => _showMap = !_showMap),
          ),
          const TourHelpButton(),
        ],
      ),
      body: _showMap
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: controls,
                  ),
                ),
                Expanded(child: resultsView),
              ],
            )
          : PageBody(children: [...controls, resultsView]),
    );
  }

  void _clearFilters() =>
      ref.read(exploreFilterProvider.notifier).update((f) => f.cleared());
}

class _Results extends StatelessWidget {
  const _Results({required this.hits, required this.onClear});

  final List<ExploreHit> hits;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (hits.isEmpty) {
      return Column(
        children: [
          EmptyView.inline(
            icon: Icons.search_off,
            title: l.exploreEmptyTitle,
            message: l.exploreEmptyMessage,
          ),
          TextButton(onPressed: onClear, child: Text(l.exploreClearFilters)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final h in hits) ...[
          StadiumListCard(stadium: h.stadium, distanceKm: h.distanceKm),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
