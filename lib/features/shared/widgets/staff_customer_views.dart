import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_tone.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/display_format.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_row.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/demo/demo_data.dart';
import '../../../data/vos/booking_vo.dart';
import '../../../data/vos/user_vo.dart';
import './app_tour.dart';
import './app_tours.dart';
import 'booking_list_tile.dart';
import 'person_tile.dart';
import 'preview_body.dart';
import 'stat_grid.dart';

/// Searchable customer list. [shopId] limits it to customers who booked at
/// that shop (shop admin); `null` lists every customer (superadmin).
/// PREVIEW: `DemoData`.
class StaffCustomerList extends StatefulWidget {
  const StaffCustomerList({super.key, required this.shopId, required this.onOpen});

  final String? shopId;
  final ValueChanged<UserVO> onOpen;

  @override
  State<StaffCustomerList> createState() => _StaffCustomerListState();
}

class _StaffCustomerListState extends State<StaffCustomerList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final people = DemoData.customersOf(widget.shopId)
        .where((c) =>
            q.isEmpty ||
            c.name.toLowerCase().contains(q) ||
            (c.phone ?? '').replaceAll(' ', '').contains(q.replaceAll(' ', '')))
        .toList();
    final l = context.l10n;
    return PreviewBody(
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
                    detail: _detail(c, l),
                    onTap: () => widget.onOpen(c),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  String _detail(UserVO c, AppLocalizations l) {
    final stats = DemoData.customerStats(c.id, shopId: widget.shopId);
    return [
      l.bookingCount(stats.bookings),
      if (stats.lastPlayed != null)
        l.lastPlayedOn(DisplayFormat.shortDate(stats.lastPlayed!)),
      if (!c.isActive) l.accountDisabledTag,
    ].join(' · ');
  }
}

/// Customer profile for staff: contact, stats and booking history.
/// [shopId] limits stats/history to one shop (shop admin). [actions] holds
/// role-specific buttons (superadmin: disable account).
class StaffCustomerDetail extends StatelessWidget {
  const StaffCustomerDetail({
    super.key,
    required this.customer,
    required this.shopId,
    required this.onOpenBooking,
    this.actions = const [],
  });

  final UserVO customer;
  final String? shopId;
  final ValueChanged<BookingVO> onOpenBooking;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final c = customer;
    final stats = DemoData.customerStats(c.id, shopId: shopId);
    final history = DemoData.bookingsOfCustomer(c.id)
        .where((b) => shopId == null || b.shopId == shopId)
        .toList();
    final styles = context.textStyles;
    final l = context.l10n;
    return PreviewBody(
      children: [
        Row(
          children: [
            InitialsAvatar(name: c.name, size: AppSizes.avatarLarge),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name, style: styles.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    c.createdAt == null
                        ? l.roleCustomer
                        : l.joinedOn(DisplayFormat.shortDate(c.createdAt!)),
                    style: styles.bodyMedium
                        ?.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (!c.isActive)
              StatusBadge(
                tone: StatusTone.danger,
                icon: Icons.block,
                label: l.statusDisabled,
                semanticsPrefix: l.accountPrefix,
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
                value: c.phone,
              ),
              DetailRow(
                icon: Icons.mail_outline,
                label: l.emailLabel,
                value: c.email,
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
              footer: shopId == null ? l.mmkOnPlatform : l.mmkAtYourShop,
            ),
          ],
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          ...actions,
        ],
        PreviewSectionTitle(l.bookingHistory),
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
