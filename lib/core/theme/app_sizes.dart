/// Size tokens, breakpoints and max content widths (design_system.md §4.4).
abstract final class AppSizes {
  // Icons
  static const double iconXs = 14;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  static const double iconEmptyState = 48;

  /// Circle behind the empty/error-state icon.
  static const double emptyStateCircle = 96;

  /// Gold "needs attention" dot on a stat card.
  static const double statDot = 8;

  /// Leading circle of a list row (and its skeleton).
  static const double listLeading = 40;

  /// Static venue map on details screens.
  static const double mapPreviewHeight = 180;

  /// Centre pin on the location picker.
  static const double mapPin = 44;

  // Controls
  static const double minTouchTarget = 48;
  static const double buttonHeight = 48;
  static const double buttonHeightLarge = 56;
  static const double buttonSpinner = 20;
  static const double buttonSpinnerStroke = 2.5;
  static const double inputHeight = 56;
  static const double searchFieldHeight = 48;
  static const double appBarHeight = 64;
  static const double navBarHeight = 72;
  static const double badgeHeightSmall = 24;
  static const double badgeHeightMedium = 28;
  static const double slotTileMinHeight = 64;

  // Slot grid columns per window class (design_system.md §6.5). Read via
  // `context.slotGridColumns` so the real grid and its skeleton match.
  static const int slotGridColumnsCompact = 3;
  static const int slotGridColumnsMedium = 4;
  static const int slotGridColumnsExpanded = 6;

  // Skeleton stat-card placeholder widths.
  static const double skeletonValueWidth = 64;
  static const double skeletonLabelWidth = 96;
  static const double chipHeight = 32;
  static const double borderThin = 1;
  static const double borderThick = 2;

  /// Focused input outline.
  static const double borderFocus = 1.5;
  static const double refreshBarHeight = 2;
  static const double loadingSpinner = 24;
  static const double logoMark = 48;

  /// Raised frame around the ink logo tile ([BrandMark]).
  static const double logoFrame = 72;

  /// Initials avatar in the profile identity header.
  static const double avatarLarge = 64;
  static const double railLogo = 32;

  // Breakpoints (logical width)
  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;
  static const double largeBreakpoint = 1200;

  // Max content widths
  static const double maxWidthAuth = 440;
  static const double maxWidthForm = 640;
  static const double maxWidthList = 840;
  static const double maxWidthDashboard = 1200;
  static const double maxWidthDialog = 400;
  static const double maxWidthEmptyState = 320;
  static const double maxWidthSheet = 640;

  /// Max text scale inside slot tiles and badges.
  static const double compactTextScaleCap = 1.3;
}
