import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Modal bottom sheet (design_system.md §5.5): title → scrollable content →
/// pinned actions. Colors, radius, drag handle and max width come from
/// `bottomSheetTheme`.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required String title,
  required Widget content,
  Widget? actions,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _AppBottomSheet(
      title: title,
      content: content,
      actions: actions,
    ),
  );
}

class _AppBottomSheet extends StatelessWidget {
  const _AppBottomSheet({
    required this.title,
    required this.content,
    this.actions,
  });

  final String title;
  final Widget content;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: context.textStyles.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          Flexible(child: SingleChildScrollView(child: content)),
          if (actions != null) ...[
            const SizedBox(height: AppSpacing.xl),
            actions!,
          ],
        ],
      ),
    );
  }
}
