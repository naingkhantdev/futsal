import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/detail_row.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/preview_body.dart';
import '../providers/booking_draft_provider.dart';

/// `/customer/stadiums/:stadiumId/book/review` — CUSTOMER scope: check the
/// picked court/time/price, then request the booking. PREVIEW: nothing is
/// written; "Request booking" opens the confirmation screen with a sample
/// booking.
class BookingReviewScreen extends ConsumerWidget {
  const BookingReviewScreen({super.key, required this.stadiumId});

  final String stadiumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final l = context.l10n;
    if (draft == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.reviewTitle)),
        body: EmptyView(
          icon: Icons.event_busy,
          title: l.reviewNothingTitle,
          message: l.reviewNothingMessage,
          actionLabel: l.reviewPickTime,
          onAction: () => context.pop(),
        ),
      );
    }

    final minutes = draft.range.durationMinutes;
    final total = draft.court.previewPrice(minutes) ?? 0;
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: Text(l.reviewTitle)),
      bottomNavigationBar: StickyBottomBar(
        child: PrimaryButton(
          label: l.requestBookingButton(Money.formatMmk(total)),
          size: AppButtonSize.large,
          expand: true,
          onPressed: () {
            ref.read(bookingDraftProvider.notifier).clear();
            showPreviewOnly(context, l.bookingRequestAction);
            // Sample pending booking stands in for the one just requested.
            context.go(
              AppRoutes.customerBookingConfirmation(
                DemoData.bookingsOfCustomer(DemoData.meId)
                    .firstWhere((b) => b.blocksAvailability)
                    .id,
              ),
            );
          },
        ),
      ),
      body: PreviewBody(
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
        ],
      ),
    );
  }
}
