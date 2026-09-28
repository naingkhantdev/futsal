import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_depth.dart';
import 'app_sizes.dart';

/// Shorthand access to theme tokens and window-size classes.
extension ThemeContextX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;

  /// Card / hairline / well surface tokens.
  AppDepth get depth => Theme.of(this).extension<AppDepth>() ?? AppDepth.light;

  TextTheme get textStyles => Theme.of(this).textTheme;

  double get _width => MediaQuery.sizeOf(this).width;

  /// < 600dp.
  bool get isCompact => _width < AppSizes.mediumBreakpoint;

  /// 600–839dp.
  bool get isMedium =>
      _width >= AppSizes.mediumBreakpoint &&
      _width < AppSizes.expandedBreakpoint;

  /// ≥ 840dp.
  bool get isExpanded => _width >= AppSizes.expandedBreakpoint;

  /// ≥ 1200dp.
  bool get isLarge => _width >= AppSizes.largeBreakpoint;

  /// Slot grid column count; shared by `SlotTile` grids and
  /// `SkeletonSlotGrid`.
  int get slotGridColumns => isExpanded
      ? AppSizes.slotGridColumnsExpanded
      : isMedium
          ? AppSizes.slotGridColumnsMedium
          : AppSizes.slotGridColumnsCompact;
}
