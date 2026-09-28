import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../l10n/l10n_labels.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';

/// Filled text field (design_system.md §5.2): flat light-gray fill, no border
/// until focus (ink) or error. Styling comes from the theme's
/// `inputDecorationTheme`. A floating label is always required.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.textInputAction,
    required this.keyboardType,
    this.controller,
    this.autofillHints,
    this.helperText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autovalidateMode,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.focusNode,
    this.errorText,
    this.fieldKey,
    this.minLines,
    this.maxLines = 1,
  });

  final String label;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Iterable<String>? autofillHints;
  final String? helperText;

  /// Only for format examples, e.g. "09xxxxxxxxx".
  final String? hintText;
  final IconData? prefixIcon;

  /// When set, replaces the trailing error icon.
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;

  /// Forms keep this `disabled` until first submit, then `onUserInteraction`.
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  /// External error (e.g. a server result tied to this field). Shown when
  /// the validator passes; the validator's own error takes precedence.
  final String? errorText;

  /// Key for the inner [FormFieldState], to re-validate this field alone.
  final GlobalKey<FormFieldState<String>>? fieldKey;

  /// Multi-line text (e.g. descriptions): pass `minLines` and a larger or
  /// `null` [maxLines], with `TextInputType.multiline`.
  final int? minLines;
  final int? maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hasError = false;

  String? _validate(String? value) {
    final raw = widget.validator?.call(value);
    // Validators return fixed English copy; show it in the app language.
    final error = raw == null ? null : localizeValidation(context.l10n, raw);
    final hasError = error != null;
    if (hasError != _hasError) {
      // Validation can run during build; defer the icon update.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _hasError = hasError);
      });
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final showErrorIcon = _hasError || widget.errorText != null;
    return TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      validator: widget.validator == null ? null : _validate,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        errorText: widget.errorText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, size: AppSizes.iconMd),
        suffixIcon: widget.suffixIcon ??
            (showErrorIcon
                ? Icon(Icons.error_outline,
                    size: AppSizes.iconMd, color: colors.error)
                : null),
      ),
    );
  }
}

/// Password field with a show/hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.label,
    this.controller,
    this.helperText,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
    this.autofillHints = const [AutofillHints.password],
    this.readOnly = false,
    this.autovalidateMode,
    this.focusNode,
    this.errorText,
    this.onChanged,
    this.fieldKey,
  });

  /// Defaults to "Password" in the app language.
  final String? label;
  final TextEditingController? controller;
  final String? helperText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;
  final Iterable<String> autofillHints;
  final bool readOnly;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final GlobalKey<FormFieldState<String>>? fieldKey;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppTextField(
      label: widget.label ?? l.passwordLabel,
      controller: widget.controller,
      helperText: widget.helperText,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: widget.autofillHints,
      readOnly: widget.readOnly,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      fieldKey: widget.fieldKey,
      obscureText: _obscured,
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        tooltip: _obscured ? l.showPassword : l.hidePassword,
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: AppSizes.iconMd,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      ),
    );
  }
}

/// Pill search field: height 48, no border, flat light-gray fill.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  /// Defaults to "Search" in the app language.
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: AppRadius.fullAll,
      borderSide: BorderSide.none,
    );
    return Container(
      height: AppSizes.searchFieldHeight,
      decoration:
          context.depth.wellDecoration(borderRadius: AppRadius.fullAll),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText ?? context.l10n.searchHint,
          fillColor: Colors.transparent,
          prefixIcon: const Icon(Icons.search, size: AppSizes.iconMd),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}
