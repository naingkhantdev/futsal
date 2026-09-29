import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Quiet note on screens that still show sample data (`DemoData`), so a
/// preview is never mistaken for live data. A hairline and one muted line
/// at the end of the content: present, but not the first thing a
/// customer reads. Remove when the screen is wired.
class DemoDataBanner extends StatelessWidget {
  const DemoDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxs),
              child: Icon(Icons.info_outline, size: AppSizes.iconSm, color: muted),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.demoBanner,
                style: context.textStyles.bodySmall?.copyWith(color: muted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
