import 'package:flutter/material.dart';

/// Semantic colors not covered by [ColorScheme] (design_system.md §2.3).
///
/// Badges and banners always use container + onContainer. The solid
/// success / warning / info colors are for icons on neutral surfaces only.
///
/// Muted tones that sit with the sand + terracotta palette (2026-10-02) and
/// stay distinct from the clay `primary`: `success` steel blue (no green
/// anywhere), `warning` amber, `info` warm graphite. Status is never color
/// alone (icon + label).
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
    success: Color(0xFF2E5E7E),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFE1ECF3),
    onSuccessContainer: Color(0xFF0F2A3B),
    warning: Color(0xFF8A5D00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFBEFD2),
    onWarningContainer: Color(0xFF3D2900),
    info: Color(0xFF565C66),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFECEAE6),
    onInfoContainer: Color(0xFF22252A),
    skeleton: Color(0xFFEDE6DB),
    imagePlaceholder: Color(0xFFF1EBE2),
  );

  static const AppColors dark = AppColors(
    success: Color(0xFF8FC1E0),
    onSuccess: Color(0xFF0F2A3B),
    successContainer: Color(0xFF16303F),
    onSuccessContainer: Color(0xFFE1ECF3),
    warning: Color(0xFFE8B65A),
    onWarning: Color(0xFF3D2900),
    warningContainer: Color(0xFF3A2C10),
    onWarningContainer: Color(0xFFFBEFD2),
    info: Color(0xFFB5B9C0),
    onInfo: Color(0xFF22252A),
    infoContainer: Color(0xFF2A2723),
    onInfoContainer: Color(0xFFECEAE6),
    skeleton: Color(0xFF2B241F),
    imagePlaceholder: Color(0xFF241E19),
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
