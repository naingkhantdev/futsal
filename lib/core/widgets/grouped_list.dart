import 'package:flutter/material.dart';

import '../theme/app_depth.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Rows of a list on one surface (fill + hairline, no shadow), separated
/// by inset hairlines: the grouped-list pattern of iOS Settings / Wallet.
/// Use for bookings, customers and other repeated rows instead of one
/// card per row. Rows provide their own padding and ink.
class GroupedList extends StatelessWidget {
  const GroupedList({
    super.key,
    required this.children,
    this.dividerIndent = AppSpacing.lg,
  });

  final List<Widget> children;

  /// Left inset of the separators (align with the rows' text).
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: context.depth.raisedDecoration(level: DepthLevel.low),
      child: ClipRRect(
        borderRadius: AppRadius.lgAll,
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, child) in children.indexed) ...[
                if (i > 0) Divider(height: 1, indent: dividerIndent),
                child,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
