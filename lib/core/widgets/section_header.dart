import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Section title with an optional "See all" action, inside the screen
/// gutter.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  /// Defaults to "See all" in the app language.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SectionTitleRow(
        title: title,
        action: onAction == null
            ? null
            : TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(actionLabel ?? context.l10n.commonSeeAll),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Icons.arrow_forward, size: AppSizes.iconSm),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Plain section title (heading semantics) + optional trailing action.
/// Hierarchy comes from size and space above it, not a decorative bar.
class SectionTitleRow extends StatelessWidget {
  const SectionTitleRow({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: context.textStyles.titleLarge),
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
