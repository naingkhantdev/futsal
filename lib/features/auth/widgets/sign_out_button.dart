import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/async_value_ext.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/sign_out_controller.dart';

/// Asks for confirmation, then signs out. Used by every role's
/// profile/settings screen; the router moves to /login on success.
Future<void> confirmAndSignOut(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final confirmed = await showConfirmDialog(
    context,
    title: l.logOutConfirmTitle,
    message: l.logOutConfirmMessage,
    confirmLabel: l.logOut,
    dismissLabel: l.stayLoggedIn,
  );
  if (!confirmed || !context.mounted) return;
  final ok = await ref.read(signOutControllerProvider.notifier).signOut();
  // On success the router leaves this screen; don't touch ref after that.
  if (ok || !context.mounted) return;
  final error = ref.read(signOutControllerProvider).appError;
  if (error != null) {
    showAppSnackBar(context, error.messageIn(l), tone: SnackTone.error);
  }
}

/// Full-width outlined "Log out" button with confirm dialog + loading.
class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SecondaryButton(
      label: context.l10n.logOut,
      icon: Icons.logout,
      isLoading: ref.watch(signOutControllerProvider).isLoading,
      expand: true,
      onPressed: () => confirmAndSignOut(context, ref),
    );
  }
}
