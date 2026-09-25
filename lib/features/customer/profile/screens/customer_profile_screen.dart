import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../data/vos/user_vo.dart';
import '../../../auth/widgets/sign_out_button.dart';
import '../providers/current_user_profile_provider.dart';
import '../widgets/profile_pending_view.dart';

/// `/customer/profile` — CUSTOMER (self) scope: view name/email/phone, edit
/// name/phone, change password, log out. (Profile photo: Phase 13.)
class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: AsyncValueView<UserVO?>(
        value: profile,
        onRetry: () => ref.invalidate(currentUserProfileProvider),
        isEmpty: (user) => user == null,
        empty: ProfilePendingView(
          onRetry: () => ref.invalidate(currentUserProfileProvider),
        ),
        data: (user) => _ProfileBody(user: user!),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});

  final UserVO user;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.onSurfaceVariant;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      children: [
        ContentConstraint(
          width: ContentWidth.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _IdentityHeader(user: user),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                padding: EdgeInsets.zero,
                child: _InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: user.hasPhone ? user.phone! : 'Not added',
                  muted: !user.hasPhone,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit_outlined,
                          size: AppSizes.iconLg),
                      title: const Text('Edit profile'),
                      trailing: Icon(Icons.chevron_right, color: muted),
                      onTap: () => context.push(AppRoutes.customerProfileEdit),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock_reset,
                          size: AppSizes.iconLg),
                      title: const Text('Change password'),
                      trailing: Icon(Icons.chevron_right, color: muted),
                      onTap: () =>
                          context.push(AppRoutes.customerChangePassword),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SignOutButton(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Initials avatar + name (titleLarge) + email.
class _IdentityHeader extends StatelessWidget {
  const _IdentityHeader({required this.user});

  final UserVO user;

  static String _initials(UserVO user) {
    final parts = user.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return user.email.isEmpty ? '?' : user.email[0].toUpperCase();
    }
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    return Row(
      children: [
        ExcludeSemantics(
          child: CircleAvatar(
            radius: AppSizes.avatarLarge / 2,
            backgroundColor: colors.primaryContainer,
            foregroundColor: colors.onPrimaryContainer,
            child: Text(_initials(user), style: styles.titleLarge
                ?.copyWith(color: colors.onPrimaryContainer)),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.hasName ? user.name : 'Add your name',
                style: styles.titleLarge?.copyWith(
                  color: user.hasName ? colors.onSurface : colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                user.email,
                style:
                    styles.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      leading: Icon(icon, size: AppSizes.iconLg, color: colors.onSurfaceVariant),
      title: Text(
        label,
        style: context.textStyles.labelMedium
            ?.copyWith(color: colors.onSurfaceVariant),
      ),
      subtitle: Text(
        value,
        style: context.textStyles.bodyLarge?.copyWith(
          color: muted ? colors.onSurfaceVariant : colors.onSurface,
        ),
      ),
    );
  }
}
