import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Editorial page intro for dashboards: a small gold [eyebrow] (e.g.
/// today's date), a large left-aligned [title], a muted [subtitle], an
/// optional [trailing] widget and [bottom] (search field, chips).
///
/// Deliberately not a box: type and space make the hierarchy, and the page
/// content right below it is the focus.
class HeroHeader extends StatelessWidget {
  const HeroHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.trailing,
    this.bottom,
  });

  final String title;
  final String? eyebrow;
  final String? subtitle;
  final Widget? trailing;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (eyebrow != null) ...[
                      Text(
                        eyebrow!,
                        style: styles.labelLarge
                            ?.copyWith(color: colors.secondary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                    ],
                    Semantics(
                      header: true,
                      child: Text(title, style: styles.headlineLarge),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: styles.bodyLarge
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.md),
                trailing!,
              ],
            ],
          ),
          if (bottom != null) ...[
            const SizedBox(height: AppSpacing.lg),
            bottom!,
          ],
        ],
      ),
    );
  }
}
