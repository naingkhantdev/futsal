import 'package:flutter/material.dart';

import '../constants/domain_enums.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context_ext.dart';

/// Time-slot tile (design_system.md §6.5). Visual only: the caller decides
/// state, labels and tap handling. State is conveyed by background, border,
/// icon and text — never color alone.
class SlotTile extends StatelessWidget {
  const SlotTile({
    super.key,
    required this.state,
    required this.startLabel,
    required this.semanticLabel,
    this.onTap,
    this.isAdmin = false,
  });

  final SlotState state;

  /// Locale-formatted start time, e.g. "18:00" or "6:00 PM".
  final String startLabel;

  /// Full spoken description, e.g. "6:00 PM to 7:00 PM, available, ...".
  final String semanticLabel;
  final VoidCallback? onTap;

  /// Admins can tap booked/blocked tiles to open details.
  final bool isAdmin;

  bool get _tappable => switch (state) {
        SlotState.available || SlotState.selected => true,
        SlotState.booked || SlotState.blocked => isAdmin,
        SlotState.unavailable => false,
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (Color bg, Color fg, BorderSide border, IconData icon, String label) =
        switch (state) {
      SlotState.available => (
          AppTheme.raisedSurface(c),
          c.onSurface,
          BorderSide(color: c.outline),
          Icons.add_circle_outline,
          'Available',
        ),
      SlotState.selected => (
          c.primary,
          c.onPrimary,
          BorderSide(color: c.primary, width: AppSizes.borderThick),
          Icons.check_circle,
          'Selected',
        ),
      SlotState.booked => (
          c.surfaceContainerHighest,
          c.onSurfaceVariant,
          BorderSide.none,
          Icons.event_busy,
          'Booked',
        ),
      SlotState.blocked => (
          c.surfaceContainerHigh,
          c.onSurfaceVariant,
          BorderSide.none,
          Icons.block,
          isAdmin ? 'Blocked' : 'Closed',
        ),
      SlotState.unavailable => (
          Colors.transparent,
          c.onSurfaceVariant,
          BorderSide(color: c.outlineVariant),
          Icons.do_not_disturb_on_outlined,
          'Unavailable',
        ),
    };
    final labelColor = state == SlotState.available ? c.onSurfaceVariant : fg;
    final animate = !MediaQuery.disableAnimationsOf(context);
    final scaler = MediaQuery.textScalerOf(context)
        .clamp(maxScaleFactor: AppSizes.compactTextScaleCap);
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadius.mdAll,
      side: border,
    );

    return Semantics(
      button: _tappable,
      selected: state == SlotState.selected,
      enabled: _tappable,
      label: semanticLabel,
      // excludeSemantics drops the InkWell's action; re-expose it here.
      onTap: _tappable ? onTap : null,
      onTapHint: state == SlotState.selected ? 'deselect' : 'select',
      excludeSemantics: true,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: scaler),
        child: AnimatedContainer(
          duration: animate ? AppMotion.state : Duration.zero,
          curve: AppMotion.curve,
          constraints:
              const BoxConstraints(minHeight: AppSizes.slotTileMinHeight),
          decoration: ShapeDecoration(color: bg, shape: shape),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: shape,
              onTap: _tappable ? onTap : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.md - AppSpacing.xxs,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      startLabel,
                      maxLines: 1,
                      style: AppTypography.tabular(
                        context.textStyles.titleSmall!.copyWith(color: fg),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: AppSizes.iconXs, color: labelColor),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyles.labelSmall?.copyWith(
                              color: labelColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
