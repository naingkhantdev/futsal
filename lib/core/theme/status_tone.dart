import 'package:flutter/material.dart';

import 'theme_context_ext.dart';

/// Semantic tone for badges and banners (design_system.md §6.1).
enum StatusTone { neutral, brand, success, warning, info, danger }

/// Background (container) and foreground (onContainer) pair for a tone.
typedef ToneColors = ({Color background, Color foreground});

extension StatusToneColors on StatusTone {
  ToneColors colorsFor(BuildContext context) {
    final c = context.colors;
    final a = context.appColors;
    return switch (this) {
      StatusTone.neutral => (
          background: c.surfaceContainerHighest,
          foreground: c.onSurfaceVariant,
        ),
      StatusTone.brand => (
          background: c.primaryContainer,
          foreground: c.onPrimaryContainer,
        ),
      StatusTone.success => (
          background: a.successContainer,
          foreground: a.onSuccessContainer,
        ),
      StatusTone.warning => (
          background: a.warningContainer,
          foreground: a.onWarningContainer,
        ),
      StatusTone.info => (
          background: a.infoContainer,
          foreground: a.onInfoContainer,
        ),
      StatusTone.danger => (
          background: c.errorContainer,
          foreground: c.onErrorContainer,
        ),
    };
  }
}

/// Everything a [StatusBadge] needs to render a status: never color alone.
@immutable
class StatusVisual {
  const StatusVisual(this.tone, this.icon, this.label, [this.source]);

  final StatusTone tone;
  final IconData icon;

  /// English label (fallback).
  final String label;

  /// The value this visual describes (a status enum or `ListingState`), so
  /// `StatusBadge` can show the translated label.
  final Object? source;
}
