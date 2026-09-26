import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_depth.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context_ext.dart';

/// App logo: an ink tile inside a raised neumorphic frame, optionally
/// followed by the uppercase wordmark. Used on splash and auth screens.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.showWordmark = false});

  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final depth = context.depth;
    final mark = Container(
      width: AppSizes.logoFrame,
      height: AppSizes.logoFrame,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: depth.raisedDecoration(
        level: DepthLevel.high,
        borderRadius: AppRadius.lgAll,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: AppRadius.mdAll,
        ),
        child: Icon(
          Icons.sports_soccer,
          size: AppSizes.iconXl,
          color: colors.onPrimary,
        ),
      ),
    );

    return Semantics(
      label: AppConstants.appName,
      excludeSemantics: true,
      child: showWordmark
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                mark,
                const SizedBox(width: AppSpacing.lg),
                Text(
                  AppConstants.appName.toUpperCase(),
                  style: AppTypography.overline(context.textStyles.labelMedium!)
                      .copyWith(fontSize: 13, color: colors.onSurface),
                ),
              ],
            )
          : mark,
    );
  }
}
