import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../shared/providers/booking_providers.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/booking_ticket.dart';
import '../../../shared/widgets/page_body.dart';

/// `/customer/bookings/:bookingId/confirmation` — CUSTOMER scope (own
/// booking): full-screen success after requesting a booking.
class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider(bookingId));
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          actionLabel: l.backToHome,
          onAction: () => context.go(AppRoutes.customerHome),
        ),
        data: (b) => _Confirmation(booking: b!),
      ),
    );
  }
}

class _Confirmation extends StatelessWidget {
  const _Confirmation({required this.booking});

  final BookingVO booking;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final styles = context.textStyles;
    final l = context.l10n;
    return PageBody(
      width: ContentWidth.form,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: IconCircle(
            icon: Icons.check_rounded,
            background: context.appColors.successContainer,
            foreground: context.appColors.onSuccessContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l.confirmTitle,
          textAlign: TextAlign.center,
          style: styles.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l.confirmMessage(b.stadiumNameSnapshot),
          textAlign: TextAlign.center,
          style:
              styles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xl),
        BookingTicket(booking: b),
        const SizedBox(height: AppSpacing.xl),
        TourAnchor(
          id: TourIds.primary,
          child: PrimaryButton(
            label: l.viewBooking,
            expand: true,
            onPressed: () => context.go(AppRoutes.customerBooking(b.id)),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          label: l.backToHome,
          expand: true,
          onPressed: () => context.go(AppRoutes.customerHome),
        ),
      ],
    );
  }
}
