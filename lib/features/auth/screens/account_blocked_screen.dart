import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/domain_enums.dart';
import '../../../core/extensions/async_value_ext.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/l10n_labels.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../data/vos/auth_session.dart';
import '../providers/auth_session_provider.dart';
import '../providers/sign_out_controller.dart';

/// `/account-blocked` — disabled account, or a shop admin without a valid
/// shop assignment. The only route allowed in that state.
class AccountBlockedScreen extends ConsumerWidget {
  const AccountBlockedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentAuthSessionProvider);
    final signingOut = ref.watch(signOutControllerProvider).isLoading;
    final l = context.l10n;
    // SHOP scope: an active shop admin lands here only without a shopId claim.
    final missingShop = session is SignedIn &&
        session.isActive &&
        session.role == UserRole.shopAdmin;

    Future<void> signOut() async {
      final ok = await ref.read(signOutControllerProvider.notifier).signOut();
      // On success the router leaves this screen; don't touch ref after that.
      if (ok || !context.mounted) return;
      final error = ref.read(signOutControllerProvider).appError;
      if (error != null) {
        showAppSnackBar(
          context,
          error.messageIn(context.l10n),
          tone: SnackTone.error,
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: EmptyView(
          icon: Icons.lock_outline,
          title: l.accountUnavailableTitle,
          message: missingShop
              ? l.accountMissingShopMessage
              : l.accountDisabledMessage,
          secondaryActionLabel: l.signOut,
          onSecondaryAction: signingOut ? null : signOut,
        ),
      ),
    );
  }
}
