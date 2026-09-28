import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import '../l10n/locale_controller.dart';
import '../theme/app_sizes.dart';
import '../theme/theme_context_ext.dart';
import 'app_bottom_sheet.dart';

String _nameOf(AppLocalizations l, Locale locale) =>
    locale.languageCode == LocaleController.myanmar.languageCode
        ? l.languageMyanmar
        : l.languageEnglish;

/// Bottom sheet listing the app languages; applies the choice at once.
Future<void> showLanguageSheet(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  final current = ref.read(localeProvider);
  return showAppBottomSheet<void>(
    context,
    title: l.languageTitle,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final locale in LocaleController.choices)
          ListTile(
            title: Text(_nameOf(l, locale)),
            trailing: locale == current
                ? Icon(Icons.check, color: context.colors.primary)
                : null,
            selected: locale == current,
            onTap: () {
              ref.read(localeProvider.notifier).select(locale);
              Navigator.of(context).pop();
            },
          ),
      ],
    ),
  );
}

/// "Language · မြန်မာ" row for profile / settings lists.
class LanguageTile extends ConsumerWidget {
  const LanguageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = ref.watch(localeProvider);
    return ListTile(
      leading: const Icon(Icons.translate, size: AppSizes.iconLg),
      title: Text(l.languageTitle),
      subtitle: Text(_nameOf(l, locale)),
      trailing:
          Icon(Icons.chevron_right, color: context.colors.onSurfaceVariant),
      onTap: () => showLanguageSheet(context, ref),
    );
  }
}

/// Compact language switch for the auth screens' top bar.
class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = ref.watch(localeProvider);
    return TextButton.icon(
      onPressed: () => showLanguageSheet(context, ref),
      icon: const Icon(Icons.translate, size: AppSizes.iconMd),
      label: Text(_nameOf(l, locale)),
      style: TextButton.styleFrom(
        foregroundColor: context.colors.onSurfaceVariant,
      ),
    );
  }
}
