import 'package:flutter/material.dart';

import 'app_color_schemes.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Light and dark [ThemeData] built from the design tokens
/// (design_system.md §2–5). Flutter 3.22 API: `CardTheme`, `DialogTheme`,
/// `TabBarTheme` (not `*ThemeData`).
abstract final class AppTheme {
  static ThemeData light() => _build(AppColorSchemes.light, AppColors.light);

  static ThemeData dark() => _build(AppColorSchemes.dark, AppColors.dark);

  /// Raised surface for cards, inputs and available slots:
  /// `surfaceContainerLowest` (light) / `surfaceContainerLow` (dark).
  static Color raisedSurface(ColorScheme scheme) =>
      scheme.brightness == Brightness.light
          ? scheme.surfaceContainerLowest
          : scheme.surfaceContainerLow;

  static ThemeData _build(ColorScheme scheme, AppColors appColors) {
    const text = AppTypography.textTheme;
    final raised = raisedSurface(scheme);
    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
    const buttonMinSize = Size(AppSizes.minTouchTarget, AppSizes.buttonHeight);
    const iconSize = WidgetStatePropertyAll<double?>(AppSizes.iconMd);

    OutlineInputBorder inputBorder(Color color, double width) =>
        OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: <ThemeExtension<dynamic>>[appColors],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        // Tonal step when content scrolls under (replaces a divider).
        // AppBar resolves this with WidgetState.scrolledUnder.
        backgroundColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.scrolledUnder)
              ? scheme.surfaceContainer
              : scheme.surface,
        ),
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppSizes.appBarHeight,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: buttonShape,
          textStyle: text.labelLarge,
        ).copyWith(iconSize: iconSize),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: buttonShape,
          textStyle: text.labelLarge,
          foregroundColor: scheme.primary,
        ).copyWith(
          iconSize: iconSize,
          side: WidgetStateProperty.resolveWith((states) => BorderSide(
                color: states.contains(WidgetState.disabled)
                    ? scheme.onSurface.withOpacity(0.12)
                    : scheme.outline,
              )),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          shape: buttonShape,
          textStyle: text.labelLarge,
          foregroundColor: scheme.primary,
        ).copyWith(iconSize: iconSize),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: raised,
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
        errorMaxLines: 2,
        helperMaxLines: 1,
        helperStyle: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        errorStyle: text.bodySmall?.copyWith(color: scheme.error),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        border: inputBorder(scheme.outline, AppSizes.borderThin),
        enabledBorder: inputBorder(scheme.outline, AppSizes.borderThin),
        focusedBorder: inputBorder(scheme.primary, AppSizes.borderThick),
        errorBorder: inputBorder(scheme.error, AppSizes.borderThin),
        focusedErrorBorder: inputBorder(scheme.error, AppSizes.borderThick),
        disabledBorder: inputBorder(
          scheme.onSurface.withOpacity(0.12),
          AppSizes.borderThin,
        ),
      ),
      cardTheme: CardTheme(
        color: raised,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: scheme.secondaryContainer,
        checkmarkColor: scheme.onSecondaryContainer,
        showCheckmark: true,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? BorderSide.none
              : BorderSide(color: scheme.outline),
        ),
        labelStyle: text.labelLarge?.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppSizes.navBarHeight,
        backgroundColor: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: const StadiumBorder(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: AppSizes.iconLg,
            color: states.contains(WidgetState.selected)
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainer,
        elevation: 0,
        useIndicator: true,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: const StadiumBorder(),
        labelType: NavigationRailLabelType.all,
        selectedIconTheme: IconThemeData(
          size: AppSizes.iconLg,
          color: scheme.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(
          size: AppSizes.iconLg,
          color: scheme.onSurfaceVariant,
        ),
        selectedLabelTextStyle:
            text.labelMedium?.copyWith(color: scheme.onSurface),
        unselectedLabelTextStyle:
            text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        modalBackgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlTop),
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidthSheet),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
        titleTextStyle: text.headlineSmall?.copyWith(color: scheme.onSurface),
        contentTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
      ),
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          elevation: WidgetStatePropertyAll<double?>(3),
          surfaceTintColor: WidgetStatePropertyAll<Color?>(Colors.transparent),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        elevation: 3,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: AppSizes.borderThin,
        space: AppSizes.borderThin,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: text.bodyLarge?.copyWith(color: scheme.onSurface),
        subtitleTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll<TextStyle?>(text.labelLarge),
          shape: const WidgetStatePropertyAll<OutlinedBorder?>(
            RoundedRectangleBorder(borderRadius: AppRadius.fullAll),
          ),
          side: WidgetStatePropertyAll<BorderSide?>(
            BorderSide(color: scheme.outline),
          ),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        labelStyle: text.titleSmall,
        unselectedLabelStyle: text.titleSmall,
        indicatorColor: scheme.primary,
        dividerColor: scheme.outlineVariant,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: AppSizes.refreshBarHeight,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: scheme.error,
        textColor: scheme.onError,
        textStyle: text.labelSmall,
      ),
    );
  }
}
