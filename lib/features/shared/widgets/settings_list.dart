import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/content_constraint.dart';
import '../../../core/widgets/language_picker.dart';
import '../../auth/widgets/sign_out_button.dart';

/// One settings row.
class SettingsItem {
  const SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
}

/// Settings page body: grouped rows in one card, then "Log out".
class SettingsList extends StatelessWidget {
  const SettingsList({super.key, required this.items});

  final List<SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.onSurfaceVariant;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      children: [
        ContentConstraint(
          width: ContentWidth.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final (i, item) in items.indexed) ...[
                      if (i > 0) const Divider(indent: 56),
                      ListTile(
                        leading: Icon(item.icon, size: AppSizes.iconLg),
                        title: Text(item.title),
                        subtitle:
                            item.subtitle == null ? null : Text(item.subtitle!),
                        trailing: Icon(Icons.chevron_right, color: muted),
                        onTap: item.onTap,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const AppCard(padding: EdgeInsets.zero, child: LanguageTile()),
              const SizedBox(height: AppSpacing.xl),
              const SignOutButton(),
            ],
          ),
        ),
      ],
    );
  }
}
