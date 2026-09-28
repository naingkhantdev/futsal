import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/display_format.dart';

/// Initials avatar in the brand container tone.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.name, this.size = 40});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        child: Text(
          DisplayFormat.initials(name),
          style: (size >= AppSizes.avatarLarge
                  ? context.textStyles.titleLarge
                  : context.textStyles.labelLarge)
              ?.copyWith(color: colors.onPrimaryContainer),
        ),
      ),
    );
  }
}

/// A person row (customer lists): avatar, name, one detail line, and an
/// optional trailing widget.
class PersonTile extends StatelessWidget {
  const PersonTile({
    super.key,
    required this.name,
    required this.detail,
    this.trailing,
    this.onTap,
    this.detailMaxLines = 1,
  });

  final String name;
  final String detail;

  /// Lines of [detail] before it is cut off (e.g. 3 when it holds a note).
  final int detailMaxLines;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxs,
      ),
      leading: InitialsAvatar(name: name),
      title: Text(name),
      subtitle: Text(
        detail,
        maxLines: detailMaxLines,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: detailMaxLines > 1,
      trailing: trailing ??
          (onTap == null
              ? null
              : Icon(Icons.chevron_right,
                  color: context.colors.onSurfaceVariant)),
    );
  }
}
