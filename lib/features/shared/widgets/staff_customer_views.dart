import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/display_format.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_row.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../data/vos/booking_vo.dart';
import '../providers/booking_providers.dart';
import './app_tour.dart';
import './app_tours.dart';
import 'booking_list_tile.dart';
import 'person_tile.dart';
import 'page_body.dart';
import 'stat_grid.dart';

/// One row of [StaffCustomerList].
typedef StaffCustomerRow = ({
  String id,
  String name,
  String? phone,
  CustomerStats stats,
});

/// Searchable customer list (name / phone), with booking count and last
/// game per customer.
class StaffCustomerList extends StatefulWidget {
  const StaffCustomerList({
    super.key,
    required this.customers,
    required this.onOpen,
  });

  final List<StaffCustomerRow> customers;
  final ValueChanged<String> onOpen;

  @override
  State<StaffCustomerList> createState() => _StaffCustomerListState();
}

class _StaffCustomerListState extends State<StaffCustomerList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final digits = q.replaceAll(' ', '');
    final people = widget.customers
        .where((c) =>
            q.isEmpty ||
            c.name.toLowerCase().contains(q) ||
            (c.phone ?? '').replaceAll(' ', '').contains(digits))
        .toList();
    final l = context.l10n;
    return PageBody(
      children: [
        TourAnchor(
          id: TourIds.search,
          child: SearchField(
            hintText: l.searchNameOrPhone,
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (people.isEmpty)
          EmptyView.inline(
            icon: Icons.person_search_outlined,
            title: l.noCustomersFound,
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (i, c) in people.indexed) ...[
                  if (i > 0) const Divider(indent: 72),
                  PersonTile(
                    name: c.name,
                    detail: _detail(c.stats, l),
                    onTap: () => widget.onOpen(c.id),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  String _detail(CustomerStats stats, AppLocalizations l) {
    return [
      l.bookingCount(stats.bookings),
      if (stats.lastPlayed != null)
        l.lastPlayedOn(DisplayFormat.shortDate(stats.lastPlayed!)),
    ].join(' · ');
  }
}

/// Customer profile for a shop admin: contact (from booking snapshots),
/// stats and booking history at their shop. [actions] holds role-specific
/// buttons (blacklist).
class StaffCustomerDetail extends StatelessWidget {
  const StaffCustomerDetail({
    super.key,
    required this.name,
    required this.phone,
    required this.history,
    required this.onOpenBooking,
    this.actions = const [],
  });

  final String name;
  final String? phone;

  /// Newest first.
  final List<BookingVO> history;
  final ValueChanged<BookingVO> onOpenBooking;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final stats = customerStatsOf(history);
    final styles = context.textStyles;
    final l = context.l10n;
    return PageBody(
      children: [
        Row(
          children: [
            InitialsAvatar(name: name, size: AppSizes.avatarLarge),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: styles.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l.roleCustomer,
                    style: styles.bodyMedium
                        ?.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              DetailRow(
                icon: Icons.phone_outlined,
                label: l.profilePhone,
                value: phone,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        StatGrid(
          children: [
            StatCard(
              icon: Icons.event_note_outlined,
              label: l.navBookings,
              value: '${stats.bookings}',
            ),
            StatCard(
              icon: Icons.payments_outlined,
              label: l.paymentPaid,
              value: '${stats.spent ~/ 1000}K',
              footer: l.mmkAtYourShop,
            ),
          ],
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          ...actions,
        ],
        PageSectionTitle(l.bookingHistory),
        if (history.isEmpty)
          EmptyView.inline(
            icon: Icons.event_busy,
            title: l.noBookingsYet,
          )
        else
          BookingGroup(bookings: history, onOpen: onOpenBooking),
        if (stats.spent > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.totalPaidAmount(Money.formatMmk(stats.spent)),
            style: styles.bodySmall
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
