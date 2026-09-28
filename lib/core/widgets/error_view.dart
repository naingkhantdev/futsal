import 'package:flutter/material.dart';

import '../errors/app_exception.dart';
import '../l10n/l10n.dart';
import '../l10n/l10n_labels.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'empty_view.dart';

/// Error state (design_system.md §7.3). Shows only [AppException.message] —
/// never raw Firebase text.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.title,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  }) : _inline = false;

  /// Card-style variant for a section inside a screen.
  const ErrorView.inline({super.key, required this.error, this.onRetry})
      : title = null,
        secondaryActionLabel = null,
        onSecondaryAction = null,
        _inline = true;

  final AppException error;
  final VoidCallback? onRetry;

  /// Overrides the type-derived title (full-screen variant only), e.g.
  /// splash "We couldn't load your account".
  final String? title;

  /// Optional text action under "Try again" (e.g. "Sign out").
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final bool _inline;

  (IconData, String) _iconAndTitle(AppLocalizations l) => switch (error) {
        NetworkException() => (Icons.cloud_off, l.errorOfflineTitle),
        PermissionDeniedException() ||
        AuthenticationException() =>
          (Icons.lock_outline, l.errorNoAccessTitle),
        NotFoundException() => (Icons.search_off, l.errorNotFoundTitle),
        _ => (Icons.error_outline, l.errorGenericTitle),
      };

  @override
  Widget build(BuildContext context) =>
      _inline ? _buildInline(context) : _buildFull(context);

  Widget _buildFull(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    final l = context.l10n;
    final (icon, typeTitle) = _iconAndTitle(l);
    final heading = title ?? typeTitle;
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
                background: colors.errorContainer,
                foreground: colors.onErrorContainer,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                heading,
                style: styles.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error.messageIn(l),
                textAlign: TextAlign.center,
                style:
                    styles.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.xl),
                SecondaryButton(
                  label: l.commonTryAgain,
                  icon: Icons.refresh,
                  onPressed: onRetry,
                ),
              ],
              if (secondaryActionLabel != null) ...[
                SizedBox(
                  height: onRetry != null ? AppSpacing.sm : AppSpacing.xl,
                ),
                TextButton(
                  onPressed: onSecondaryAction,
                  child: Text(secondaryActionLabel!),
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
    return AppCard(
      child: Row(
        children: [
          Icon(Icons.error_outline, size: AppSizes.iconMd, color: colors.error),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              error.messageIn(context.l10n),
              style: context.textStyles.bodyMedium,
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.commonRetry),
            ),
        ],
      ),
    );
  }
}
