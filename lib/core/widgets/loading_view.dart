import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import 'app_loader.dart';

/// Centered brand loader with an optional caption. Prefer skeletons for
/// screens with a known layout; use this only where no layout is known yet.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.semanticLabel, this.caption});

  /// Defaults to "Loading" in the app language.
  final String? semanticLabel;

  /// Short line under the loader, e.g. "Loading bookings…".
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoader(
            size: 56,
            showBall: true,
            semanticLabel: semanticLabel ?? context.l10n.commonLoading,
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              caption!,
              style: context.textStyles.bodyMedium
                  ?.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
