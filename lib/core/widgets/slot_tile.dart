import 'package:flutter/material.dart';

import '../constants/domain_enums.dart';
import '../l10n/l10n.dart';
import '../theme/app_depth.dart';
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
    final depth = context.depth;
    final l = context.l10n;
    final well = depth.wellDecoration();
    // Available = white tile + hairline, selected = solid navy, booked = gray
    // fill, blocked = darker gray, unavailable = outline only. Icon + label
    // always.
    final (BoxDecoration deco, Color fg, IconData icon, String label) =
        switch (state) {
      SlotState.available => (
          depth.raisedDecoration(
            level: DepthLevel.low,
            borderRadius: AppRadius.mdAll,
            color: AppTheme.raisedSurface(c),
          ),
          c.onSurface,
          Icons.add_circle_outline,
          l.slotAvailable,
        ),
      SlotState.selected => (
          BoxDecoration(
            color: c.primary,
            borderRadius: AppRadius.mdAll,
            boxShadow: depth.ink(DepthLevel.low),
          ),
          c.onPrimary,
          Icons.check_circle,
          l.slotSelected,
        ),
      SlotState.booked => (
          well,
          c.onSurfaceVariant,
          Icons.event_busy,
          l.slotBooked,
        ),
      SlotState.blocked => (
          BoxDecoration(
            color: c.surfaceContainerHighest,
            borderRadius: AppRadius.mdAll,
          ),
          c.onSurfaceVariant,
          Icons.block,
          isAdmin ? l.slotBlocked : l.slotClosed,
        ),
      SlotState.unavailable => (
          BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: c.outlineVariant),
          ),
          c.onSurfaceVariant,
          Icons.do_not_disturb_on_outlined,
          l.slotUnavailable,
        ),
    };
    final labelColor = state == SlotState.available ? c.onSurfaceVariant : fg;
    final animate = !MediaQuery.disableAnimationsOf(context);
    final scaler = MediaQuery.textScalerOf(context)
        .clamp(maxScaleFactor: AppSizes.compactTextScaleCap);
    const shape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);

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
          decoration: deco,
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
