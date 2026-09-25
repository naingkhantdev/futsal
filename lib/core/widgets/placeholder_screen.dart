import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'content_constraint.dart';
import 'empty_view.dart';

/// Phase 1 stand-in for screens that are not built yet, so the route map is
/// navigable end to end. Replace per feature phase.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.icon = Icons.construction_outlined,
    this.message,
    this.footer,
  });

  final String title;
  final IconData icon;

  /// Optional detail, e.g. the route parameters received.
  final String? message;

  /// Optional widget pinned under the empty state (e.g. a "Log out" button
  /// on settings screens that are otherwise not built yet).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: EmptyView(
              icon: icon,
              title: 'Coming soon',
              message: message ?? 'This screen is being built.',
            ),
          ),
          if (footer != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                child: ContentConstraint(
                  width: ContentWidth.form,
                  child: footer!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
