import 'package:flutter/material.dart';

import '../theme/app_sizes.dart';

/// Short blocking decision (design_system.md §5.6). Use verb labels only —
/// never "OK / Yes / No". Resolves to `true` when confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String dismissLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;
      // Center loosens the route's tight constraints so maxWidth applies.
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxWidthDialog),
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(dismissLabel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: destructive
                    ? FilledButton.styleFrom(
                        backgroundColor: colors.error,
                        foregroundColor: colors.onError,
                      )
                    : null,
                child: Text(confirmLabel),
              ),
            ],
          ),
        ),
      );
    },
  );
  return result ?? false;
}
