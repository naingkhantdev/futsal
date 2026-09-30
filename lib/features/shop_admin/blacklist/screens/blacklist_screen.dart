import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../data/vos/blacklist_entry_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/person_tile.dart';
import '../providers/blacklist_providers.dart';

/// `/shop-admin/settings/blacklist` — SHOP scope: customers who can't make
/// new bookings at the admin's shop (e.g. repeated no-shows), with "Remove".
/// Entries are added from a customer's profile or a missed booking.
class BlacklistScreen extends ConsumerWidget {
  const BlacklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.blacklistTitle),
        actions: const [TourHelpButton()],
      ),
      body: AsyncValueView<List<BlacklistEntryVO>>(
        value: ref.watch(myBlacklistProvider),
        onRetry: () => ref.invalidate(myBlacklistProvider),
        loading: const _BlacklistSkeleton(),
        isEmpty: (list) => list.isEmpty,
        empty: EmptyView(
          icon: Icons.verified_user_outlined,
          title: l.blacklistEmptyTitle,
          message: l.blacklistEmptyMessage,
        ),
        data: (list) => ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          children: [
            ContentConstraint(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.blacklistIntro,
                    style: context.textStyles.bodyMedium
                        ?.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final (i, entry) in list.indexed) ...[
                          if (i > 0) const Divider(indent: 72),
                          _EntryTile(entry: entry),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry});

  final BlacklistEntryVO entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final reason = entry.reason == BlacklistReason.noShow
        ? l.blacklistReasonNoShow
        : l.reasonOther;
    final details = [
      reason,
      if (entry.customerPhone != null) entry.customerPhone!,
      if (entry.createdAt != null)
        l.blacklistedOn(DisplayFormat.shortDate(entry.createdAt!)),
    ].join(' · ');
    final note = entry.note;
    return PersonTile(
      name: entry.customerName,
      detail: note == null ? details : '$details\n$note',
      detailMaxLines: note == null ? 1 : 3,
      trailing: IconButton(
        tooltip: l.blacklistRemove,
        icon: const Icon(Icons.person_remove_outlined),
        onPressed: () => _remove(context, ref),
      ),
    );
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l.blacklistRemoveTitle(entry.customerName),
      message: l.blacklistRemoveMessage,
      confirmLabel: l.blacklistRemoveConfirm,
      dismissLabel: l.blacklistKeep,
    );
    if (!ok || !context.mounted) return;
    final done = await ref
        .read(blacklistControllerProvider.notifier)
        .remove(entry.customerId);
    if (!context.mounted) return;
    final error = ref.read(blacklistControllerProvider).appError;
    showAppSnackBar(
      context,
      done
          ? l.blacklistRemoved(entry.customerName)
          : error?.messageIn(l) ?? l.errUnknown,
      tone: done ? SnackTone.success : SnackTone.error,
    );
  }
}

class _BlacklistSkeleton extends StatelessWidget {
  const _BlacklistSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      children: const [
        ContentConstraint(
          child: Column(
            children: [
              SkeletonListTile(),
              SkeletonListTile(),
              SkeletonListTile(),
            ],
          ),
        ),
      ],
    );
  }
}
