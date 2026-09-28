import 'package:flutter/material.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/preview_body.dart';
import '../widgets/stadium_list_card.dart';

/// `/customer/explore` — CUSTOMER scope: search and filter published
/// stadiums. PREVIEW: sample data (`DemoData`) until Phase 6.
class CustomerExploreScreen extends StatefulWidget {
  const CustomerExploreScreen({super.key});

  @override
  State<CustomerExploreScreen> createState() => _CustomerExploreScreenState();
}

class _CustomerExploreScreenState extends State<CustomerExploreScreen> {
  static const List<Facility> _filters = [
    Facility.floodLights,
    Facility.parking,
    Facility.shower,
  ];

  String _query = '';
  final Set<Facility> _selected = {};

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = DemoData.stadiums.where((s) {
      final text = '${s.name} ${s.township ?? ''} ${s.city ?? ''}'.toLowerCase();
      return (q.isEmpty || text.contains(q)) &&
          _selected.every(s.facilities.contains);
    }).toList();

    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.navExplore)),
      body: PreviewBody(
        children: [
          SearchField(
            hintText: l.homeSearchHint,
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
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
          const SizedBox(height: AppSpacing.lg),
          if (results.isEmpty)
            EmptyView.inline(
              icon: Icons.search_off,
              title: l.exploreEmptyTitle,
              message: l.exploreEmptyMessage,
            )
          else
            for (final stadium in results) ...[
              StadiumListCard(stadium: stadium),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}
