import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/booking_vo.dart';
import '../../../../data/vos/user_vo.dart';
import '../../../shared/providers/booking_providers.dart';
import '../../console/widgets/console_kit.dart';
import '../../shared/providers/platform_providers.dart';

/// `/superadmin/customers` — PLATFORM scope: every customer account, with
/// name / phone / email search and an active / disabled filter.
class SuperadminCustomersScreen extends ConsumerWidget {
  const SuperadminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ConsoleAppBar(title: context.l10n.navCustomers),
      body: AsyncValueView<List<UserVO>>(
        value: ref.watch(allCustomersProvider),
        onRetry: () => ref.invalidate(allCustomersProvider),
        data: (all) => _Customers(all: all),
      ),
    );
  }
}

class _Customers extends ConsumerStatefulWidget {
  const _Customers({required this.all});

  final List<UserVO> all;

  @override
  ConsumerState<_Customers> createState() => _CustomersState();
}

/// `null` = all accounts.
typedef _ActiveFilter = bool?;

class _CustomersState extends ConsumerState<_Customers> {
  _ActiveFilter _active;
  String _query = '';

  bool _matches(UserVO c) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final digits = q.replaceAll(' ', '');
    return c.name.toLowerCase().contains(q) ||
        c.email.toLowerCase().contains(q) ||
        (c.phone ?? '').replaceAll(' ', '').contains(digits);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final all = widget.all;
    // Stats from the latest platform bookings (capped list).
    final byCustomer = <String, List<BookingVO>>{};
    for (final b in ref.watch(allBookingsProvider).valueOrNull ?? const []) {
      byCustomer.putIfAbsent(b.customerId, () => []).add(b);
    }
    final active = all.where((c) => c.isActive).length;
    final disabled = all.length - active;
    final shown = all
        .where((c) => _active == null || c.isActive == _active)
        .where(_matches)
        .toList();

    return ConsoleBody(
        header: Column(
          children: [
            ConsoleBand(
              overline: '${l.consolePlatform} · ${l.navCustomers}',
              metrics: [
                ConsoleMetric(value: '${all.length}', label: l.totalLabel),
                ConsoleMetric(
                  value: '$active',
                  label: l.consoleActive,
                  onTap: () => setState(() => _active = true),
                ),
                ConsoleMetric(
                  value: '$disabled',
                  label: l.statusDisabled,
                  onTap: () => setState(() => _active = false),
                ),
              ],
            ),
            ConsoleToolbar(
              search: SearchField(
                hintText: l.searchNameOrPhone,
                onChanged: (v) => setState(() => _query = v),
              ),
              filters: [
                for (final (value, label, count) in <(bool?, String, int)>[
                  (null, l.staffFilterAll, all.length),
                  (true, l.consoleActive, active),
                  (false, l.statusDisabled, disabled),
                ])
                  ConsoleFilterChip(
                    label: label,
                    count: count,
                    selected: _active == value,
                    onSelected: () => setState(() => _active = value),
                  ),
              ],
            ),
          ],
        ),
        children: [
          if (shown.isEmpty)
            EmptyView.inline(
              icon: Icons.person_search_outlined,
              title: l.noCustomersFound,
            )
          else ...[
            ConsoleHeading(l.navCustomers, count: shown.length),
            ConsoleTable(
              columns: [
                ConsoleColumn(l.roleCustomer, flex: 4),
                ConsoleColumn(l.navBookings, flex: 2, compact: false),
                ConsoleColumn(l.consoleActivity, flex: 3, compact: false),
                ConsoleColumn(l.consoleStatus, flex: 3),
              ],
              rows: [
                for (final c in shown)
                  _row(context, c, customerStatsOf(byCustomer[c.id] ?? [])),
              ],
            ),
          ],
        ],
    );
  }

  ConsoleRow _row(BuildContext context, UserVO c, CustomerStats stats) {
    final l = context.l10n;
    final last = stats.lastPlayed;
    return ConsoleRow(
      onTap: () => context.push(AppRoutes.superadminCustomer(c.id)),
      cells: [
        ConsoleCellText(
          c.name,
          strong: true,
          secondary: context.isCompact
              ? l.bookingCount(stats.bookings)
              : (c.phone ?? c.email),
        ),
        Text('${stats.bookings}'),
        ConsoleCellText(
          last == null ? '—' : l.lastPlayedOn(DisplayFormat.shortDate(last)),
        ),
        c.isActive
            ? StatusBadge(
                tone: StatusTone.success,
                icon: Icons.check_circle,
                label: l.consoleActive,
                semanticsPrefix: l.accountPrefix,
                plain: true,
              )
            : StatusBadge(
                tone: StatusTone.danger,
                icon: Icons.block,
                label: l.statusDisabled,
                semanticsPrefix: l.accountPrefix,
                plain: true,
              ),
      ],
    );
  }
}
