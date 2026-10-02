import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/motion.dart';
import '../../shell/widgets/superadmin_shell.dart';

/// Superadmin "control console" look (PLATFORM scope only): a navy app bar
/// that runs into a navy summary band, then dense, hairline-ruled tables and
/// record panels on the plain surface. Customer / shop-admin screens keep
/// the card look; nothing here is used outside `features/superadmin`.
///
/// Colors come from the theme tokens (`context.gradients`, `context.depth`);
/// [ConsolePalette] only picks which ones the console uses.
@immutable
class ConsolePalette {
  const ConsolePalette._({
    required this.band,
    required this.onBand,
    required this.onBandMuted,
    required this.accent,
    required this.rule,
    required this.headFill,
    required this.muted,
  });

  factory ConsolePalette.of(BuildContext context) {
    final g = context.gradients;
    final d = context.depth;
    return ConsolePalette._(
      band: g.hero.colors[1],
      onBand: g.onHero,
      onBandMuted: g.onHeroMuted,
      accent: g.gold,
      rule: d.edge,
      headFill: d.well,
      muted: context.colors.onSurfaceVariant,
    );
  }

  /// Navy fill of the app bar + summary band.
  final Color band;
  final Color onBand;
  final Color onBandMuted;

  /// Gold: band overline, "needs attention" marks.
  final Color accent;

  /// Hairlines between rows and around panels.
  final Color rule;

  /// Table header / panel header strip.
  final Color headFill;
  final Color muted;
}

/// Navy app bar. On a shell root it shows the ☰ menu (phones); pushed
/// pages get the usual back arrow.
class ConsoleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ConsoleAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    return AppBar(
      leading: SuperadminMenuButton.maybeOf(context),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: actions,
      backgroundColor: p.band,
      foregroundColor: p.onBand,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: context.textStyles.titleMedium?.copyWith(
        color: p.onBand,
        fontWeight: FontWeight.w700,
      ),
      actionsIconTheme: IconThemeData(color: p.onBand),
      iconTheme: IconThemeData(color: p.onBand),
    );
  }
}

/// Compact app-bar action with a label (e.g. "+ New shop").
class ConsoleBarAction extends StatelessWidget {
  const ConsoleBarAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    // Icon only on phones; icon + label from 600dp.
    if (context.isCompact) {
      return IconButton(tooltip: label, icon: Icon(icon), onPressed: onPressed);
    }
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: AppSizes.iconMd),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: p.onBand,
          side: BorderSide(color: p.accent.withOpacity(0.7)),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}

/// One figure in the [ConsoleBand].
class ConsoleMetric {
  const ConsoleMetric({
    required this.value,
    required this.label,
    this.onTap,
    this.attention = false,
  });

  final String value;
  final String label;
  final VoidCallback? onTap;

  /// Needs action (e.g. shops to review): gold rule + dot marker.
  final bool attention;
}

/// Navy summary band under the [ConsoleAppBar]: gold overline
/// ("PLATFORM · SHOPS"), optional title / subtitle / badges, and a row of
/// [ConsoleMetric]s.
class ConsoleBand extends StatelessWidget {
  const ConsoleBand({
    super.key,
    required this.overline,
    this.title,
    this.subtitle,
    this.badges = const [],
    this.metrics = const [],
    this.width = ContentWidth.dashboard,
  });

  final String overline;
  final String? title;
  final String? subtitle;

  /// Shown under the title, e.g. status badges of a record.
  final List<Widget> badges;
  final List<ConsoleMetric> metrics;
  final ContentWidth width;

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    final text = context.textStyles;
    // Material (not a colored box) so tappable metrics show their ink.
    return Material(
      color: p.band,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: p.accent, width: AppSizes.borderThick),
          ),
        ),
        padding: const EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: AppSpacing.lg,
        ),
        child: ContentConstraint(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overline.toUpperCase(),
                style: AppTypography.overline(text.labelSmall!)
                    .copyWith(color: p.accent),
              ),
              if (title != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  title!,
                  style: text.headlineSmall?.copyWith(
                    color: p.onBand,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style: text.bodyMedium?.copyWith(color: p.onBandMuted),
                ),
              ],
              if (badges.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                // Badges keep their own light pill so they read on navy.
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: badges,
                ),
              ],
              if (metrics.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (i, m) in metrics.indexed) ...[
                        if (i > 0)
                          Container(
                            width: AppSizes.borderThin,
                            height: AppSpacing.xxxl - AppSpacing.sm,
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            color: p.onBand.withOpacity(0.14),
                          ),
                        _MetricCell(metric: m, palette: p),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.metric, required this.palette});

  final ConsoleMetric metric;
  final ConsolePalette palette;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final p = palette;
    final cell = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                metric.value,
                style: text.headlineSmall?.copyWith(
                  color: metric.attention ? p.accent : p.onBand,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (metric.attention) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.error_outline,
                    size: AppSizes.iconSm, color: p.accent),
              ],
            ],
          ),
          Text(
            metric.label,
            style: text.labelMedium?.copyWith(color: p.onBandMuted),
          ),
        ],
      ),
    );
    if (metric.onTap == null) return cell;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: metric.onTap,
        borderRadius: AppRadius.smAll,
        child: cell,
      ),
    );
  }
}

