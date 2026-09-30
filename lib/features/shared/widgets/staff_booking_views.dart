import 'package:flutter/material.dart';

import '../../../core/constants/booking_policy.dart';
import '../../../core/constants/domain_enums.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../data/vos/booking_vo.dart';
import './app_tour.dart';
import './app_tours.dart';
import 'booking_detail_view.dart';
import 'booking_list_tile.dart';
import 'preview_body.dart';
import 'stadium_filter_bar.dart';

enum StaffBookingFilter {
  pending,
  upcoming,
  past,
  all;

  String labelIn(AppLocalizations l) => switch (this) {
        StaffBookingFilter.pending => l.bookingPending,
        StaffBookingFilter.upcoming => l.staffFilterUpcoming,
        StaffBookingFilter.past => l.staffFilterPast,
        StaffBookingFilter.all => l.staffFilterAll,
      };
}

/// Bookings list for shop admins and the superadmin, with status filters.
/// PREVIEW: callers pass `DemoData` bookings.
class StaffBookingList extends StatefulWidget {
  const StaffBookingList({
    super.key,
    required this.bookings,
    required this.onOpen,
  });

  /// Newest first.
  final List<BookingVO> bookings;
  final ValueChanged<BookingVO> onOpen;

  @override
  State<StaffBookingList> createState() => _StaffBookingListState();
}

class _StaffBookingListState extends State<StaffBookingList> {
  StaffBookingFilter _filter = StaffBookingFilter.pending;

  /// `null` = all stadiums.
  String? _stadiumId;

  List<BookingVO> _apply(StaffBookingFilter f) {
    final now = DateTime.now();
    final list = _stadiumId == null
        ? widget.bookings
        : widget.bookings.where((b) => b.stadiumId == _stadiumId).toList();
    return switch (f) {
      StaffBookingFilter.pending =>
        list.where((b) => b.status == BookingStatus.pending).toList(),
      StaffBookingFilter.upcoming => _soonestFirst(
          list.where((b) => b.isUpcoming(now)),
        ),
      StaffBookingFilter.past =>
        list.where((b) => !b.isUpcoming(now)).toList(),
      StaffBookingFilter.all => list,
    };
  }

  static List<BookingVO> _soonestFirst(Iterable<BookingVO> list) =>
      list.toList()..sort((a, b) => a.startAt!.compareTo(b.startAt!));

  @override
  Widget build(BuildContext context) {
    final shown = _apply(_filter);
    final l = context.l10n;
    return PreviewBody(
      children: [
        TourAnchor(
          id: TourIds.stadiumFilter,
          child: StadiumFilterBar(
            bookings: widget.bookings,
            selected: _stadiumId,
            onSelected: (id) => setState(() => _stadiumId = id),
          ),
        ),
        TourAnchor(
          id: TourIds.filters,
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final f in StaffBookingFilter.values)
                ChoiceChip(
                  label: Text('${f.labelIn(l)} (${_apply(f).length})'),
                  selected: f == _filter,
                  onSelected: (_) => setState(() => _filter = f),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (shown.isEmpty)
          EmptyView.inline(
            icon: Icons.inbox_outlined,
            title: l.staffNoBookingsTitle,
            message: l.staffTryAnotherFilter,
          )
        else
          BookingGroup(
            bookings: shown,
            showCustomer: true,
            onOpen: widget.onOpen,
          ),
      ],
    );
  }
}

/// Booking detail for staff: sections + the status / payment actions that
/// [BookingPolicy] allows from the current state. PREVIEW: actions save
/// nothing.
class StaffBookingDetail extends StatelessWidget {
  const StaffBookingDetail({
    super.key,
    required this.booking,
    this.shopName,
    this.onCustomerTap,
    this.extraActions = const [],
  });

  final BookingVO booking;
  final String? shopName;
  final VoidCallback? onCustomerTap;

  /// Role-specific actions under the standard ones (shop admin: blacklist
  /// a no-show).
  final List<Widget> extraActions;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final l = context.l10n;
    final canConfirm =
        BookingPolicy.canStaffChangeStatus(b.status, BookingStatus.confirmed);
    final canReject =
        BookingPolicy.canStaffChangeStatus(b.status, BookingStatus.rejected);
    final canComplete =
        BookingPolicy.canStaffChangeStatus(b.status, BookingStatus.completed) &&
            !b.isUpcoming(DateTime.now());
    final nextPayment = switch (b.paymentStatus) {
      PaymentStatus.unpaid => (PaymentStatus.pending, l.markPaymentPending),
      PaymentStatus.pending => (PaymentStatus.paid, l.markAsPaid),
      PaymentStatus.paid => (PaymentStatus.refunded, l.markAsRefunded),
      PaymentStatus.refunded => null,
    };
    final paymentOpen = b.status != BookingStatus.rejected &&
        b.status != BookingStatus.cancelled;

    return PreviewBody(
      children: [
        BookingDetailSections(
          booking: b,
          showCustomer: true,
          shopName: shopName,
          onCustomerTap: onCustomerTap,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (canConfirm) ...[
          TourAnchor(
            id: TourIds.confirm,
            child: PrimaryButton(
              label: l.confirmBooking,
              icon: Icons.check,
              expand: true,
              onPressed: () => showPreviewOnly(context, l.confirmBooking),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (canComplete) ...[
          PrimaryButton(
            label: l.markAsCompleted,
            icon: Icons.task_alt,
            expand: true,
            onPressed: () => showPreviewOnly(context, l.markAsCompleted),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (paymentOpen && nextPayment != null) ...[
          TourAnchor(
            id: TourIds.payment,
            child: SecondaryButton(
              label: nextPayment.$2,
              icon: Icons.payments_outlined,
              expand: true,
              onPressed: () => showPreviewOnly(context, nextPayment.$2),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (canReject)
          TourAnchor(
            id: TourIds.reject,
            child: AppTextButton(
              label: l.rejectBooking,
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: l.rejectBookingTitle,
                  message: l.rejectBookingMessage,
                  confirmLabel: l.rejectAction,
                  dismissLabel: l.keepBooking,
                  destructive: true,
                );
                if (ok && context.mounted) {
                  showPreviewOnly(context, l.rejectBooking);
                }
              },
            ),
          ),
        for (final action in extraActions) ...[
          const SizedBox(height: AppSpacing.md),
          action,
        ],
      ],
    );
  }
}
