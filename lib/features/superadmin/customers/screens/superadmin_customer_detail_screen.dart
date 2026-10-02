import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/user_vo.dart';
import '../../../shared/providers/booking_providers.dart';
import '../../console/widgets/console_booking_table.dart';
import '../../console/widgets/console_kit.dart';
import '../../shared/providers/platform_providers.dart';
import '../../shops/providers/shops_providers.dart';

/// `/superadmin/customers/:customerId` — PLATFORM scope: account, activity
/// and bookings at every shop; the superadmin can disable / enable the
/// account (`users/{uid}.isActive`).
class SuperadminCustomerDetailScreen extends ConsumerWidget {
  const SuperadminCustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(customerId));
    final l = context.l10n;
    return Scaffold(
      appBar: ConsoleAppBar(title: l.roleCustomer),
      body: AsyncValueView<UserVO?>(
        value: user,
        onRetry: () => ref.invalidate(userProvider(customerId)),
        isEmpty: (u) => u == null,
        empty: EmptyView(
          icon: Icons.person_search_outlined,
          title: l.customerNotFound,
          message: l.notFoundRemoved,
        ),
        data: (u) => _Customer(customer: u!),
      ),
    );
  }
}

class _Customer extends ConsumerWidget {
  const _Customer({required this.customer});

  final UserVO customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = customer;
    final historyValue = ref.watch(customerBookingsProvider(c.id));
    final history = historyValue.valueOrNull ?? const [];
    final stats = customerStatsOf(history);
    final shopNames = {
      for (final s in ref.watch(allShopsProvider).valueOrNull ?? const [])
        s.id: s.name,
    };
    final l = context.l10n;

    return ConsoleBody(
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
          if (historyValue.hasValue && history.isEmpty)
            EmptyView.inline(icon: Icons.event_busy, title: l.noBookingsYet)
          else
            ConsoleBookingTable(
              bookings: history,
              shopNameOf: (b) => shopNames[b.shopId] ?? '',
              onOpen: (b) => context.push(AppRoutes.superadminBooking(b.id)),
            ),
        ],
    );
  }
}

class _AccountAction extends ConsumerWidget {
  const _AccountAction({required this.customer});

  final UserVO customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = customer;
    final l = context.l10n;
    final busy = ref.watch(userActiveControllerProvider).isLoading;

    Future<void> setActive(bool isActive) async {
      final ok = await ref
          .read(userActiveControllerProvider.notifier)
          .setActive(c.id, isActive: isActive);
      if (!context.mounted) return;
      if (ok) {
        showAppSnackBar(context, l.changesSaved, tone: SnackTone.success);
        return;
      }
      final error = ref.read(userActiveControllerProvider).error;
      final failure =
          error is AppException ? error : UnknownException(cause: error);
      showAppSnackBar(context, failure.messageIn(l), tone: SnackTone.error);
    }

    if (!c.isActive) {
      return PrimaryButton(
        label: l.enableAccount,
        icon: Icons.check_circle_outline,
        expand: true,
        isLoading: busy,
        onPressed: busy ? null : () => setActive(true),
      );
    }
    return DestructiveButton(
      label: l.disableAccount,
      icon: Icons.block,
      expand: true,
      isLoading: busy,
      onPressed: busy
          ? null
          : () async {
              final ok = await showConfirmDialog(
                context,
                title: l.disableUserTitle(c.name),
                message: l.disableUserMessage,
                confirmLabel: l.disableAction,
                dismissLabel: l.keepActive,
                destructive: true,
              );
              if (ok && context.mounted) await setActive(false);
            },
    );
  }
}
