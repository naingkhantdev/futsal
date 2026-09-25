import 'package:flutter/material.dart';

import '../theme/app_sizes.dart';
import '../theme/theme_context_ext.dart';

/// Read-only "label over value" row for detail screens, inside an
/// `AppCard(padding: EdgeInsets.zero)`. A missing value shows [emptyText]
/// in the muted color.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.emptyText = 'Not added',
  });

  final IconData icon;
  final String label;
  final String? value;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final v = value?.trim() ?? '';
    final missing = v.isEmpty;
    return ListTile(
      leading: Icon(icon, size: AppSizes.iconLg, color: colors.onSurfaceVariant),
      title: Text(
        label,
        style: context.textStyles.labelMedium
            ?.copyWith(color: colors.onSurfaceVariant),
      ),
      subtitle: Text(
        missing ? emptyText : v,
        style: context.textStyles.bodyLarge?.copyWith(
          color: missing ? colors.onSurfaceVariant : colors.onSurface,
        ),
      ),
    );
  }
}
