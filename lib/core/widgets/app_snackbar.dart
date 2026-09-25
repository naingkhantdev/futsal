import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

enum SnackTone { neutral, success, error }

/// Non-critical feedback only (design_system.md §5.7). Never for booking
/// success (full-screen confirmation) or booking conflict (bottom sheet).
void showAppSnackBar(
  BuildContext context,
  String message, {
  SnackTone tone = SnackTone.neutral,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final hasAction = actionLabel != null && onAction != null;
  final fg = context.colors.onInverseSurface;
  final icon = switch (tone) {
    SnackTone.success => Icons.check_circle,
    SnackTone.error => Icons.error_outline,
    SnackTone.neutral => null,
  };

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: hasAction
            ? AppConstants.snackBarWithActionDuration
            : AppConstants.snackBarDuration,
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.iconMd, color: fg),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        action: hasAction
            ? SnackBarAction(label: actionLabel, onPressed: onAction)
            : null,
      ),
    );
}
