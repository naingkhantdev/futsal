import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context_ext.dart';
import '../utils/date_key.dart';
import '../utils/display_format.dart';

/// Horizontal day picker: [days] consecutive days from today, each a tile
/// with the weekday ("Today" for today) over a large day number. The
/// selected day is filled navy, bold and announced as selected, so it is
/// not shown by color alone. Tiles are 56 × 72 (≥ 48dp targets).
class DayStrip extends StatelessWidget {
  const DayStrip({
    super.key,
    required this.selected,
    required this.onSelected,
    this.days = 7,
  });

  /// Selected date key (`yyyy-MM-dd`).
  final String selected;
  final ValueChanged<String> onSelected;
  final int days;

  static const double _tileWidth = 56;
  static const double _tileHeight = 72;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final keys = [
      for (var i = 0; i < days; i++)
        DateKey.fromDate(today.add(Duration(days: i))),
    ];
    final scaler = MediaQuery.textScalerOf(context)
        .clamp(maxScaleFactor: AppSizes.compactTextScaleCap);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: scaler),
      child: SizedBox(
        height: _tileHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: keys.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, i) => _DayTile(
            dateKey: keys[i],
            isToday: i == 0,
            selected: keys[i] == selected,
            onTap: () => onSelected(keys[i]),
          ),
        ),
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    required this.dateKey,
    required this.isToday,
    required this.selected,
    required this.onTap,
  });

  final String dateKey;
  final bool isToday;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final depth = context.depth;
    final styles = context.textStyles;
    final l = context.l10n;
    final fg = selected ? c.onPrimary : c.onSurface;
    final sub = selected ? c.onPrimary : c.onSurfaceVariant;
    final animate = !MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      selected: selected,
      label: DisplayFormat.dayLabel(dateKey, l),
      excludeSemantics: true,
      onTap: onTap,
      child: AnimatedContainer(
        duration: animate ? AppMotion.state : Duration.zero,
        curve: AppMotion.curve,
        width: DayStrip._tileWidth,
        decoration: BoxDecoration(
          color: selected ? c.primary : depth.base,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: selected ? c.primary : depth.edge),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.mdAll,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isToday ? l.dayToday : DisplayFormat.weekday(dateKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styles.labelSmall?.copyWith(color: sub),
                ),
                Text(
                  DisplayFormat.dayOfMonth(dateKey),
                  style: AppTypography.tabular(styles.titleLarge!).copyWith(
                    color: fg,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
