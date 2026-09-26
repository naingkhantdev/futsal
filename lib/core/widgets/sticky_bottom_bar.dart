import 'package:flutter/material.dart';

import '../theme/app_depth.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Bottom bar for booking summaries + primary CTA: floats on the surface with
/// rounded top corners and a soft upward shadow, safe-area padding. Use as
/// `Scaffold.bottomNavigationBar`.
class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final depth = context.depth;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: depth.base,
        borderRadius: AppRadius.xlTop,
        boxShadow: [
          BoxShadow(
            color: depth.shade.withOpacity(0.45),
            offset: Offset(0, -DepthLevel.low.distance),
            blurRadius: DepthLevel.high.blur,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.md,
          ),
          child: child,
        ),
      ),
    );
  }
}
