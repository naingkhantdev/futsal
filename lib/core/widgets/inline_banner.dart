import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/status_tone.dart';
import '../theme/theme_context_ext.dart';

/// Tone-based inline banner for form errors and conflict notices
/// (design_system.md §7.3 / §7.4). Announced to screen readers on show.
class InlineBanner extends StatefulWidget {
  const InlineBanner({
    super.key,
    required this.message,
    this.tone = StatusTone.danger,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final StatusTone tone;

  /// Defaults to `error_outline` for danger, `info_outline` otherwise.
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  State<InlineBanner> createState() => _InlineBannerState();
}

class _InlineBannerState extends State<InlineBanner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _announce());
  }

  @override
  void didUpdateWidget(InlineBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) _announce();
  }

  void _announce() {
    if (!mounted) return;
    SemanticsService.announce(widget.message, Directionality.of(context));
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.tone.colorsFor(context);
    final icon = widget.icon ??
        (widget.tone == StatusTone.danger
            ? Icons.error_outline
            : Icons.info_outline);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconMd, color: colors.foreground),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              widget.message,
              style: context.textStyles.bodyMedium
                  ?.copyWith(color: colors.foreground),
            ),
          ),
          if (widget.actionLabel != null && widget.onAction != null)
            TextButton(
              onPressed: widget.onAction,
              style: TextButton.styleFrom(foregroundColor: colors.foreground),
              child: Text(widget.actionLabel!),
            ),
        ],
      ),
    );
  }
}
