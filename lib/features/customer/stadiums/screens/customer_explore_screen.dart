import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/page_body.dart';
import '../providers/customer_venue_providers.dart';
import '../widgets/stadium_list_card.dart';

/// `/customer/explore` — CUSTOMER scope: search and filter published
/// stadiums.
class CustomerExploreScreen extends ConsumerStatefulWidget {
  const CustomerExploreScreen({super.key});

  @override
  ConsumerState<CustomerExploreScreen> createState() =>
      _CustomerExploreScreenState();
}

class _CustomerExploreScreenState extends ConsumerState<CustomerExploreScreen> {
  static const List<Facility> _filters = [
    Facility.floodLights,
    Facility.parking,
    Facility.shower,
  ];

  String _query = '';
  final Set<Facility> _selected = {};

  @override
  Widget build(BuildContext context) {
    final stadiums = ref.watch(publishedStadiumsProvider);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.navExplore),
        actions: const [TourHelpButton()],
      ),
      body: PageBody(
        children: [
          TourAnchor(
            id: TourIds.search,
            child: SearchField(
              hintText: l.homeSearchHint,
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TourAnchor(
            id: TourIds.filters,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final f in _filters)
                  FilterChip(
                    label: Text(f.labelIn(l)),
                    selected: _selected.contains(f),
                    onSelected: (on) => setState(
                      () => on ? _selected.add(f) : _selected.remove(f),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          switch (stadiums) {
            AsyncValue(:final valueOrNull?) => _Results(
                stadiums: _filter(valueOrNull),
              ),
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
        ],
      ),
    );
  }

  List<StadiumVO> _filter(List<StadiumVO> all) {
    final q = _query.trim().toLowerCase();
    return all.where((s) {
      final text = '${s.name} ${s.township ?? ''} ${s.city ?? ''}'.toLowerCase();
      return (q.isEmpty || text.contains(q)) &&
          _selected.every(s.facilities.contains);
    }).toList();
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.stadiums});

  final List<StadiumVO> stadiums;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (stadiums.isEmpty) {
      return EmptyView.inline(
        icon: Icons.search_off,
        title: l.exploreEmptyTitle,
        message: l.exploreEmptyMessage,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final stadium in stadiums) ...[
          StadiumListCard(stadium: stadium),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
