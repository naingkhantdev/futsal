import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/constants/domain_labels.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/helpers/form_submit.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../data/vos/auth_session.dart';
import '../../../../data/vos/user_vo.dart';
import '../../../auth/providers/auth_session_provider.dart';
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
      '${user.hasName ? user.name : user.email} is now a shop admin',
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

    return Scaffold(
      appBar: AppBar(title: const Text('Add shop admin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: ContentConstraint(
          width: ContentWidth.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ask the shop owner to sign up in the app with their email '
                'first. Then find their account here.',
                style: context.textStyles.bodyMedium
                    ?.copyWith(color: context.colors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xl),
              Form(
                key: _formKey,
                child: AppTextField(
                  label: 'Account email',
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
                label: 'Find account',
                icon: Icons.search,
                isLoading: lookup.isLoading,
                expand: true,
                onPressed: _search,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (error != null) ...[
                InlineBanner(message: error.message),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (lookup.valueOrNull case final result?)
                result.user == null
                    ? InlineBanner(
                        tone: StatusTone.info,
                        icon: Icons.person_search_outlined,
                        message: 'No account uses ${result.email}. Ask them '
                            'to sign up with this email, then try again.',
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
        ),
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
    // Why this account can't (or shouldn't silently) be assigned.
    final (String? blocker, String? warning) = switch (role) {
      _ when isMe => ("You can't change your own role.", null),
      UserRole.superadmin => (
          "Platform admins can't be shop admins. Change their role first.",
          null,
        ),
      UserRole.shopAdmin when user.shopId == shopId => (
          'Already an admin of this shop.',
          null,
        ),
      UserRole.shopAdmin => (
          null,
          'This account manages another shop. Adding it here removes it '
              'from that shop.',
        ),
      null => ("This account's role is unknown. Fix it in the console.", null),
      UserRole.customer => (null, null),
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            user.hasName ? user.name : user.email,
            style: context.textStyles.titleMedium,
          ),
          if (user.hasName) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              user.email,
              style: context.textStyles.bodyMedium
                  ?.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Current role: ${role?.label ?? 'Unknown'}'
            '${user.isActive ? '' : ' · account disabled'}',
            style: context.textStyles.bodySmall
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          if (blocker != null || warning != null) ...[
            const SizedBox(height: AppSpacing.lg),
            InlineBanner(
              tone: blocker != null ? StatusTone.neutral : StatusTone.warning,
              message: blocker ?? warning!,
            ),
          ],
          if (blocker == null) ...[
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Make shop admin',
              icon: Icons.admin_panel_settings_outlined,
              isLoading: isAssigning,
              expand: true,
              onPressed: onAssign,
            ),
          ],
        ],
      ),
    );
  }
}
