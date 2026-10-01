import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../../data/vos/user_vo.dart';
import '../../console/widgets/console_kit.dart';

/// `/superadmin/customers` — PLATFORM scope: every customer account, with
/// name / phone / email search and an active / disabled filter.
/// PREVIEW: sample data.
class SuperadminCustomersScreen extends StatefulWidget {
  const SuperadminCustomersScreen({super.key});

  @override
  State<SuperadminCustomersScreen> createState() =>
      _SuperadminCustomersScreenState();
}

/// `null` = all accounts.
typedef _ActiveFilter = bool?;

class _SuperadminCustomersScreenState extends State<SuperadminCustomersScreen> {
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
    final all = DemoData.customersOf(null);
    final active = all.where((c) => c.isActive).length;
    final disabled = all.length - active;
    final shown = all
        .where((c) => _active == null || c.isActive == _active)
        .where(_matches)
        .toList();

    return Scaffold(
      appBar: ConsoleAppBar(title: l.navCustomers),
      body: ConsoleBody(
        demo: true,
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
                for (final c in shown) _row(context, c),
              ],
            ),
          ],
        ],
      ),
    );
  }

  ConsoleRow _row(BuildContext context, UserVO c) {
    final l = context.l10n;
    final stats = DemoData.customerStats(c.id);
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
