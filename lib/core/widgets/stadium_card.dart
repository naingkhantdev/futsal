import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context_ext.dart';
import 'motion.dart';
import 'stadium_photo.dart';

/// Customer stadium card (design_system.md §0): the venue photo is the
/// card. Name, place, facilities and price sit on a navy [AppGradients.scrim]
/// at the bottom of the image; the price is the one gold line. No white
/// frame, no chips. Visual shell only: takes pre-formatted strings.
class StadiumCard extends StatelessWidget {
  const StadiumCard({
    super.key,
    required this.name,
    required this.location,
    required this.priceLabel,
    required this.semanticLabel,
    required this.onTap,
    this.imageUrl,
    this.facilities = const [],
    this.overlayBadge,
    this.aspectRatio = 3 / 2,
  });

  final String name;

  /// "Township, City".
  final String location;

  /// e.g. "From MMK 30,000/hr".
  final String priceLabel;

  /// "{name}, {township}, from {price} per hour".
  final String semanticLabel;
  final VoidCallback onTap;
  final String? imageUrl;
  final List<String> facilities;

  /// Optional StatusBadge shown top-left on the image.
  final Widget? overlayBadge;

  /// 3:2 in vertical lists, 4:3 in horizontal carousels.
  final double aspectRatio;

  static const int _maxFacilities = 2;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final g = context.gradients;
    final shown = facilities.take(_maxFacilities).toList();
    final extra = facilities.length - shown.length;
    final facilityLine = [
      ...shown,
      if (extra > 0) '+$extra',
    ].join(' · ');

    return Semantics(
      button: true,
      label: semanticLabel,
      // excludeSemantics drops the InkWell's action; re-expose it here.
      onTap: onTap,
      excludeSemantics: true,
      child: Pressable(
        child: ClipRRect(
          borderRadius: AppRadius.lgAll,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                StadiumPhoto(url: imageUrl),
                DecoratedBox(decoration: BoxDecoration(gradient: g.scrim)),
                if (overlayBadge != null)
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: overlayBadge!,
                  ),
                Positioned(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styles.titleLarge?.copyWith(color: g.onHero),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        facilityLine.isEmpty
                            ? location
                            : '$location  ·  $facilityLine',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            styles.bodySmall?.copyWith(color: g.onHeroMuted),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        priceLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.tabular(styles.labelLarge!)
                            .copyWith(color: g.gold, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(onTap: onTap),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
