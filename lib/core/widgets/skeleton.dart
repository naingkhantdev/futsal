import 'package:flutter/material.dart';

import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import 'app_card.dart';

/// Gentle opacity pulse (1.0 ↔ 0.55, 1s). Static when animations are off.
class SkeletonPulse extends StatefulWidget {
  const SkeletonPulse({super.key, required this.child, this.semanticLabel});

  final Widget child;

  /// e.g. "Loading stadiums". Set on the outermost skeleton only.
  final String? semanticLabel;

  @override
  State<SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<SkeletonPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.skeletonPulse,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = FadeTransition(
      opacity: Tween<double>(begin: 1, end: AppMotion.skeletonMinOpacity)
          .animate(_controller),
      child: ExcludeSemantics(child: widget.child),
    );
    final label = widget.semanticLabel;
    return label == null ? child : Semantics(label: label, child: child);
  }
}

/// A single placeholder block in the `skeleton` color.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = AppSpacing.lg,
    this.borderRadius = AppRadius.xsAll,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.appColors.skeleton,
        borderRadius: borderRadius,
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          SkeletonBox(
            width: AppSizes.listLeading,
            height: AppSizes.listLeading,
            borderRadius: AppRadius.fullAll,
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(widthFactor: 0.6, child: SkeletonBox()),
                SizedBox(height: AppSpacing.sm),
                FractionallySizedBox(
                  widthFactor: 0.4,
                  child: SkeletonBox(height: AppSpacing.md),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonStadiumCard extends StatelessWidget {
  const SkeletonStadiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Same shape as the image-led StadiumCard: one photo-sized block.
    return const AspectRatio(
      aspectRatio: 3 / 2,
      child: SkeletonBox(borderRadius: AppRadius.lgAll),
    );
  }
}

class SkeletonStatCard extends StatelessWidget {
  const SkeletonStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Same layout as StatCard: label line, then the large value.
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            width: AppSizes.skeletonLabelWidth,
            height: AppSpacing.md,
          ),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(
            width: AppSizes.skeletonValueWidth,
            height: AppSpacing.xxl,
          ),
        ],
      ),
    );
  }
}

/// Placeholder grid with the same metrics as the real slot grid.
class SkeletonSlotGrid extends StatelessWidget {
  const SkeletonSlotGrid({super.key, this.itemCount = 12});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final columns = context.slotGridColumns;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisExtent: AppSizes.slotTileMinHeight,
      ),
      itemBuilder: (_, __) => const SkeletonBox(
        height: AppSizes.slotTileMinHeight,
        borderRadius: AppRadius.mdAll,
      ),
    );
  }
}
