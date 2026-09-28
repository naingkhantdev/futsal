import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/content_constraint.dart';
import '../../../core/widgets/language_picker.dart';

/// Shared auth screen layout (design_system.md §9), Swiss-aligned: brand mark
/// → large left-aligned headline → subtitle → [children], max width 440.
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
                  // Language is chosen before signing in, so it's here too.
                  const Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: BrandMark(showWordmark: true),
                        ),
                      ),
                      LanguageButton(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Semantics(
                    header: true,
                    child: Text(headline, style: styles.displaySmall),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle,
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
