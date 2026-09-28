import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/helpers/form_submit.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../data/vos/user_vo.dart';
import '../providers/current_user_profile_provider.dart';
import '../providers/edit_profile_controller.dart';
import '../widgets/profile_pending_view.dart';

/// `/customer/profile/edit` — CUSTOMER (self) scope: name and phone only.
/// Email, role and account status are not editable here.
class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.editProfile)),
      body: AsyncValueView<UserVO?>(
        value: profile,
        onRetry: () => ref.invalidate(currentUserProfileProvider),
        isEmpty: (user) => user == null,
        empty: ProfilePendingView(
          onRetry: () => ref.invalidate(currentUserProfileProvider),
        ),
        data: (user) => _EditProfileForm(user: user!),
      ),
    );
  }
}

class _EditProfileForm extends ConsumerStatefulWidget {
  const _EditProfileForm({required this.user});

  final UserVO user;

  @override
  ConsumerState<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  // Seeded once; later profile snapshots don't overwrite in-progress edits.
  late final _name = TextEditingController(text: widget.user.name);
  late final _phone = TextEditingController(text: widget.user.phone ?? '');
  late final _email = TextEditingController(text: widget.user.email);
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  bool _submitted = false;
  bool _isDirty = false;

  /// Set right before leaving on purpose (saved / discarded), so PopScope
  /// doesn't ask again.
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_updateDirty);
    _phone.addListener(_updateDirty);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  bool get _hasChanges =>
      _name.text.trim() != widget.user.name.trim() ||
      AppValidators.normalizePhone(_phone.text) !=
          AppValidators.normalizePhone(widget.user.phone);

  void _updateDirty() {
    final dirty = _hasChanges;
    if (dirty != _isDirty) setState(() => _isDirty = dirty);
  }

  void _leave() {
    setState(() => _allowPop = true);
    // Pop after the rebuild so PopScope.canPop is already true.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.customerProfile);
      }
    });
  }

  Future<void> _onPopBlocked(bool didPop) async {
    if (didPop) return;
    final l = context.l10n;
    final discard = await showConfirmDialog(
      context,
      title: l.commonDiscardTitle,
      message: l.profileDiscardMessage,
      confirmLabel: l.commonDiscard,
      dismissLabel: l.commonKeepEditing,
      destructive: true,
    );
    if (discard && mounted) _leave();
  }

  Future<void> _save() async {
    if (!_hasChanges) {
      FocusScope.of(context).unfocus();
      _leave();
      return;
    }
    setState(() => _submitted = true);
    final valid = validateFormForSubmit(
      context,
      formKey: _formKey,
      fields: [
        (focusNode: _nameFocus, validate: () => AppValidators.name(_name.text)),
        (
          focusNode: _phoneFocus,
          validate: () => AppValidators.optionalPhone(_phone.text),
        ),
      ],
    );
    if (!valid) return;
    final ok = await ref
        .read(editProfileControllerProvider.notifier)
        .save(name: _name.text, phone: _phone.text);
    if (!ok || !mounted) return;
    showAppSnackBar(
      context,
      context.l10n.profileUpdated,
      tone: SnackTone.success,
    );
    _leave();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileControllerProvider);
    final isLoading = state.isLoading;
    final error = state.appError;
    final autovalidate = _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;
    final l = context.l10n;

    return PopScope(
      canPop: _allowPop || !_isDirty,
      onPopInvoked: _onPopBlocked,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: ContentConstraint(
          width: ContentWidth.form,
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: l.fullNameLabel,
                    controller: _name,
                    focusNode: _nameFocus,
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.name],
                    validator: AppValidators.name,
                    autovalidateMode: autovalidate,
                    readOnly: isLoading,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: l.phoneOptionalLabel,
                    controller: _phone,
                    focusNode: _phoneFocus,
                    prefixIcon: Icons.phone_outlined,
                    helperText: l.phoneHelper,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    validator: AppValidators.optionalPhone,
                    autovalidateMode: autovalidate,
                    readOnly: isLoading,
                    onFieldSubmitted: (_) => _save(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Read-only (full contrast), not disabled: users should be
                  // able to read and copy it, just not change it.
                  AppTextField(
                    label: l.emailLabel,
                    controller: _email,
                    prefixIcon: Icons.mail_outline,
                    helperText: l.emailCantChange,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    readOnly: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (error != null) ...[
                    InlineBanner(message: error.messageIn(l)),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  PrimaryButton(
                    label: l.commonSaveChanges,
                    onPressed: _save,
                    isLoading: isLoading,
                    size: AppButtonSize.large,
                    expand: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
