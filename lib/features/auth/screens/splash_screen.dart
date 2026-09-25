import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/account_copy.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/vos/auth_session.dart';
import '../providers/auth_session_provider.dart';
import '../providers/sign_out_controller.dart';

/// `/splash` — shown while the session resolves (auth state, `users/{uid}`
/// profile, re-creating a missing profile). Logo centered; a small spinner
/// appears only after 600ms. On [SessionError] it shows "We couldn't load your account"
/// with "Try again" / "Sign out" (design_system.md §8.3).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const String _setupCaption = 'Setting up your account…';

  Timer? _spinnerTimer;
  Timer? _captionTimer;
  bool _showSpinner = false;
  bool _showCaption = false;

  @override
  void initState() {
    super.initState();
    _spinnerTimer = Timer(AppConstants.splashSpinnerDelay, () {
      if (mounted) setState(() => _showSpinner = true);
    });
    _captionTimer = Timer(AppConstants.splashCaptionDelay, () {
      if (mounted) setState(() => _showCaption = true);
    });
  }

  @override
  void dispose() {
    _spinnerTimer?.cancel();
    _captionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentAuthSessionProvider);
    if (session is SessionError) {
      return _SessionErrorView(session: session);
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sports_soccer,
              size: AppSizes.logoMark,
              color: context.colors.primary,
              semanticLabel: AppConstants.appName,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox.square(
              dimension: AppSizes.loadingSpinner,
              child: _showSpinner
                  ? const LoadingView(semanticLabel: 'Loading your account')
                  : null,
            ),
            if (_showCaption) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                _setupCaption,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium
                    ?.copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SessionErrorView extends ConsumerWidget {
  const _SessionErrorView({required this.session});

  final SessionError session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retrying = ref.watch(authSessionProvider).isLoading;
    final signingOut = ref.watch(signOutControllerProvider).isLoading;
    final busy = retrying || signingOut;
    final title = switch (session.failure) {
      SessionFailure.unrecognizedRole ||
      SessionFailure.accountDisabled =>
        AccountCopy.unavailableTitle,
      SessionFailure.timeout ||
      SessionFailure.setupFailed ||
      SessionFailure.loadFailed =>
        "We couldn't load your account",
    };

    return Scaffold(
      body: SafeArea(
        child: ErrorView(
          error: session.error,
          title: title,
          // Retry re-subscribes the session stream: fresh token + profile.
          onRetry: session.failure.canRetry && !busy
              ? () => ref.invalidate(authSessionProvider)
              : null,
          secondaryActionLabel: 'Sign out',
          onSecondaryAction: busy
              ? null
              : () => ref.read(signOutControllerProvider.notifier).signOut(),
        ),
      ),
    );
  }
}
