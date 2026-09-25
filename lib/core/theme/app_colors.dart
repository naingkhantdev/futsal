import 'package:flutter/material.dart';

/// Semantic colors not covered by [ColorScheme] (design_system.md §2.3).
///
/// Badges and banners always use container + onContainer. The solid
/// success / warning / info colors are for icons on neutral surfaces only.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.skeleton,
    required this.imagePlaceholder,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color skeleton;
  final Color imagePlaceholder;

  static const AppColors light = AppColors(
    success: Color(0xFF1E7A3C),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFD3F5DC),
    onSuccessContainer: Color(0xFF0B3D1C),
    warning: Color(0xFF8A5A00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFE7B8),
    onWarningContainer: Color(0xFF3D2800),
    info: Color(0xFF0B6E99),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFD2EEFB),
    onInfoContainer: Color(0xFF003549),
    skeleton: Color(0xFFE6E9F0),
    imagePlaceholder: Color(0xFFECEFF4),
  );

  static const AppColors dark = AppColors(
    success: Color(0xFF7BD897),
    onSuccess: Color(0xFF00391A),
    successContainer: Color(0xFF135C2C),
    onSuccessContainer: Color(0xFFC8F2D3),
    warning: Color(0xFFF5BE5A),
    onWarning: Color(0xFF452B00),
    warningContainer: Color(0xFF654100),
    onWarningContainer: Color(0xFFFFE7B8),
    info: Color(0xFF7FCFF2),
    onInfo: Color(0xFF003549),
    infoContainer: Color(0xFF004D6B),
    onInfoContainer: Color(0xFFD2EEFB),
    skeleton: Color(0xFF252A33),
    imagePlaceholder: Color(0xFF1B1F27),
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? skeleton,
    Color? imagePlaceholder,
  }) {
    return AppColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      skeleton: skeleton ?? this.skeleton,
      imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      success: l(success, other.success),
      onSuccess: l(onSuccess, other.onSuccess),
      successContainer: l(successContainer, other.successContainer),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      warning: l(warning, other.warning),
      onWarning: l(onWarning, other.onWarning),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      info: l(info, other.info),
      onInfo: l(onInfo, other.onInfo),
      infoContainer: l(infoContainer, other.infoContainer),
      onInfoContainer: l(onInfoContainer, other.onInfoContainer),
      skeleton: l(skeleton, other.skeleton),
      imagePlaceholder: l(imagePlaceholder, other.imagePlaceholder),
    );
  }
}
