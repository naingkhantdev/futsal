import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/constants/player_policy.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../data/vos/player_profile_vo.dart';
import '../providers/current_user_profile_provider.dart';
import '../providers/player_profile_providers.dart';

/// `/customer/profile/player` — CUSTOMER (self) scope: create or edit the
/// public player card (`players/{uid}`). No shopId; affects no shop.
class EditPlayerCardScreen extends ConsumerWidget {
  const EditPlayerCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(myPlayerProfileProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.playerCardTitle)),
      body: AsyncValueView<PlayerProfileVO?>(
        value: card,
        onRetry: () => ref.invalidate(myPlayerProfileProvider),
        data: (card) => _PlayerCardForm(card: card),
      ),
    );
  }
}

class _PlayerCardForm extends ConsumerStatefulWidget {
  const _PlayerCardForm({required this.card});

  /// `null` when creating.
  final PlayerProfileVO? card;

  @override
  ConsumerState<_PlayerCardForm> createState() => _PlayerCardFormState();
}

class _PlayerCardFormState extends ConsumerState<_PlayerCardForm> {
  // Seeded once; later snapshots don't overwrite in-progress edits.
  late PlayerPosition? _position = widget.card?.position;
  late SkillLevel? _skill = widget.card?.skillLevel;
  late final _bio = TextEditingController(text: widget.card?.bio ?? '');
  bool _showMissing = false;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _bio.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _bio.dispose();
    super.dispose();
  }

  bool get _hasChanges =>
      _position != widget.card?.position ||
      _skill != widget.card?.skillLevel ||
      _bio.text.trim() != (widget.card?.bio ?? '').trim();

  void _leave() {
    setState(() => _allowPop = true);
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
    FocusScope.of(context).unfocus();
    if (!_hasChanges && widget.card != null) {
      _leave();
      return;
    }
    final position = _position;
    final skill = _skill;
    if (position == null || skill == null) {
      setState(() => _showMissing = true);
      return;
    }
    final ok = await ref.read(playerProfileControllerProvider.notifier).save(
          position: position,
          skillLevel: skill,
          bio: _bio.text,
        );
    if (!ok || !mounted) return;
    showAppSnackBar(
      context,
      context.l10n.playerCardSaved,
      tone: SnackTone.success,
    );
    _leave();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(playerProfileControllerProvider);
    final isLoading = state.isLoading;
    final error = state.appError;
    final hasName = ref.watch(
      currentUserProfileProvider.select((p) => p.valueOrNull?.hasName ?? true),
    );
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;

    return PopScope(
      canPop: _allowPop || !_hasChanges,
      onPopInvoked: _onPopBlocked,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: ContentConstraint(
          width: ContentWidth.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!hasName) ...[
                InlineBanner(message: l.playerCardNeedsName),
                const SizedBox(height: AppSpacing.lg),
              ],
              _ChoiceGroup<PlayerPosition>(
                label: l.playerPositionLabel,
                values: PlayerPosition.values,
                selected: _position,
                labelOf: (p) => p.labelIn(l),
                showMissing: _showMissing,
                enabled: !isLoading,
                onSelected: (p) => setState(() => _position = p),
              ),
              const SizedBox(height: AppSpacing.xl),
              _ChoiceGroup<SkillLevel>(
                label: l.playerSkillLabel,
                values: SkillLevel.values,
                selected: _skill,
                labelOf: (s) => s.labelIn(l),
                showMissing: _showMissing,
                enabled: !isLoading,
                onSelected: (s) => setState(() => _skill = s),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _bio,
                readOnly: isLoading,
                maxLength: PlayerPolicy.bioMaxLength,
                minLines: 2,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l.playerBioLabel,
                  helperText: l.playerBioHelper,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.visibility_outlined, size: 18, color: muted),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l.playerCardVisibility,
                      style: styles.bodySmall?.copyWith(color: muted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              if (error != null) ...[
                InlineBanner(message: error.messageIn(l)),
                const SizedBox(height: AppSpacing.lg),
              ],
              PrimaryButton(
                label: l.commonSaveChanges,
                onPressed: hasName ? _save : null,
                isLoading: isLoading,
                size: AppButtonSize.large,
                expand: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Labelled single-choice chip row. Selection shows a check mark, not only
/// a color change.
class _ChoiceGroup<T> extends StatelessWidget {
  const _ChoiceGroup({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.showMissing,
    required this.enabled,
    required this.onSelected,
  });

  final String label;
  final List<T> values;
  final T? selected;
  final String Function(T) labelOf;
  final bool showMissing;
  final bool enabled;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final missing = showMissing && selected == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textStyles.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final v in values)
              ChoiceChip(
                label: Text(labelOf(v)),
                selected: v == selected,
                onSelected: enabled ? (_) => onSelected(v) : null,
              ),
          ],
        ),
        if (missing) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.playerChoiceRequired,
            style: context.textStyles.bodySmall
                ?.copyWith(color: context.colors.error),
          ),
        ],
      ],
    );
  }
}
