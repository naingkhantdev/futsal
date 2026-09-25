import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/widgets/content_constraint.dart';

/// Shared auth screen layout (design_system.md §9): logo → headline →
/// subtitle → [children], centered at max width 440.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.headline,
    required this.subtitle,
    required this.children,
  });

  final String headline;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    final gutter = context.isCompact ? AppSpacing.xl : AppSpacing.xxl;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: AppSpacing.xxxl,
            bottom: AppSpacing.xl,
          ),
          child: ContentConstraint(
            width: ContentWidth.auth,
            applyGutter: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.sports_soccer,
                    size: AppSizes.logoMark,
                    color: colors.primary,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    headline,
                    style: styles.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: styles.bodyLarge
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
