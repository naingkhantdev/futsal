import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/extensions/async_value_ext.dart';
import '../../../core/helpers/form_submit.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/inline_banner.dart';
import '../providers/register_controller.dart';
import '../widgets/auth_layout.dart';

/// `/register` — CUSTOMER self-registration (design_system.md §9).
/// There is no role picker: the server assigns `customer` (onCreate Cloud
/// Function). Shop admins are provisioned by the superadmin.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const String _venueOwnerNote =
      'Own a futsal venue? Shop accounts are set up by our team — '
      'contact us to join.';
  static const String _termsNote =
      'By continuing you agree to the Terms and Privacy Policy.';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    final valid = validateFormForSubmit(
      context,
      formKey: _formKey,
      fields: [
        (focusNode: _nameFocus, validate: () => AppValidators.name(_name.text)),
        (
          focusNode: _emailFocus,
          validate: () => AppValidators.email(_email.text),
        ),
        (
          focusNode: _phoneFocus,
          validate: () => AppValidators.optionalPhone(_phone.text),
        ),
        (
          focusNode: _passwordFocus,
          validate: () => AppValidators.newPassword(_password.text),
        ),
      ],
    );
    if (!valid) return;
    final ok = await ref.read(registerControllerProvider.notifier).submit(
          name: _name.text,
          email: _email.text,
          phone: _phone.text,
          password: _password.text,
        );
    if (ok) TextInput.finishAutofillContext();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
    final isLoading = state.isLoading;
    final error = state.appError;
    final muted = context.colors.onSurfaceVariant;
    final autovalidate = _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return AuthLayout(
      headline: 'Create your account',
      subtitle: 'Book futsal courts in a few taps.',
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Full name',
                  controller: _name,
                  focusNode: _nameFocus,
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  validator: AppValidators.name,
                  autovalidateMode: autovalidate,
                  readOnly: isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Email',
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
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Phone (optional)',
                  controller: _phone,
                  focusNode: _phoneFocus,
                  prefixIcon: Icons.phone_outlined,
                  helperText: 'Venues use this to reach you about bookings',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  validator: AppValidators.optionalPhone,
                  autovalidateMode: autovalidate,
                  readOnly: isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                PasswordField(
                  controller: _password,
                  focusNode: _passwordFocus,
                  helperText: 'At least 8 characters',
                  autofillHints: const [AutofillHints.newPassword],
                  validator: AppValidators.newPassword,
                  autovalidateMode: autovalidate,
                  readOnly: isLoading,
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Terms / Privacy links arrive with the legal pages (Phase 16).
        Text(
          RegisterScreen._termsNote,
          style: context.textStyles.bodySmall?.copyWith(color: muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (error != null) ...[
          InlineBanner(
            message: error.message,
            actionLabel: error is EmailAlreadyInUseException ? 'Log in' : null,
            onAction: error is EmailAlreadyInUseException
                ? () => context.go(AppRoutes.login)
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        PrimaryButton(
          label: 'Create account',
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
            const Text('Already have an account?'),
            AppTextButton(
              label: 'Log in',
              onPressed: isLoading ? null : () => context.go(AppRoutes.login),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: AppSizes.iconSm,
              color: muted,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                RegisterScreen._venueOwnerNote,
                style: context.textStyles.bodySmall?.copyWith(color: muted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
