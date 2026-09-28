import 'package:flutter/material.dart';

import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import 'app_button.dart';

/// Empty state (design_system.md §7.2). Icon only — no illustrations.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  }) : _inline = false;

  /// Horizontal variant for sections inside a scroll view.
  const EmptyView.inline({
    super.key,
    required this.icon,
    required this.title,
    this.message,
  })  : actionLabel = null,
        onAction = null,
        secondaryActionLabel = null,
        onSecondaryAction = null,
        _inline = true;

  final IconData icon;
  final String title;
  final String? message;

  /// Tonal primary action; shown only when both label and callback are set.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Outlined secondary action (e.g. "Sign out"). Shown whenever the label
  /// is set; a null callback renders it disabled.
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final bool _inline;

  @override
  Widget build(BuildContext context) =>
      _inline ? _buildInline(context) : _buildFull(context);

  Widget _buildFull(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xxxl,
        ),
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSizes.maxWidthEmptyState),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconCircle(
                icon: icon,
                background: colors.surfaceContainerHigh,
                foreground: colors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(title, style: styles.titleLarge, textAlign: TextAlign.center),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: styles.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(label: actionLabel!, onPressed: onAction),
              ],
              if (secondaryActionLabel != null) ...[
                SizedBox(
                  height: actionLabel != null && onAction != null
                      ? AppSpacing.md
                      : AppSpacing.xl,
                ),
                SecondaryButton(
                  label: secondaryActionLabel!,
                  onPressed: onSecondaryAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInline(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconXl, color: colors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: styles.titleSmall),
                if (message != null)
                  Text(
                    message!,
                    style: styles.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 96dp circle with a 48dp icon, shared by empty / error / success states.
class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    // Flat tinted circle carrying the tone.
    return Container(
      width: AppSizes.emptyStateCircle,
      height: AppSizes.emptyStateCircle,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: AppSizes.iconXl, color: foreground),
    );
  }
}
