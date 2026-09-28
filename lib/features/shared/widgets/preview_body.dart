import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/content_constraint.dart';
import '../../../core/widgets/demo_data_banner.dart';

/// Scrollable body for screens that still show `DemoData`: the sample-data
/// banner on top, then [children] in a centered column at [width].
class PreviewBody extends StatelessWidget {
  const PreviewBody({
    super.key,
    required this.children,
    this.width = ContentWidth.list,
    this.bottomPadding = AppSpacing.xxxl,
  });

  final List<Widget> children;
  final ContentWidth width;

  /// Extra space under the content (room for a FAB).
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: AppSpacing.md, bottom: bottomPadding),
      children: [
        ContentConstraint(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DemoDataBanner(),
              const SizedBox(height: AppSpacing.lg),
              ...children,
            ],
          ),
        ),
      ],
    );
  }
}

/// Feedback for an action on a preview screen: nothing is written.
void showPreviewOnly(BuildContext context, String action) =>
    showAppSnackBar(context, context.l10n.previewOnly(action));

/// Section title inside a [PreviewBody] (no horizontal padding of its own).
class PreviewSectionTitle extends StatelessWidget {
  const PreviewSectionTitle(this.title, {super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xl,
        bottom: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
