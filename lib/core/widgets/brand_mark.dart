import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context_ext.dart';

/// App logo: a deep navy tile with a gold ball icon, optionally followed
/// by the uppercase wordmark. Used on auth screens.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.showWordmark = false});

  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final mark = Container(
      width: AppSizes.logoFrame,
      height: AppSizes.logoFrame,
      decoration: BoxDecoration(
        gradient: context.gradients.hero,
        borderRadius: AppRadius.lgAll,
        boxShadow: context.depth.raised(),
      ),
      child: Icon(
        Icons.sports_soccer,
        size: AppSizes.iconXl,
        color: context.gradients.gold,
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
                // Myanmar wordmark: no letter spacing (it splits vowel signs
                // from their consonants) and no case change.
                Text(
                  AppConstants.appName,
                  style: AppTypography.overline(context.textStyles.labelMedium!)
                      .copyWith(
                    fontSize: 15,
                    letterSpacing: 0,
                    color: colors.onSurface,
                  ),
                ),
              ],
            )
          : mark,
    );
  }
}
