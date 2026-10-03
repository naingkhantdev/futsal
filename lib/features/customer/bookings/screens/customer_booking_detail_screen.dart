import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/providers/booking_providers.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/booking_detail_view.dart';
import '../../../shared/widgets/page_body.dart';

/// `/customer/bookings/:bookingId` — CUSTOMER scope (own booking): details,
/// venue link, cancel while pending/confirmed and not started.
class CustomerBookingDetailScreen extends ConsumerWidget {
  const CustomerBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider(bookingId));
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.bookingTitle),
        actions: const [TourHelpButton()],
      ),
      body: AsyncValueView<BookingVO?>(
        value: booking,
        onRetry: () => ref.invalidate(bookingProvider(bookingId)),
        isEmpty: (b) => b == null,
        empty: EmptyView(
          icon: Icons.event_busy,
          title: l.bookingNotFound,
          message: l.notFoundRemoved,
        ),
        data: (b) => _Detail(booking: b!),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.booking});

  final BookingVO booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = booking;
    final canCancel = BookingPolicy.canCustomerCancel(b.status) &&
        b.isUpcoming(DateTime.now());
    final busy = ref.watch(bookingActionsControllerProvider).isLoading;
    final l = context.l10n;
    return PageBody(
      width: ContentWidth.form,
      children: [
        BookingDetailSections(booking: b),
        const SizedBox(height: AppSpacing.xl),
        TourAnchor(
          id: TourIds.secondary,
          child: SecondaryButton(
            label: l.viewVenue,
            icon: Icons.stadium_outlined,
            expand: true,
            onPressed: () =>
                context.push(AppRoutes.customerStadium(b.stadiumId)),
          ),
        ),
        if (canCancel) ...[
          const SizedBox(height: AppSpacing.md),
          TourAnchor(
            id: TourIds.cancel,
            child: AppTextButton(
              label: l.cancelBooking,
              onPressed: busy ? null : () => _cancel(context, ref),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    // Tell the customer up front whether the venue's policy refunds this.
    final message = switch (booking.cancelsFreeAt(DateTime.now())) {
      true => '${l.cancelBookingMessage}\n\n${l.cancelFreeNow}',
      false => '${l.cancelBookingMessage}\n\n${l.cancelLateNow}',
      null => l.cancelBookingMessage,
    };
    final ok = await showConfirmDialog(
      context,
      title: l.cancelBookingTitle,
      message: message,
      confirmLabel: l.cancelBooking,
      dismissLabel: l.keepIt,
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    final done = await ref
        .read(bookingActionsControllerProvider.notifier)
        .cancel(booking.id);
    if (!context.mounted) return;
    if (done) {
      showAppSnackBar(context, l.bookingCancelledToast, tone: SnackTone.success);
      return;
    }
    final error = ref.read(bookingActionsControllerProvider).error;
    final failure =
        error is AppException ? error : UnknownException(cause: error);
    showAppSnackBar(context, failure.messageIn(l), tone: SnackTone.error);
  }
}
