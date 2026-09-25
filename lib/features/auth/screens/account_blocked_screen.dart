import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/account_copy.dart';
import '../../../core/constants/domain_enums.dart';
import '../../../core/extensions/async_value_ext.dart';
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
        showAppSnackBar(context, error.message, tone: SnackTone.error);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: EmptyView(
          icon: Icons.lock_outline,
          title: AccountCopy.unavailableTitle,
          message: missingShop
              ? AccountCopy.missingShopMessage
              : AccountCopy.disabledMessage,
          secondaryActionLabel: 'Sign out',
          onSecondaryAction: signingOut ? null : signOut,
        ),
      ),
    );
  }
}
