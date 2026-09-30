import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/async_value_ext.dart';
import '../../../core/helpers/form_submit.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/l10n_labels.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/inline_banner.dart';
import '../../shared/widgets/app_tour.dart';
import '../../shared/widgets/app_tours.dart';
import '../providers/login_controller.dart';
import '../widgets/auth_layout.dart';

/// `/login` (design_system.md §9). Sign-in runs in [LoginController]; the
/// router redirects once the session resolves.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _submitted = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    final valid = validateFormForSubmit(
      context,
      formKey: _formKey,
      fields: [
        (
          focusNode: _emailFocus,
          validate: () => AppValidators.email(_email.text),
        ),
        (
          focusNode: _passwordFocus,
          validate: () => AppValidators.loginPassword(_password.text),
        ),
      ],
    );
    if (!valid) return;
    final ok = await ref
        .read(loginControllerProvider.notifier)
        .submit(email: _email.text, password: _password.text);
    if (ok) TextInput.finishAutofillContext();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final isLoading = state.isLoading;
    final error = state.appError;
    final autovalidate = _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;
    final l = context.l10n;

    return AuthLayout(
      headline: l.loginHeadline,
      subtitle: l.loginSubtitle,
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TourAnchor(
                  id: TourIds.email,
                  child: AppTextField(
                    label: l.emailLabel,
                    controller: _email,
                    focusNode: _emailFocus,
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: AppValidators.email,
                    autovalidateMode: autovalidate,
                    readOnly: isLoading,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PasswordField(
                  controller: _password,
                  focusNode: _passwordFocus,
                  validator: AppValidators.loginPassword,
                  autovalidateMode: autovalidate,
                  readOnly: isLoading,
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        TourAnchor(
          id: TourIds.forgot,
          child: Align(
            alignment: Alignment.centerRight,
            child: AppTextButton(
              label: l.forgotPasswordLink,
              onPressed:
                  isLoading ? null : () => context.push(AppRoutes.forgotPassword),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (error != null) ...[
          InlineBanner(message: error.messageIn(l)),
          const SizedBox(height: AppSpacing.lg),
        ],
        PrimaryButton(
          label: l.loginButton,
          onPressed: _submit,
          isLoading: isLoading,
          size: AppButtonSize.large,
          expand: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l.newHere),
            TourAnchor(
              id: TourIds.register,
              child: AppTextButton(
                label: l.createAccountLink,
                onPressed: isLoading ? null : () => context.go(AppRoutes.register),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
