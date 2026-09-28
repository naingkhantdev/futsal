import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/blacklist_policy.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../../data/requests/blacklist_requests.dart';
import '../../../shared/widgets/preview_body.dart';
import '../providers/blacklist_providers.dart';

/// "Add to blacklist" / "Blacklisted · Remove" for one customer at the
/// admin's shop. SHOP scope. With [noShow] the button reads "Didn't show up
/// · blacklist" (booking detail); the sheet starts on the no-show reason.
///
/// Sample (demo) customers only preview the action: nothing is written.
class BlacklistCustomerAction extends ConsumerWidget {
  const BlacklistCustomerAction({
    super.key,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    this.noShow = false,
  });

  final String customerId;
  final String customerName;
  final String? customerPhone;
  final bool noShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final entry = ref.watch(myBlacklistEntryProvider(customerId));
    final busy = ref.watch(blacklistControllerProvider).isLoading;

    if (entry.valueOrNull case final current?) {
      return Row(
        children: [
          StatusBadge(
            tone: StatusTone.danger,
            icon: Icons.block,
            label: l.blacklistedBadge,
            semanticsPrefix: l.blacklistTitle,
            size: StatusBadgeSize.medium,
          ),
          const Spacer(),
          AppTextButton(
            label: l.blacklistRemove,
            isLoading: busy,
            onPressed: () => _confirmRemove(context, ref, current.customerName),
          ),
        ],
      );
    }

    return SecondaryButton(
      label: noShow ? l.blacklistNoShowAction : l.blacklistAdd,
      icon: Icons.block,
      expand: true,
      // Wait for the entry so an existing one is never re-added.
      onPressed: entry.isLoading
          ? null
          : () => DemoData.isDemoId(customerId)
              ? showPreviewOnly(context, l.blacklistAdd)
              : showBlacklistSheet(
                  context,
                  customerId: customerId,
                  customerName: customerName,
                  customerPhone: customerPhone,
                ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    WidgetRef ref,
    String name,
  ) async {
    final l = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l.blacklistRemoveTitle(name),
      message: l.blacklistRemoveMessage,
      confirmLabel: l.blacklistRemoveConfirm,
      dismissLabel: l.blacklistKeep,
    );
    if (!ok || !context.mounted) return;
    final done =
        await ref.read(blacklistControllerProvider.notifier).remove(customerId);
    if (!context.mounted) return;
    final error = ref.read(blacklistControllerProvider).appError;
    showAppSnackBar(
      context,
      done ? l.blacklistRemoved(name) : error?.messageIn(l) ?? l.errUnknown,
      tone: done ? SnackTone.success : SnackTone.error,
    );
  }
}

/// Reason + optional note, then blacklists the customer.
Future<void> showBlacklistSheet(
  BuildContext context, {
  required String customerId,
  required String customerName,
  String? customerPhone,
  BlacklistReason initialReason = BlacklistReason.noShow,
}) {
  final l = context.l10n;
  return showAppBottomSheet<void>(
    context,
    title: l.blacklistSheetTitle(customerName),
    content: _BlacklistForm(
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      initialReason: initialReason,
    ),
  );
}

class _BlacklistForm extends ConsumerStatefulWidget {
  const _BlacklistForm({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.initialReason,
  });

  final String customerId;
  final String customerName;
  final String? customerPhone;
  final BlacklistReason initialReason;

  @override
  ConsumerState<_BlacklistForm> createState() => _BlacklistFormState();
}

class _BlacklistFormState extends ConsumerState<_BlacklistForm> {
  late BlacklistReason _reason = widget.initialReason;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(blacklistControllerProvider.notifier).add(
          BlacklistAddRequest(
            customerId: widget.customerId,
            customerName: widget.customerName,
            customerPhone: widget.customerPhone,
            reason: _reason,
            note: _note.text,
          ),
        );
    if (!ok || !mounted) return;
    // Shown by the app's messenger, so it outlives the sheet.
    showAppSnackBar(
      context,
      context.l10n.blacklistAdded(widget.customerName),
      tone: SnackTone.success,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(blacklistControllerProvider);
    final error = state.appError;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.blacklistSheetMessage,
          style: context.textStyles.bodyMedium
              ?.copyWith(color: context.colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l.reasonFieldLabel, style: context.textStyles.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (final r in BlacklistReason.values)
              ChoiceChip(
                label: Text(
                  r == BlacklistReason.noShow
                      ? l.blacklistReasonNoShow
                      : l.reasonOther,
                ),
                selected: r == _reason,
                onSelected: state.isLoading
                    ? null
                    : (_) => setState(() => _reason = r),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _note,
          readOnly: state.isLoading,
          maxLength: BlacklistPolicy.noteMaxLength,
          minLines: 2,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l.noteOptional),
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineBanner(message: error.messageIn(l)),
        ],
        const SizedBox(height: AppSpacing.lg),
        DestructiveButton(
          label: l.blacklistConfirm,
          icon: Icons.block,
          isLoading: state.isLoading,
          expand: true,
          onPressed: _submit,
        ),
      ],
    );
  }
}
