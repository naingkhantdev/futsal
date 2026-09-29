import 'package:flutter/material.dart';

import '../theme/app_depth.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context_ext.dart';
import 'motion.dart';

/// Dashboard KPI (design_system.md §0): a flat tile (fill + hairline, no
/// shadow) where the number leads. A small muted [icon] + [label] on top,
/// the large tabular [value], an optional [footer]. [highlight] marks a
/// number that needs attention (pending requests) with a gold border and a
/// dot, never color alone: the [footer] says why. Visual shell only.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.footer,
    this.highlight = false,
    this.onTap,
  });

  final IconData icon;

  /// Pre-formatted value, e.g. "12" or "MMK 240,000".
  final String value;
  final String label;

  /// e.g. "+3 today", "need a reply".
  final String? footer;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    final g = context.gradients;
    final depth = context.depth;
    final muted = colors.onSurfaceVariant;

    final content = Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSizes.iconSm, color: muted),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styles.labelLarge?.copyWith(color: muted),
                ),
              ),
              if (highlight) ...[
                const SizedBox(width: AppSpacing.xs),
                Container(
                  width: AppSizes.statDot,
                  height: AppSizes.statDot,
                  decoration:
                      BoxDecoration(color: g.gold, shape: BoxShape.circle),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.tabular(styles.displaySmall!)
                .copyWith(color: colors.onSurface),
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              footer!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: styles.bodySmall?.copyWith(
                color: highlight ? colors.secondary : muted,
              ),
            ),
          ],
        ],
      ),
    );

    final card = DecoratedBox(
      decoration: depth.raisedDecoration(level: DepthLevel.low).copyWith(
            border: Border.all(
              color: highlight ? g.gold : depth.edge,
              width: highlight ? AppSizes.borderFocus : AppSizes.borderThin,
            ),
          ),
      child: ClipRRect(
        borderRadius: AppRadius.lgAll,
        child: Material(
          type: MaterialType.transparency,
          child: onTap == null
              ? content
              : InkWell(onTap: onTap, child: content),
        ),
      ),
    );
    return Pressable(enabled: onTap != null, child: card);
  }
}
