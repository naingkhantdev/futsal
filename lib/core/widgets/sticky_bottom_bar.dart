import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Bottom bar for booking summaries + primary CTA: white, hairline on top,
/// safe-area padding. Use as `Scaffold.bottomNavigationBar`.
class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final depth = context.depth;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: depth.base,
        border: Border(top: BorderSide(color: depth.edge)),
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
