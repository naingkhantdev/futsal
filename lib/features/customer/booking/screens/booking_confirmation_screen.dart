import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/booking_ticket.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/customer/bookings/:bookingId/confirmation` — CUSTOMER scope: full-screen
/// success after requesting a booking. PREVIEW: sample booking.
class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final b = DemoData.booking(bookingId);
    final styles = context.textStyles;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: PreviewBody(
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
            style: styles.bodyMedium
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xl),
          BookingTicket(booking: b),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l.viewBooking,
            expand: true,
            onPressed: () => context.go(AppRoutes.customerBooking(b.id)),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: l.backToHome,
            expand: true,
            onPressed: () => context.go(AppRoutes.customerHome),
          ),
        ],
      ),
    );
  }
}
