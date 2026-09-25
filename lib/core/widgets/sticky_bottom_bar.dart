import 'package:flutter/material.dart';

import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Bottom bar for booking summaries + primary CTA: `surfaceContainerLow`,
/// 1dp top border, safe-area padding. Use as `Scaffold.bottomNavigationBar`.
class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: child,
        ),
      ),
    );
  }
}
