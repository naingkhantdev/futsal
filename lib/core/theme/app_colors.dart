import 'package:flutter/material.dart';

/// Semantic colors not covered by [ColorScheme] (design_system.md §2.3).
///
/// Badges and banners always use container + onContainer. The solid
/// success / warning / info colors are for icons on neutral surfaces only.
///
/// Muted, premium tones in the navy + gold family (user's call, 2026-09-29):
/// `success` is bronze-gold (no green anywhere), `warning` burnt orange,
/// `info` slate blue. Status is never color alone (icon + label).
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
    success: Color(0xFF7A5A12),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFF4EBD3),
    onSuccessContainer: Color(0xFF3A2A06),
    warning: Color(0xFF9A4A12),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFF7E5D6),
    onWarningContainer: Color(0xFF45200A),
    info: Color(0xFF34507A),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFE3E8F1),
    onInfoContainer: Color(0xFF142640),
    skeleton: Color(0xFFE7E4DC),
    imagePlaceholder: Color(0xFFECE9E2),
  );

  static const AppColors dark = AppColors(
    success: Color(0xFFE3C77E),
    onSuccess: Color(0xFF2A1E05),
    successContainer: Color(0xFF3A2E12),
    onSuccessContainer: Color(0xFFF4EBD3),
    warning: Color(0xFFF0A870),
    onWarning: Color(0xFF3F1F08),
    warningContainer: Color(0xFF3F2410),
    onWarningContainer: Color(0xFFF7E5D6),
    info: Color(0xFF9FB6DA),
    onInfo: Color(0xFF142640),
    infoContainer: Color(0xFF1C2B45),
    onInfoContainer: Color(0xFFE3E8F1),
    skeleton: Color(0xFF1B2438),
    imagePlaceholder: Color(0xFF172033),
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
