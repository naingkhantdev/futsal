import 'package:flutter/material.dart';

import '../constants/domain_enums.dart';
import 'status_tone.dart';

/// Status → (tone, icon, label) mappings from design_system.md §6.2–6.4.

extension BookingStatusVisual on BookingStatus {
  StatusVisual get visual => switch (this) {
        BookingStatus.pending =>
          const StatusVisual(StatusTone.warning, Icons.hourglass_top, 'Pending'),
        BookingStatus.confirmed =>
          const StatusVisual(StatusTone.success, Icons.check_circle, 'Confirmed'),
        BookingStatus.rejected =>
          const StatusVisual(StatusTone.danger, Icons.cancel, 'Rejected'),
        BookingStatus.cancelled =>
          const StatusVisual(StatusTone.neutral, Icons.event_busy, 'Cancelled'),
        BookingStatus.completed =>
          const StatusVisual(StatusTone.brand, Icons.task_alt, 'Completed'),
      };
}

extension PaymentStatusVisual on PaymentStatus {
  StatusVisual get visual => switch (this) {
        PaymentStatus.unpaid =>
          const StatusVisual(StatusTone.neutral, Icons.money_off, 'Unpaid'),
        PaymentStatus.pending =>
          const StatusVisual(StatusTone.warning, Icons.schedule, 'Payment pending'),
        PaymentStatus.paid =>
          const StatusVisual(StatusTone.success, Icons.paid, 'Paid'),
        PaymentStatus.refunded => const StatusVisual(
            StatusTone.info, Icons.currency_exchange, 'Refunded'),
      };
}

extension ShopStatusVisual on ShopStatus {
  StatusVisual get visual => switch (this) {
        ShopStatus.pending =>
          const StatusVisual(StatusTone.warning, Icons.pending, 'Pending review'),
        ShopStatus.active =>
          const StatusVisual(StatusTone.success, Icons.verified, 'Active'),
        ShopStatus.suspended =>
          const StatusVisual(StatusTone.danger, Icons.pause_circle, 'Suspended'),
        ShopStatus.rejected =>
          const StatusVisual(StatusTone.danger, Icons.cancel, 'Rejected'),
        ShopStatus.inactive => const StatusVisual(
            StatusTone.neutral, Icons.power_settings_new, 'Inactive'),
      };
}

/// Shop listing flag (`isListed`) badge.
StatusVisual shopListingVisual({required bool isListed}) => isListed
    ? const StatusVisual(StatusTone.brand, Icons.visibility, 'Listed')
    : const StatusVisual(StatusTone.neutral, Icons.visibility_off, 'Unlisted');
