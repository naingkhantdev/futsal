import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/status_tone.dart';
import '../theme/theme_context_ext.dart';

enum StatusBadgeSize { small, medium }

/// Pill badge: container color + icon + text, never color alone
/// (design_system.md §6.1). Build from a [StatusVisual], e.g.
/// `StatusBadge.fromVisual(booking.status.visual, semanticsPrefix: 'Booking status')`.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.tone,
    required this.icon,
    required this.label,
    required this.semanticsPrefix,
    this.size = StatusBadgeSize.small,
  });

  StatusBadge.fromVisual(
    StatusVisual visual, {
    Key? key,
    required String semanticsPrefix,
    StatusBadgeSize size = StatusBadgeSize.small,
  }) : this(
          key: key,
          tone: visual.tone,
          icon: visual.icon,
          label: visual.label,
          semanticsPrefix: semanticsPrefix,
          size: size,
        );

  final StatusTone tone;
  final IconData icon;
  final String label;

  /// Spoken kind, e.g. "Booking status" → "Booking status: Confirmed".
  final String semanticsPrefix;
  final StatusBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colorsFor(context);
    final isSmall = size == StatusBadgeSize.small;
    final baseStyle =
        isSmall ? context.textStyles.labelSmall : context.textStyles.labelMedium;
    final scaler = MediaQuery.textScalerOf(context)
        .clamp(maxScaleFactor: AppSizes.compactTextScaleCap);

    return Semantics(
      label: '$semanticsPrefix: $label',
      excludeSemantics: true,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: scaler),
        child: Container(
          constraints: BoxConstraints(
            minHeight:
                isSmall ? AppSizes.badgeHeightSmall : AppSizes.badgeHeightMedium,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? AppSpacing.sm : AppSpacing.md - AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: AppRadius.fullAll,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isSmall ? AppSizes.iconXs : AppSizes.iconSm,
                color: colors.foreground,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: baseStyle?.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
