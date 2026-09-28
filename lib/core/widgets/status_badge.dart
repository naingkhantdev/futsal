import 'package:flutter/material.dart';

import '../constants/domain_enums.dart';
import '../l10n/l10n.dart';
import '../l10n/l10n_labels.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/status_tone.dart';
import '../theme/status_visuals.dart';
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
    this.source,
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
          source: visual.source,
        );

  final StatusTone tone;
  final IconData icon;
  final String label;

  /// Spoken kind, e.g. "Booking status" → "Booking status: Confirmed".
  final String semanticsPrefix;
  final StatusBadgeSize size;

  /// Status the badge shows ([StatusVisual.source]); when set, the label is
  /// translated for the current locale instead of using [label].
  final Object? source;

  String _text(BuildContext context) {
    final l = context.l10n;
    return switch (source) {
      final BookingStatus s => s.labelIn(l),
      final PaymentStatus s => s.labelIn(l),
      final ShopStatus s => s.labelIn(l),
      ListingState.listed => l.shopListed,
      ListingState.unlisted => l.shopUnlisted,
      _ => label,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = tone.colorsFor(context);
    final isSmall = size == StatusBadgeSize.small;
    final baseStyle =
        isSmall ? context.textStyles.labelSmall : context.textStyles.labelMedium;
    final scaler = MediaQuery.textScalerOf(context)
        .clamp(maxScaleFactor: AppSizes.compactTextScaleCap);

    return Semantics(
      label: '$semanticsPrefix: ${_text(context)}',
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
                  _text(context),
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
