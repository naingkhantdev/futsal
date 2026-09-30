import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/helpers/form_submit.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../providers/change_password_controller.dart';

/// `/customer/profile/change-password` — re-authenticates with the current
/// password, then sets the new one.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _newFieldKey = GlobalKey<FormFieldState<String>>();
  bool _submitted = false;

  /// Wrong current password, shown on the Current password field itself.
  String? _currentError;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    super.dispose();
  }

  void _onCurrentChanged(String _) {
    if (_currentError != null) setState(() => _currentError = null);
    // "Must differ from current" depends on this field.
    if (_submitted || _new.text.isNotEmpty) {
      _newFieldKey.currentState?.validate();
    }
  }

  void _onResult(AsyncValue<void>? _, AsyncValue<void> next) {
    if (next.appError is! IncorrectPasswordException) return;
    setState(() => _currentError = next.appError!.messageIn(context.l10n));
    _current.clear();
    _currentFocus.requestFocus();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _currentError = null;
    });
    final valid = validateFormForSubmit(
      context,
      formKey: _formKey,
      fields: [
        (
          focusNode: _currentFocus,
          validate: () => AppValidators.currentPassword(_current.text),
        ),
        (
          focusNode: _newFocus,
          validate: () =>
              AppValidators.changedPassword(_new.text, _current.text),
        ),
      ],
    );
    if (!valid) return;
    final ok = await ref.read(changePasswordControllerProvider.notifier).submit(
          currentPassword: _current.text,
          newPassword: _new.text,
        );
    if (!ok || !mounted) return;
    TextInput.finishAutofillContext();
    showAppSnackBar(
      context,
      context.l10n.passwordUpdated,
      tone: SnackTone.success,
    );
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.customerProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(changePasswordControllerProvider, _onResult);
    final state = ref.watch(changePasswordControllerProvider);
    final isLoading = state.isLoading;
    final appError = state.appError;
    // Wrong current password is a field error, not a banner.
    final error = appError is IncorrectPasswordException ? null : appError;
    final autovalidate = _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.changePassword),
        actions: const [TourHelpButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: ContentConstraint(
          width: ContentWidth.form,
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TourAnchor(
                    id: TourIds.password,
                    child: PasswordField(
                      label: l.currentPasswordLabel,
                      controller: _current,
                      focusNode: _currentFocus,
                      errorText: _currentError,
                      onChanged: _onCurrentChanged,
                      textInputAction: TextInputAction.next,
                      // While the server's "incorrect" error is shown (field
                      // just cleared), don't replace it with "required".
                      validator: (v) => _currentError != null
                          ? null
                          : AppValidators.currentPassword(v),
                      autovalidateMode: autovalidate,
                      readOnly: isLoading,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TourAnchor(
                    id: TourIds.newPassword,
                    child: PasswordField(
                      label: l.newPasswordLabel,
                      controller: _new,
                      focusNode: _newFocus,
                      fieldKey: _newFieldKey,
                      helperText: l.passwordHelper,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (v) =>
                          AppValidators.changedPassword(v, _current.text),
                      autovalidateMode: autovalidate,
                      readOnly: isLoading,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (error != null) ...[
                    InlineBanner(message: error.messageIn(l)),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  TourAnchor(
                    id: TourIds.primary,
                    child: PrimaryButton(
                      label: l.updatePassword,
                      onPressed: _submit,
                      isLoading: isLoading,
                      size: AppButtonSize.large,
                      expand: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
