import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/detail_row.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../data/vos/booking_draft.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/page_body.dart';
import '../../bookings/providers/customer_bookings_providers.dart';
import '../providers/booking_draft_provider.dart';

/// `/customer/stadiums/:stadiumId/book/review` — CUSTOMER scope: check the
/// picked court/time/price, then request the booking. The booking and its
/// slot lock docs are written in one transaction; firestore.rules re-check
/// everything (price, hours, slots, shop status).
class BookingReviewScreen extends ConsumerWidget {
  const BookingReviewScreen({super.key, required this.stadiumId});

  final String stadiumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final l = context.l10n;
    if (draft == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.reviewTitle),
          actions: const [TourHelpButton()],
        ),
        body: EmptyView(
          icon: Icons.event_busy,
          title: l.reviewNothingTitle,
          message: l.reviewNothingMessage,
          actionLabel: l.reviewPickTime,
          onAction: () => context.pop(),
        ),
      );
    }

    final submitting = ref.watch(createBookingControllerProvider).isLoading;
    final minutes = draft.range.durationMinutes;
    final total = draft.court.previewPrice(minutes) ?? 0;
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.reviewTitle),
        actions: const [TourHelpButton()],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TourAnchor(
          id: TourIds.primary,
          child: PrimaryButton(
            label: l.requestBookingButton(Money.formatMmk(total)),
            size: AppButtonSize.large,
            expand: true,
            isLoading: submitting,
            onPressed: submitting ? null : () => _submit(context, ref, draft),
          ),
        ),
      ),
      body: PageBody(
        width: ContentWidth.form,
        children: [
          Text(draft.stadium.name, style: styles.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(draft.court.name, style: styles.bodyLarge?.copyWith(color: muted)),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                DetailRow(
                  icon: Icons.event_outlined,
                  label: l.dateLabel,
                  value: DisplayFormat.fullDate(draft.date),
                ),
                DetailRow(
                  icon: Icons.schedule,
                  label: l.timeLabel,
                  value:
                      '${DisplayFormat.timeRange(draft.startMinute, draft.endMinute)}'
                      ' (${DisplayFormat.duration(minutes, l)})',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${Money.formatMmk(draft.court.hourlyPrice!)} × '
                        '${DisplayFormat.duration(minutes, l)}',
                        style: styles.bodyMedium?.copyWith(color: muted),
                      ),
                    ),
                    Text(Money.formatMmk(total), style: styles.bodyMedium),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Divider(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(l.totalLabel, style: styles.titleMedium),
                    ),
                    Text(Money.formatMmk(total), style: styles.titleMedium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          InlineBanner(tone: StatusTone.info, message: l.payAtVenueNote),
          const SizedBox(height: AppSpacing.md),
          // The booking copies this policy; the rules check it matches.
          InlineBanner(
            tone: StatusTone.info,
            message: [
              cancelPolicySummary(l, draft.stadium.freeCancelHours),
              if (draft.stadium.cancellationNote case final note?) note,
            ].join('\n'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(
    BuildContext context,
    WidgetRef ref,
    BookingDraft draft,
  ) async {
    final id =
        await ref.read(createBookingControllerProvider.notifier).submit(draft);
    if (!context.mounted) return;
    if (id != null) {
      ref.read(bookingDraftProvider.notifier).clear();
      context.go(AppRoutes.customerBookingConfirmation(id));
      return;
    }
    final error = ref.read(createBookingControllerProvider).error;
    final l = context.l10n;
    final failure =
        error is AppException ? error : UnknownException(cause: error);
    if (failure is BookingConflictException) {
      // The slot went to someone else: back to the grid to pick again.
      await showAppBottomSheet<void>(
        context,
        title: l.slotTakenTitle,
        content: Text(failure.messageIn(l)),
        actions: PrimaryButton(
          label: l.reviewPickTime,
          expand: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      );
      if (context.mounted) context.pop();
      return;
    }
    showAppSnackBar(context, failure.messageIn(l), tone: SnackTone.error);
  }
}
