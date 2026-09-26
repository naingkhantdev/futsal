import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/status_tone.dart';
import '../theme/theme_context_ext.dart';
import 'app_card.dart';

/// Dashboard KPI card (design_system.md §5.3). Visual shell only.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.footer,
    this.tone = StatusTone.brand,
    this.onTap,
  });

  final IconData icon;

  /// Pre-formatted value, e.g. "12" or "MMK 240,000".
  final String value;
  final String label;

  /// e.g. "+3 today".
  final String? footer;

  /// Icon circle colors; use `warning` for attention counts (pending, etc.).
  final StatusTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final toneColors = tone.colorsFor(context);
    final styles = context.textStyles;
    final colors = context.colors;
    // Brand / neutral stay monochrome; attention tones keep their hue.
    final iconColor = tone == StatusTone.brand || tone == StatusTone.neutral
        ? colors.onSurface
        : toneColors.foreground;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg + AppSpacing.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  semanticsLabel: label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.overline(styles.labelSmall!)
                      .copyWith(color: colors.onSurfaceVariant),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: AppSizes.statIconCircle,
                height: AppSizes.statIconCircle,
                decoration:
                    context.depth.wellDecoration(borderRadius: AppRadius.fullAll),
                child: Icon(icon, size: AppSizes.iconMd, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.tabular(styles.headlineLarge!),
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              footer!,
              style: styles.labelMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
