import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/loading_view.dart';

/// Shown while `users/{uid}` does not exist yet (server still creating it).
/// Spinner first; after [AppConstants.profileProvisionTimeout] it offers
/// "Try again", which calls [onRetry] (re-subscribe the profile provider)
/// and restarts the wait.
class ProfilePendingView extends StatefulWidget {
  const ProfilePendingView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  State<ProfilePendingView> createState() => _ProfilePendingViewState();
}

class _ProfilePendingViewState extends State<ProfilePendingView> {
  Timer? _timer;
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    _startWaiting();
  }

  void _startWaiting() {
    _timer?.cancel();
    _timer = Timer(AppConstants.profileProvisionTimeout, () {
      if (mounted) setState(() => _timedOut = true);
    });
  }

  void _retry() {
    setState(() => _timedOut = false);
    _startWaiting();
    widget.onRetry();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_timedOut) {
      return const LoadingView(semanticLabel: 'Loading your profile');
    }
    return EmptyView(
      icon: Icons.person_outline,
      title: "Your profile isn't ready yet",
      message: 'This is taking longer than usual. Check your connection and '
          'try again.',
      actionLabel: 'Try again',
      onAction: _retry,
    );
  }
}
