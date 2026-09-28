import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';

/// KPI cards in 2 columns on phones, 4 from the expanded width up.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final columns = context.isExpanded ? 4 : 2;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth -
                AppSpacing.md * (columns - 1)) /
            columns;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}
