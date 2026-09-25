import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/async_value_ext.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/sign_out_controller.dart';

/// Asks for confirmation, then signs out. Used by every role's
/// profile/settings screen; the router moves to /login on success.
Future<void> confirmAndSignOut(BuildContext context, WidgetRef ref) async {
  final confirmed = await showConfirmDialog(
    context,
    title: 'Log out?',
    message: "You'll need to log in again to use the app.",
    confirmLabel: 'Log out',
    dismissLabel: 'Stay logged in',
  );
  if (!confirmed || !context.mounted) return;
  final ok = await ref.read(signOutControllerProvider.notifier).signOut();
  // On success the router leaves this screen; don't touch ref after that.
  if (ok || !context.mounted) return;
  final error = ref.read(signOutControllerProvider).appError;
  if (error != null) {
    showAppSnackBar(context, error.message, tone: SnackTone.error);
  }
}

/// Full-width outlined "Log out" button with confirm dialog + loading.
class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SecondaryButton(
      label: 'Log out',
      icon: Icons.logout,
      isLoading: ref.watch(signOutControllerProvider).isLoading,
      expand: true,
      onPressed: () => confirmAndSignOut(context, ref),
    );
  }
}
