import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/booking_detail_view.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/customer/bookings/:bookingId` — CUSTOMER scope (own booking): details,
/// venue link, cancel while pending/confirmed and not started.
/// PREVIEW: sample data; cancelling saves nothing.
class CustomerBookingDetailScreen extends StatelessWidget {
  const CustomerBookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final b = DemoData.booking(bookingId);
    final canCancel = BookingPolicy.canCustomerCancel(b.status) &&
        b.isUpcoming(DateTime.now());
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.bookingTitle)),
      body: PreviewBody(
        width: ContentWidth.form,
        children: [
          BookingDetailSections(booking: b),
          const SizedBox(height: AppSpacing.xl),
          SecondaryButton(
            label: l.viewVenue,
            icon: Icons.stadium_outlined,
            expand: true,
            onPressed: () =>
                context.push(AppRoutes.customerStadium(b.stadiumId)),
          ),
          if (canCancel) ...[
            const SizedBox(height: AppSpacing.md),
            AppTextButton(
              label: l.cancelBooking,
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: l.cancelBookingTitle,
                  message: l.cancelBookingMessage,
                  confirmLabel: l.cancelBooking,
                  dismissLabel: l.keepIt,
                  destructive: true,
                );
                if (ok && context.mounted) {
                  showPreviewOnly(context, l.cancelBooking);
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
