import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/content_constraint.dart';
import '../../../core/widgets/motion.dart';
import '../../../core/widgets/section_header.dart';

/// Scrollable page body: an optional full-bleed [header] (e.g. a venue
/// photo), then [children] in a centered column at [width].
///
/// Motion: the content column enters once as a whole (fade + short rise);
/// the header shows at once. Sections are not staggered one by one.
class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.children,
    this.width = ContentWidth.list,
    this.bottomPadding = AppSpacing.xxxl,
    this.header,
  });

  final List<Widget> children;
  final ContentWidth width;

  /// Extra space under the content (room for a FAB).
  final double bottomPadding;

  /// Edge-to-edge widget above the content (no gutter, no top padding).
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return EntranceScope(
      child: ListView(
        padding: EdgeInsets.only(
          top: header == null ? AppSpacing.md : 0,
          bottom: bottomPadding,
        ),
        children: [
          if (header != null) ...[
            header!,
            const SizedBox(height: AppSpacing.lg),
          ],
          FadeSlideIn(
            child: ContentConstraint(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title inside a [PageBody] (no horizontal padding of its own).
class PageSectionTitle extends StatelessWidget {
  const PageSectionTitle(this.title, {super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xxl,
        bottom: AppSpacing.md,
      ),
      child: SectionTitleRow(title: title, action: action),
    );
  }
}
