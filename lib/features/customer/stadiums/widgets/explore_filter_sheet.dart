import 'package:flutter/material.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/constants/domain_labels.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/day_strip.dart';
import '../providers/explore_providers.dart';

/// Explore filters (bottom sheet content). Edits a draft and pops it on
/// Apply; dismissing the sheet changes nothing.
class ExploreFilterSheet extends StatefulWidget {
  const ExploreFilterSheet({super.key, required this.initial});

  final ExploreFilter initial;

  @override
  State<ExploreFilterSheet> createState() => _ExploreFilterSheetState();
}

class _ExploreFilterSheetState extends State<ExploreFilterSheet> {
  late ExploreFilter _draft = widget.initial;

  /// Defaults for the "free at" picker: today, next whole hour.
  static String get _today => DateKey.fromDate(DateTime.now());
  static int get _nextHour {
    final next = (DateTime.now().hour + 1) * 60;
    final options = ExploreFilter.startMinuteOptions;
    return options.contains(next) ? next : options.first;
  }

  void _set(ExploreFilter Function(ExploreFilter) change) =>
      setState(() => _draft = change(_draft));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;

    Widget title(String text) => Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xl,
            bottom: AppSpacing.sm,
          ),
          child: Text(text, style: styles.titleSmall),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.exploreFreeAtTitle),
          subtitle: Text(l.exploreFreeAtSub),
          value: _draft.hasTime,
          onChanged: (on) => _set(
            (f) => on
                ? f.copyWith(
                    date: () => _today,
                    startMinute: () => _nextHour,
                  )
                : f.copyWith(date: () => null, startMinute: () => null),
          ),
        ),
        if (_draft.hasTime) ...[
          const SizedBox(height: AppSpacing.sm),
          DayStrip(
            selected: _draft.date!,
            onSelected: (d) => _set((f) => f.copyWith(date: () => d)),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<int>(
            value: _draft.startMinute,
            decoration: InputDecoration(
              labelText: l.exploreStartTime,
              prefixIcon: const Icon(Icons.schedule, size: AppSizes.iconLg),
            ),
            items: [
              for (final m in ExploreFilter.startMinuteOptions)
                DropdownMenuItem(value: m, child: Text(formatMinuteOfDay(m))),
            ],
            onChanged: (m) => _set((f) => f.copyWith(startMinute: () => m)),
          ),
        ],
        title(l.exploreMaxPrice),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final p in <int?>[null, ...ExploreFilter.priceSteps])
              ChoiceChip(
                label: Text(p == null
                    ? l.exploreAnyPrice
                    : l.explorePriceUpTo(Money.formatMmk(p))),
                selected: _draft.maxPrice == p,
                onSelected: (_) => _set((f) => f.copyWith(maxPrice: () => p)),
              ),
          ],
        ),
        title(l.surfaceOptional),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final s in CourtSurface.values)
              FilterChip(
                label: Text(s.labelIn(l)),
                selected: _draft.surfaces.contains(s),
                onSelected: (on) => _set((f) => f.copyWith(
                      surfaces: on
                          ? {...f.surfaces, s}
                          : ({...f.surfaces}..remove(s)),
                    )),
              ),
          ],
        ),
        title(l.facilitiesTitle),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final fac in Facility.values)
              FilterChip(
                avatar: Icon(fac.icon, size: AppSizes.iconSm),
                label: Text(fac.labelIn(l)),
                selected: _draft.facilities.contains(fac),
                onSelected: (on) => _set((f) => f.copyWith(
                      facilities: on
                          ? {...f.facilities, fac}
                          : ({...f.facilities}..remove(fac)),
                    )),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l.exploreFilterNote,
          style: styles.bodySmall?.copyWith(color: muted),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: l.exploreClearFilters,
                onPressed: () => _set((f) => f.cleared()),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: PrimaryButton(
                label: l.exploreApply,
                onPressed: () => Navigator.of(context).pop(_draft),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
