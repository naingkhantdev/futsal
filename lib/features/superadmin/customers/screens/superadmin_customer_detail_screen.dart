import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../../data/vos/user_vo.dart';
import '../../../shared/widgets/preview_body.dart';
import '../../console/widgets/console_booking_table.dart';
import '../../console/widgets/console_kit.dart';

/// `/superadmin/customers/:customerId` — PLATFORM scope: account, activity
/// and bookings at every shop; the superadmin can disable / enable the
/// account (`users/{uid}.isActive`). PREVIEW: sample data, actions save
/// nothing.
class SuperadminCustomerDetailScreen extends StatelessWidget {
  const SuperadminCustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    final c = DemoData.customer(customerId);
    final stats = DemoData.customerStats(c.id);
    final history = DemoData.bookingsOfCustomer(c.id);
    final l = context.l10n;

    return Scaffold(
      appBar: ConsoleAppBar(title: l.roleCustomer),
      body: ConsoleBody(
        demo: true,
        header: ConsoleBand(
          overline: '${l.consolePlatform} · ${l.roleCustomer}',
          title: c.name,
          subtitle: c.createdAt == null
              ? null
              : l.joinedOn(DisplayFormat.shortDate(c.createdAt!)),
          badges: [
            if (c.isActive)
              StatusBadge(
                tone: StatusTone.success,
                icon: Icons.check_circle,
                label: l.consoleActive,
                semanticsPrefix: l.accountPrefix,
                size: StatusBadgeSize.medium,
              )
            else
              StatusBadge(
                tone: StatusTone.danger,
                icon: Icons.block,
                label: l.statusDisabled,
                semanticsPrefix: l.accountPrefix,
                size: StatusBadgeSize.medium,
              ),
          ],
          metrics: [
            ConsoleMetric(value: '${stats.bookings}', label: l.navBookings),
            ConsoleMetric(
              value: Money.formatMmk(stats.spent),
              label: l.paymentPaid,
            ),
          ],
        ),
        children: [
          ConsoleColumns(
            children: [
              ConsolePanel(
                title: l.consoleContact,
                child: Column(
                  children: [
                    ConsoleField(label: l.profilePhone, value: c.phone),
                    ConsoleField(label: l.emailLabel, value: c.email),
                    ConsoleField(
                      label: l.consoleActivity,
                      value: stats.lastPlayed == null
                          ? null
                          : l.lastPlayedOn(
                              DisplayFormat.shortDate(stats.lastPlayed!),
                            ),
                      last: true,
                    ),
                  ],
                ),
              ),
              ConsolePanel(
                title: l.accountPrefix,
                padded: true,
                child: _AccountAction(customer: c),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ConsoleHeading(l.bookingHistory, count: history.length),
          if (history.isEmpty)
            EmptyView.inline(icon: Icons.event_busy, title: l.noBookingsYet)
          else
            ConsoleBookingTable(
              bookings: history,
              shopNameOf: (b) => DemoData.shop(b.shopId).name,
              onOpen: (b) => context.push(AppRoutes.superadminBooking(b.id)),
            ),
        ],
      ),
    );
  }
}

class _AccountAction extends StatelessWidget {
  const _AccountAction({required this.customer});

  final UserVO customer;

  @override
  Widget build(BuildContext context) {
    final c = customer;
    final l = context.l10n;
    if (!c.isActive) {
      return PrimaryButton(
        label: l.enableAccount,
        icon: Icons.check_circle_outline,
        expand: true,
        onPressed: () => showPreviewOnly(context, l.enableAccount),
      );
    }
    return DestructiveButton(
      label: l.disableAccount,
      icon: Icons.block,
      expand: true,
      onPressed: () async {
        final ok = await showConfirmDialog(
          context,
          title: l.disableUserTitle(c.name),
          message: l.disableUserMessage,
          confirmLabel: l.disableAction,
          dismissLabel: l.keepActive,
          destructive: true,
        );
        if (ok && context.mounted) showPreviewOnly(context, l.disableAccount);
      },
    );
  }
}
