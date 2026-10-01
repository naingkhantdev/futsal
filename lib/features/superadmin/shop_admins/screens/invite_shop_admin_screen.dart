import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/helpers/form_submit.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../data/vos/auth_session.dart';
import '../../../../data/vos/user_vo.dart';
import '../../../auth/providers/auth_session_provider.dart';
import '../../console/widgets/console_kit.dart';
import '../providers/shop_admins_providers.dart';

/// `/superadmin/shops/:shopId/admins/invite` — PLATFORM scope.
///
/// Spark plan: no Admin SDK, so accounts can't be created for someone.
/// The shop owner registers a normal customer account first; here the
/// superadmin finds it by email and makes it this shop's admin
/// (`users/{uid}.role = shopAdmin`, `shopId`). firestore.rules allow that
/// only for a superadmin, never on their own account, and only for an
/// existing shop.
class InviteShopAdminScreen extends ConsumerStatefulWidget {
  const InviteShopAdminScreen({super.key, required this.shopId});

  final String shopId;

  @override
  ConsumerState<InviteShopAdminScreen> createState() =>
      _InviteShopAdminScreenState();
}

class _InviteShopAdminScreenState extends ConsumerState<InviteShopAdminScreen> {
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

  Future<void> _search() async {
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
    await ref.read(shopAdminLookupControllerProvider.notifier).search(
          _email.text,
        );
  }

  Future<void> _assign(UserVO user) async {
    final ok = await ref
        .read(shopAdminAssignmentControllerProvider.notifier)
        .assign(user.id, widget.shopId);
    if (!ok || !mounted) return;
    showAppSnackBar(
      context,
      context.l10n.nowShopAdmin(user.hasName ? user.name : user.email),
      tone: SnackTone.success,
    );
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.superadminShopAdmins(widget.shopId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lookup = ref.watch(shopAdminLookupControllerProvider);
    final assigning = ref.watch(shopAdminAssignmentControllerProvider);
    final myUid = ref.watch(
      currentAuthSessionProvider.select((s) => s is SignedIn ? s.uid : null),
    );
    final error = lookup.appError ?? assigning.appError;
    final l = context.l10n;

    return Scaffold(
      appBar: ConsoleAppBar(title: l.addShopAdminTitle),
      body: ConsoleBody(
        width: ContentWidth.form,
        header: ConsoleBand(
          overline: '${l.consolePlatform} · ${l.audienceShopAdmins}',
          title: l.addShopAdminTitle,
          subtitle: l.inviteIntro,
          width: ContentWidth.form,
        ),
        children: [
          ConsolePanel(
            title: l.findAccount,
            padded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: AppTextField(
                    label: l.accountEmailLabel,
                    controller: _email,
                    focusNode: _emailFocus,
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.search,
                    validator: AppValidators.email,
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    onChanged: (_) {
                      if (lookup.valueOrNull != null) {
                        ref
                            .read(shopAdminLookupControllerProvider.notifier)
                            .clear();
                      }
                    },
                    onFieldSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SecondaryButton(
                  label: l.findAccount,
                  icon: Icons.search,
                  isLoading: lookup.isLoading,
                  expand: true,
                  onPressed: _search,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (error != null) ...[
            InlineBanner(message: error.messageIn(l)),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (lookup.valueOrNull case final result?)
            result.user == null
                ? InlineBanner(
                    tone: StatusTone.info,
                    icon: Icons.person_search_outlined,
                    message: l.noAccountForEmail(result.email),
                  )
                : _CandidateCard(
                    user: result.user!,
                    shopId: widget.shopId,
                    isMe: result.user!.id == myUid,
                    isAssigning: assigning.isLoading,
                    onAssign: () => _assign(result.user!),
                  ),
        ],
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.user,
    required this.shopId,
    required this.isMe,
    required this.isAssigning,
    required this.onAssign,
  });

  final UserVO user;
  final String shopId;
  final bool isMe;
  final bool isAssigning;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final role = user.role;
    final l = context.l10n;
    // Why this account can't (or shouldn't silently) be assigned.
    final (String? blocker, String? warning) = switch (role) {
      _ when isMe => (l.cantChangeOwnRole, null),
      UserRole.superadmin => (l.platformAdminCantBeShopAdmin, null),
      UserRole.shopAdmin when user.shopId == shopId => (
          l.alreadyAdminHere,
          null,
        ),
      UserRole.shopAdmin => (null, l.managesOtherShop),
      null => (l.roleUnknownFix, null),
      UserRole.customer => (null, null),
    };

    return ConsolePanel(
      title: l.accountPrefix,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConsoleField(
              label: l.fullNameLabel, value: user.hasName ? user.name : null),
          ConsoleField(label: l.emailLabel, value: user.email),
          ConsoleField(
            label: l.consoleRole,
            value: (role?.labelIn(l) ?? l.roleUnknown) +
                (user.isActive ? '' : ' · ${l.accountDisabledTag}'),
            last: blocker == null && warning == null,
          ),
          if (blocker != null || warning != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: InlineBanner(
                tone: blocker != null ? StatusTone.neutral : StatusTone.warning,
                message: blocker ?? warning!,
              ),
            ),
          if (blocker == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: PrimaryButton(
                label: l.makeShopAdmin,
                icon: Icons.admin_panel_settings_outlined,
                isLoading: isAssigning,
                expand: true,
                onPressed: onAssign,
              ),
            ),
        ],
      ),
    );
  }
}
