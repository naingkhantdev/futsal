import 'package:flutter/material.dart';

import '../theme/app_depth.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Base card: white surface with a hairline border on the off-white page,
/// no shadow, radius 16. Ink ripple when [onTap] is set. Place directly on
/// the page surface, not inside another card.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.depth = DepthLevel.medium,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final DepthLevel depth;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return DecoratedBox(
      decoration: context.depth.raisedDecoration(level: depth),
      child: ClipRRect(
        borderRadius: AppRadius.lgAll,
        child: Material(
          type: MaterialType.transparency,
          child: onTap == null
              ? content
              : InkWell(onTap: onTap, child: content),
        ),
      ),
    );
  }
}
