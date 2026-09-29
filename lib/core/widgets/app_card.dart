import 'package:flutter/material.dart';

import '../theme/app_depth.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import 'motion.dart';

/// Base card: white surface + hairline border on the ivory page, radius 16,
/// flat by default. Shadows are for things that float (bars, sheets,
/// dialogs); pass [depth] `medium` only for a card that must lift off the
/// page. When [onTap] is set: ink ripple + a slight press scale
/// ([Pressable]). Place directly on the page, not inside another card.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.depth = DepthLevel.low,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final DepthLevel depth;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    final card = DecoratedBox(
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
    return Pressable(enabled: onTap != null, child: card);
  }
}