/// Search / filter strip under the band: plain surface, hairline below.
class ConsoleToolbar extends StatelessWidget {
  const ConsoleToolbar({
    super.key,
    this.search,
    this.filters = const [],
    this.width = ContentWidth.dashboard,
  });

  final Widget? search;
  final List<Widget> filters;
  final ContentWidth width;

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.depth.base,
        border: Border(bottom: BorderSide(color: p.rule)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: ContentConstraint(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (search != null) search!,
              if (search != null && filters.isNotEmpty)
                const SizedBox(height: AppSpacing.md),
              if (filters.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final (i, f) in filters.indexed) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.sm),
                        f,
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square-cornered filter chip with its count, e.g. "Pending  3".
class ConsoleFilterChip extends StatelessWidget {
  const ConsoleFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.count,
  });

  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(count == null ? label : '$label  $count'),
      selected: selected,
      showCheckmark: true,
      onSelected: (_) => onSelected(),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// A table column. [flex] sets its share of the row; columns with
/// `compact: false` are dropped below 600dp (the first column should
/// carry enough to stand alone).
class ConsoleColumn {
  const ConsoleColumn(
    this.label, {
    this.flex = 1,
    this.compact = true,
    this.alignEnd = false,
  });

  final String label;
  final int flex;
  final bool compact;
  final bool alignEnd;
}

/// One table row: one cell per [ConsoleColumn], same order.
class ConsoleRow {
  const ConsoleRow({required this.cells, this.onTap, this.trailing});

  final List<Widget> cells;
  final VoidCallback? onTap;

  /// Fixed-width end widget (e.g. a remove button). Rows with [onTap] and no
  /// [trailing] show a chevron.
  final Widget? trailing;
}

/// Dense, hairline-ruled table inside a bordered frame with a header row.
class ConsoleTable extends StatelessWidget {
  const ConsoleTable({
    super.key,
    required this.columns,
    required this.rows,
    this.animate = true,
  });

  final List<ConsoleColumn> columns;
  final List<ConsoleRow> rows;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    final compact = context.isCompact;
    final shown = [
      for (final (i, c) in columns.indexed)
        if (!compact || c.compact) i,
    ];
    final text = context.textStyles;
    final hasTrailing = rows.any((r) => r.onTap != null || r.trailing != null);

    Widget cellBox(int col, Widget child) {
      final c = columns[col];
      return Expanded(
        flex: c.flex,
        child: Align(
          alignment: c.alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: child,
        ),
      );
    }

    return _Frame(
      palette: p,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row: decorative for screen readers (cells carry meaning).
          ExcludeSemantics(
            child: Container(
              color: p.headFill,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  for (final i in shown)
                    cellBox(
                      i,
                      Text(
                        columns[i].label.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.overline(text.labelSmall!)
                            .copyWith(color: p.muted),
                      ),
                    ),
                  if (hasTrailing)
                    const SizedBox(width: AppSizes.minTouchTarget),
                ],
              ),
            ),
          ),
          for (final (r, row) in rows.indexed) ...[
            Divider(height: 1, thickness: 1, color: p.rule),
            _maybeAnimate(
              r,
              InkWell(
                onTap: row.onTap,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppSizes.minTouchTarget + AppSpacing.sm,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.lg,
                      top: AppSpacing.sm,
                      bottom: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        for (final i in shown)
                          cellBox(
                            i,
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: AppSpacing.md),
                              child: row.cells[i],
                            ),
                          ),
                        if (hasTrailing)
                          SizedBox(
                            width: AppSizes.minTouchTarget,
                            child: row.trailing ??
                                (row.onTap == null
                                    ? null
                                    : Icon(Icons.chevron_right,
                                        color: p.muted)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _maybeAnimate(int index, Widget child) =>
      animate ? FadeSlideIn(index: index, child: child) : child;
}

/// Primary text of a table cell, with an optional muted second line.
class ConsoleCellText extends StatelessWidget {
  const ConsoleCellText(this.primary,
      {super.key, this.secondary, this.strong = false});

  final String primary;
  final String? secondary;

  /// Bold first line (the record's name).
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          primary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.bodyMedium?.copyWith(
            fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        if (secondary != null && secondary!.isNotEmpty)
          Text(
            secondary!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
      ],
    );
  }
}

/// Bordered record panel with a header strip (overline title + optional
/// action). Used for detail pages, the dashboard and settings.
class ConsolePanel extends StatelessWidget {
  const ConsolePanel({
    super.key,
    required this.title,
    required this.child,
    this.action,
    this.padded = false,
  });

  final String title;
  final Widget child;
  final Widget? action;

  /// Pad [child] (free content); rows ([ConsoleField], tiles) bring their own.
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    final text = context.textStyles;
    return _Frame(
      palette: p,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: p.headFill,
            constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget - AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title.toUpperCase(),
                      style: AppTypography.overline(text.labelSmall!)
                          .copyWith(color: p.muted),
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: p.rule),
          padded
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: child,
                )
              : child,
        ],
      ),
    );
  }
}

