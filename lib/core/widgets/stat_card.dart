import 'package:flutter/material.dart';

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
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.statIconCircle,
            height: AppSizes.statIconCircle,
            decoration: BoxDecoration(
              color: toneColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: AppSizes.iconMd, color: toneColors.foreground),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTypography.tabular(styles.headlineSmall!)),
          Text(
            label,
            style: styles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(footer!, style: styles.labelMedium),
          ],
        ],
      ),
    );
  }
}
