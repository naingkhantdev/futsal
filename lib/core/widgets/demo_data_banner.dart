import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Slim notice on screens that still show sample data (`DemoData`), so a
/// preview is never mistaken for live data. Remove when the screen is wired.
class DemoDataBanner extends StatelessWidget {
  const DemoDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.appColors.infoContainer,
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        children: [
          Icon(
            Icons.science_outlined,
            size: AppSizes.iconSm,
            color: context.appColors.onInfoContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.demoBanner,
              style: context.textStyles.labelMedium?.copyWith(
                color: context.appColors.onInfoContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