/// Label / value line inside a [ConsolePanel], ruled underneath.
class ConsoleField extends StatelessWidget {
  const ConsoleField({
    super.key,
    required this.label,
    this.value,
    this.child,
    this.onTap,
    this.last = false,
  });

  final String label;

  /// Shown as text; `null`/blank shows a dash. Ignored when [child] is set.
  final String? value;
  final Widget? child;
  final VoidCallback? onTap;

  /// No rule under the last field of a panel.
  final bool last;

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    final text = context.textStyles;
    final v = value?.trim();
    final shown = child ??
        Text(
          v == null || v.isEmpty ? '—' : v,
          style: text.bodyMedium?.copyWith(
            color: v == null || v.isEmpty ? p.muted : null,
            fontWeight: FontWeight.w500,
          ),
        );
    final labelWidth = context.isCompact
        ? AppSizes.consoleLabelCompact
        : AppSizes.consoleLabelWide;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: last ? null : Border(bottom: BorderSide(color: p.rule)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: labelWidth,
              child: Text(
                label,
                style: text.bodySmall?.copyWith(color: p.muted),
              ),
            ),
            Expanded(child: shown),
            if (onTap != null)
              Icon(Icons.chevron_right, size: AppSizes.iconMd, color: p.muted),
          ],
        ),
      ),
    );
  }
}

/// Plain action row inside a [ConsolePanel] (icon, label, chevron).
class ConsoleLinkRow extends StatelessWidget {
  const ConsoleLinkRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.detail,
    this.last = false,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final String? detail;
  final VoidCallback onTap;
  final bool last;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    final color = destructive ? context.colors.error : null;
    return Container(
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: p.rule)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? p.muted),
        title: Text(
          label,
          style: context.textStyles.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: detail == null ? null : Text(detail!),
        trailing:
            destructive ? null : Icon(Icons.chevron_right, color: p.muted),
        onTap: onTap,
      ),
    );
  }
}

/// Scrolling page body under a band/toolbar: centered column and entrance
/// motion.
class ConsoleBody extends StatelessWidget {
  const ConsoleBody({
    super.key,
    required this.children,
    this.width = ContentWidth.dashboard,
    this.header,
    this.bottomPadding = AppSpacing.xxxl,
  });

  final List<Widget> children;
  final ContentWidth width;

  /// Full-width widget scrolled with the content (e.g. a [ConsoleBand] on
  /// record pages, so it doesn't eat a phone screen).
  final Widget? header;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return EntranceScope(
      child: ListView(
        padding: EdgeInsets.only(bottom: bottomPadding),
        children: [
          if (header != null) header!,
          const SizedBox(height: AppSpacing.xl),
          FadeSlideIn(
            child: ContentConstraint(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lays [children] out in two columns at ≥ 840dp, one column below.
class ConsoleColumns extends StatelessWidget {
  const ConsoleColumns({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (!context.isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, c) in children.indexed) ...[
            if (i > 0) const SizedBox(height: AppSpacing.lg),
            c,
          ],
        ],
      );
    }
    final left = [for (var i = 0; i < children.length; i += 2) children[i]];
    final right = [for (var i = 1; i < children.length; i += 2) children[i]];
    Widget col(List<Widget> items) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, c) in items.indexed) ...[
                if (i > 0) const SizedBox(height: AppSpacing.lg),
                c,
              ],
            ],
          ),
        );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        col(left),
        const SizedBox(width: AppSpacing.lg),
        col(right),
      ],
    );
  }
}

/// Bordered surface for tables and panels; a [Material] so row ink shows.
class _Frame extends StatelessWidget {
  const _Frame({required this.palette, required this.child});

  final ConsolePalette palette;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.depth.base,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: palette.rule),
        borderRadius: AppRadius.smAll,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// Heading above a table: overline title, optional count and action.
class ConsoleHeading extends StatelessWidget {
  const ConsoleHeading(this.title, {super.key, this.count, this.action});

  final String title;
  final int? count;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final p = ConsolePalette.of(context);
    final text = context.textStyles;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTouchTarget),
        child: Row(
          children: [
            Semantics(
              header: true,
              child: Text(
                title.toUpperCase(),
                style: AppTypography.overline(text.labelMedium!)
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                '$count',
                style: text.labelMedium?.copyWith(color: p.muted),
              ),
            ],
            const Spacer(),
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}

/// Space between stacked panels / tables.
const consoleGap = SizedBox(height: AppSpacing.lg);
