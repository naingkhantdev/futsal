import 'package:flutter/material.dart';

import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Max-width presets (design_system.md §4.4).
enum ContentWidth {
  auth(AppSizes.maxWidthAuth),
  form(AppSizes.maxWidthForm),
  list(AppSizes.maxWidthList),
  dashboard(AppSizes.maxWidthDashboard);

  const ContentWidth(this.maxWidth);
  final double maxWidth;
}

/// Centers [child] at a max width with a responsive side gutter
/// (16 compact / 24 otherwise). Background stays `surface`.
class ContentConstraint extends StatelessWidget {
  const ContentConstraint({
    super.key,
    required this.child,
    this.width = ContentWidth.list,
    this.applyGutter = true,
  });

  final Widget child;
  final ContentWidth width;
  final bool applyGutter;

  @override
  Widget build(BuildContext context) {
    final gutter = context.isCompact ? AppSpacing.lg : AppSpacing.xl;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width.maxWidth),
        child: applyGutter
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                child: child,
              )
            : child,
      ),
    );
  }
}
