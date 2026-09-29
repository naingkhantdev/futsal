import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context_ext.dart';
import 'app_loader.dart';

/// Button heights: 48 (default) / 56 (sticky booking CTAs).
enum AppButtonSize { medium, large }

enum _Variant { primary, secondary, text, destructive }

/// Filled primary button. Only one per screen region (design_system.md §5.1).
class PrimaryButton extends _AppButton {
  const PrimaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
    super.isLoading,
    super.size,
    super.expand,
  }) : super(variant: _Variant.primary);
}

/// Outlined secondary button.
class SecondaryButton extends _AppButton {
  const SecondaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
    super.isLoading,
    super.size,
    super.expand,
  }) : super(variant: _Variant.secondary);
}

/// Tertiary text button (intrinsic width by default).
class AppTextButton extends _AppButton {
  const AppTextButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
    super.isLoading,
  }) : super(variant: _Variant.text);
}

/// Filled button in `error` / `onError` for destructive confirms.
class DestructiveButton extends _AppButton {
  const DestructiveButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
    super.isLoading,
    super.size,
    super.expand,
  }) : super(variant: _Variant.destructive);
}

abstract class _AppButton extends StatelessWidget {
  const _AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.variant,
    this.icon,
    this.isLoading = false,
    this.size = AppButtonSize.medium,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Shows a spinner in place of the label, keeps enabled colors and width,
  /// and ignores taps.
  final bool isLoading;
  final AppButtonSize size;

  /// Full width (forms, sheets, sticky bars).
  final bool expand;
  final _Variant variant;

  @override
  Widget build(BuildContext context) {
    final style = _style(context);
    final child = _ButtonContent(label: label, icon: icon, isLoading: isLoading);

    // Enabled primary: navy (dark: gold) sheen + soft glow. Disabled stays flat so
    // it reads as disabled.
    final gradient = variant == _Variant.primary && onPressed != null;

    Widget button = switch (variant) {
      _Variant.primary ||
      _Variant.destructive =>
        FilledButton(onPressed: onPressed, style: style, child: child),
      _Variant.secondary =>
        OutlinedButton(onPressed: onPressed, style: style, child: child),
      _Variant.text =>
        TextButton(onPressed: onPressed, style: style, child: child),
    };

    if (gradient) {
      final g = context.gradients;
      button = DecoratedBox(
        decoration: BoxDecoration(
          gradient: g.primary,
          borderRadius: AppRadius.mdAll,
          boxShadow: [
            BoxShadow(
              color: g.primaryGlow,
              offset: const Offset(0, 6),
              blurRadius: 16,
            ),
          ],
        ),
        child: button,
      );
    }
    if (expand) button = SizedBox(width: double.infinity, child: button);
    if (!isLoading) return button;

    return Semantics(
      button: true,
      label: '$label, loading',
      excludeSemantics: true,
      child: IgnorePointer(child: button),
    );
  }

  ButtonStyle? _style(BuildContext context) {
    final colors = context.colors;
    final isLarge = size == AppButtonSize.large && variant != _Variant.text;
    ButtonStyle? style = switch (variant) {
      _Variant.destructive => FilledButton.styleFrom(
          backgroundColor: colors.error,
          foregroundColor: colors.onError,
        ),
      // Plain outline (theme side color) on a transparent fill.
      _Variant.secondary => OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
        ),
      // Transparent so the gradient behind it shows; disabled keeps the
      // theme's flat disabled fill.
      _Variant.primary when onPressed != null => FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      _ => null,
    };
    if (isLarge) {
      final large = ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(
          Size(AppSizes.minTouchTarget, AppSizes.buttonHeightLarge),
        ),
        textStyle: WidgetStatePropertyAll(
          context.textStyles.labelLarge
              ?.copyWith(fontSize: AppTypography.largeButtonLabelSize),
        ),
      );
      style = style?.merge(large) ?? large;
    }
    return style;
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.isLoading,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: AppSizes.iconMd),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
    if (!isLoading) return content;

    // Keep the idle content laid out (invisible) so the width stays locked.
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: content,
        ),
        // The button sets IconTheme color to its foreground color.
        AppLoader.small(color: IconTheme.of(context).color),
      ],
    );
  }
}
