import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/form_submit.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/l10n_labels.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/inline_banner.dart';
import '../providers/password_reset_controller.dart';
import '../widgets/auth_layout.dart';

/// `/forgot-password` (design_system.md §9). On success the form is
/// replaced by a "Check your email" view that never reveals whether an
/// account exists for the address.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _emailFocus = FocusNode();
  bool _submitted = false;

  @override
  void dispose() {
    _email.dispose();
    _emailFocus.dispose();
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
      ],
    );
    if (!valid) return;
    await ref.read(passwordResetControllerProvider.notifier).send(_email.text);
  }

  void _backToLogin() => context.go(AppRoutes.login);

  void _onStateChanged(PasswordResetState? previous, PasswordResetState next) {
    final wasSent = previous?.isSent ?? false;
    final finishedSending = (previous?.isSending ?? false) &&
        !next.isSending &&
        next.error == null;
    if (!wasSent && next.isSent) {
      // Form replaced by the success view: tell screen-reader users.
      final l = context.l10n;
      SemanticsService.announce(
        '${l.resetSentHeadline}. ${l.resetSentMessage(next.sentTo!)}',
        Directionality.of(context),
      );
    } else if (wasSent && next.isSent && finishedSending) {
      showAppSnackBar(
        context,
        context.l10n.resetResent,
        tone: SnackTone.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(passwordResetControllerProvider, _onStateChanged);
    final state = ref.watch(passwordResetControllerProvider);
    final l = context.l10n;
    if (state.isSent) {
      return AuthLayout(
        headline: l.resetSentHeadline,
        subtitle: l.resetSentMessage(state.sentTo!),
        children: [
          _ResetSentView(
            state: state,
            onBackToLogin: _backToLogin,
            onResend: () => ref
                .read(passwordResetControllerProvider.notifier)
                .send(state.sentTo!),
          ),
        ],
      );
    }

    return AuthLayout(
      headline: l.forgotHeadline,
      subtitle: l.forgotSubtitle,
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: AppTextField(
              label: l.emailLabel,
              controller: _email,
              focusNode: _emailFocus,
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: AppValidators.email,
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              readOnly: state.isSending,
              onFieldSubmitted: (_) => _submit(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (state.error != null) ...[
          InlineBanner(message: state.error!.messageIn(l)),
          const SizedBox(height: AppSpacing.lg),
        ],
        PrimaryButton(
          label: l.sendResetLink,
          onPressed: _submit,
          isLoading: state.isSending,
          size: AppButtonSize.large,
          expand: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: AppTextButton(
            label: l.backToLogin,
            onPressed: state.isSending ? null : _backToLogin,
          ),
        ),
      ],
    );
  }
}

class _ResetSentView extends StatelessWidget {
  const _ResetSentView({
    required this.state,
    required this.onBackToLogin,
    required this.onResend,
  });

  final PasswordResetState state;
  final VoidCallback onBackToLogin;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: IconCircle(
            icon: Icons.mark_email_read_outlined,
            background: colors.primaryContainer,
            foreground: colors.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (state.error != null) ...[
          InlineBanner(message: state.error!.messageIn(l)),
          const SizedBox(height: AppSpacing.lg),
        ],
        PrimaryButton(
          label: l.backToLogin,
          onPressed: onBackToLogin,
          size: AppButtonSize.large,
          expand: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: _ResendButton(
            sentAt: state.sentAt,
            isSending: state.isSending,
            onResend: onResend,
          ),
        ),
      ],
    );
  }
}

/// "Resend" disabled for [AppConstants.passwordResetResendCooldown] after
/// each send, with a live countdown.
class _ResendButton extends StatefulWidget {
  const _ResendButton({
    required this.sentAt,
    required this.isSending,
    required this.onResend,
  });

  final DateTime? sentAt;
  final bool isSending;
  final VoidCallback onResend;

  @override
  State<_ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<_ResendButton> {
  static const Duration _tick = Duration(seconds: 1);
  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void didUpdateWidget(_ResendButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sentAt != widget.sentAt) _restart();
  }

  void _restart() {
    _timer?.cancel();
    _secondsLeft = _remaining();
    if (_secondsLeft <= 0) return;
    _timer = Timer.periodic(_tick, (timer) {
      final left = _remaining();
      if (!mounted) return;
      setState(() => _secondsLeft = left);
      if (left <= 0) timer.cancel();
    });
  }

  int _remaining() {
    final sentAt = widget.sentAt;
    if (sentAt == null) return 0;
    final elapsed = DateTime.now().difference(sentAt);
    final left = AppConstants.passwordResetResendCooldown - elapsed;
    if (left.isNegative) return 0;
    return (left.inMilliseconds / Duration.millisecondsPerSecond).ceil();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coolingDown = _secondsLeft > 0;
    return AppTextButton(
      label: coolingDown
          ? context.l10n.resendIn(_secondsLeft)
          : context.l10n.resend,
      isLoading: widget.isSending,
      onPressed: coolingDown || widget.isSending ? null : widget.onResend,
    );
  }
}
