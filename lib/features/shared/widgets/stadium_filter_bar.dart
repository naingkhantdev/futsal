import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/vos/booking_vo.dart';

/// "All stadiums · Stadium A · Stadium B" chips above a booking list.
/// Stadiums come from the bookings themselves (name snapshots), so the bar
/// only offers stadiums that have bookings. Hidden when there is only one.
class StadiumFilterBar extends StatelessWidget {
  const StadiumFilterBar({
    super.key,
    required this.bookings,
    required this.selected,
    required this.onSelected,
  });

  final List<BookingVO> bookings;

  /// Selected stadium id; `null` = all.
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final stadiums = <String, String>{};
    final counts = <String, int>{};
    for (final b in bookings) {
      stadiums[b.stadiumId] = b.stadiumNameSnapshot;
      counts[b.stadiumId] = (counts[b.stadiumId] ?? 0) + 1;
    }
    if (stadiums.length < 2) return const SizedBox.shrink();

    final entries = stadiums.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: SizedBox(
        height: AppSizes.minTouchTarget,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ChoiceChip(
              avatar: const Icon(Icons.stadium_outlined, size: AppSizes.iconSm),
              label: Text(context.l10n.allStadiums(bookings.length)),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
            for (final e in entries) ...[
              const SizedBox(width: AppSpacing.sm),
              ChoiceChip(
                label: Text('${e.value} (${counts[e.key]})'),
                selected: selected == e.key,
                onSelected: (_) => onSelected(e.key),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
