import 'package:flutter/material.dart';

import '../../../core/constants/booking_policy.dart';
import '../../../core/constants/domain_enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../data/vos/booking_vo.dart';
import 'booking_detail_view.dart';
import 'booking_list_tile.dart';
import 'preview_body.dart';
import 'stadium_filter_bar.dart';

enum StaffBookingFilter {
  pending('Pending'),
  upcoming('Upcoming'),
  past('Past'),
  all('All');

  const StaffBookingFilter(this.label);
  final String label;
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
    return PreviewBody(
      children: [
        StadiumFilterBar(
          bookings: widget.bookings,
          selected: _stadiumId,
          onSelected: (id) => setState(() => _stadiumId = id),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final f in StaffBookingFilter.values)
              ChoiceChip(
                label: Text('${f.label} (${_apply(f).length})'),
                selected: f == _filter,
                onSelected: (_) => setState(() => _filter = f),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (shown.isEmpty)
          const EmptyView.inline(
            icon: Icons.inbox_outlined,
            title: 'No bookings here',
            message: 'Try another filter.',
          )
        else
          for (final b in shown) ...[
            BookingListTile(
              booking: b,
              showCustomer: true,
              onTap: () => widget.onOpen(b),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
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
    final canConfirm =
        BookingPolicy.canStaffChangeStatus(b.status, BookingStatus.confirmed);
    final canReject =
        BookingPolicy.canStaffChangeStatus(b.status, BookingStatus.rejected);
    final canComplete =
        BookingPolicy.canStaffChangeStatus(b.status, BookingStatus.completed) &&
            !b.isUpcoming(DateTime.now());
    final nextPayment = switch (b.paymentStatus) {
      PaymentStatus.unpaid => (PaymentStatus.pending, 'Mark payment pending'),
      PaymentStatus.pending => (PaymentStatus.paid, 'Mark as paid'),
      PaymentStatus.paid => (PaymentStatus.refunded, 'Mark as refunded'),
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
          PrimaryButton(
            label: 'Confirm booking',
            icon: Icons.check,
            expand: true,
            onPressed: () => showPreviewOnly(context, 'Confirm booking'),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (canComplete) ...[
          PrimaryButton(
            label: 'Mark as completed',
            icon: Icons.task_alt,
            expand: true,
            onPressed: () => showPreviewOnly(context, 'Mark as completed'),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (paymentOpen && nextPayment != null) ...[
          SecondaryButton(
            label: nextPayment.$2,
            icon: Icons.payments_outlined,
            expand: true,
            onPressed: () => showPreviewOnly(context, nextPayment.$2),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (canReject)
          AppTextButton(
            label: 'Reject booking',
            onPressed: () async {
              final ok = await showConfirmDialog(
                context,
                title: 'Reject this booking?',
                message: 'The customer is notified and the slots are '
                    'released.',
                confirmLabel: 'Reject',
                dismissLabel: 'Keep booking',
                destructive: true,
              );
              if (ok && context.mounted) {
                showPreviewOnly(context, 'Reject booking');
              }
            },
          ),
        for (final action in extraActions) ...[
          const SizedBox(height: AppSpacing.md),
          action,
        ],
      ],
    );
  }
}
