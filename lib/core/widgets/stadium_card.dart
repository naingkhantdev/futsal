import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context_ext.dart';
import 'app_card.dart';

/// Customer stadium list card (design_system.md §5.3). Visual shell only —
/// takes pre-formatted strings; data wiring arrives in Phase 6.
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
    this.aspectRatio = 16 / 9,
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

  /// 16:9 in vertical lists, 4:3 in horizontal carousels.
  final double aspectRatio;

  static const int _maxFacilityChips = 2;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    final shown = facilities.take(_maxFacilityChips).toList();
    final extra = facilities.length - shown.length;

    return Semantics(
      button: true,
      label: semanticLabel,
      // excludeSemantics drops the InkWell's action; re-expose it here.
      onTap: onTap,
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _StadiumImage(url: imageUrl),
                  if (overlayBadge != null)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: overlayBadge!,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: AppSizes.iconSm, color: colors.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styles.bodyMedium
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          priceLabel,
                          style: AppTypography.tabular(styles.titleSmall!)
                              .copyWith(color: colors.primary),
                        ),
                      ),
                      for (final f in shown) _FacilityChip(label: f),
                      if (extra > 0) _FacilityChip(label: '+$extra'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StadiumImage extends StatelessWidget {
  const _StadiumImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    Widget placeholder(IconData icon) => ColoredBox(
          color: context.appColors.imagePlaceholder,
          child: Center(
            child: Icon(icon,
                size: AppSizes.iconXl, color: context.colors.onSurfaceVariant),
          ),
        );

    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) {
      return placeholder(Icons.sports_soccer_outlined);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => placeholder(Icons.sports_soccer_outlined),
      errorWidget: (_, __, ___) => placeholder(Icons.image_not_supported_outlined),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  const _FacilityChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: AppRadius.smAll,
      ),
      child: Text(
        label,
        style: context.textStyles.labelSmall
            ?.copyWith(color: context.colors.onSurfaceVariant),
      ),
    );
  }
}
