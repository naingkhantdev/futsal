import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_visuals.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/vos/shop_vo.dart';
import '../../console/widgets/console_kit.dart';
import '../providers/shops_providers.dart';

/// `/superadmin/shops` (`?tab=onboarding` → starts on shops pending review).
/// PLATFORM scope: every shop on the platform, as a console table with a
/// status filter and name / place search.
class ShopsScreen extends ConsumerStatefulWidget {
  const ShopsScreen({super.key, this.showOnboarding = false});

  final bool showOnboarding;

  @override
  ConsumerState<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends ConsumerState<ShopsScreen> {
  /// `null` = every status.
  late ShopStatus? _status = _initialStatus;
  String _query = '';

  ShopStatus? get _initialStatus =>
      widget.showOnboarding ? ShopStatus.pending : null;

  @override
  void didUpdateWidget(ShopsScreen old) {
    super.didUpdateWidget(old);
    // The dashboard / settings link here with `?tab=onboarding`.
    if (old.showOnboarding != widget.showOnboarding) _status = _initialStatus;
  }

  void _newShop() => context.push(AppRoutes.superadminShopNew);

  bool _matches(ShopVO s) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return [s.name, s.city, s.township, s.phone, s.email]
        .whereType<String>()
        .any((v) => v.toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final shops = ref.watch(allShopsProvider);
    final l = context.l10n;
    return Scaffold(
      appBar: ConsoleAppBar(
        title: l.navShops,
        actions: [
          ConsoleBarAction(
            icon: Icons.add_business_outlined,
            label: l.shopNew,
            onPressed: _newShop,
          ),
        ],
      ),
      body: AsyncValueView<List<ShopVO>>(
        value: shops,
        onRetry: () => ref.invalidate(allShopsProvider),
        loading: const _ShopsSkeleton(),
        isEmpty: (list) => list.isEmpty,
        empty: EmptyView(
          icon: Icons.storefront_outlined,
          title: l.noShopsYet,
          message: l.noShopsMessage,
          actionLabel: l.shopNew,
          onAction: _newShop,
        ),
        data: (all) => _body(context, all),
      ),
    );
  }

  Widget _body(BuildContext context, List<ShopVO> all) {
    final l = context.l10n;
    int count(ShopStatus s) => all.where((x) => x.status == s).length;
    final pending = count(ShopStatus.pending);
    final shown = all
        .where((s) => _status == null || s.status == _status)
        .where(_matches)
        .toList();

    return ConsoleBody(
      header: Column(
        children: [
          ConsoleBand(
            overline: '${l.consolePlatform} · ${l.navShops}',
            metrics: [
              ConsoleMetric(value: '${all.length}', label: l.totalLabel),
              ConsoleMetric(
                value: '${count(ShopStatus.active)}',
                label: ShopStatus.active.labelIn(l),
                onTap: () => setState(() => _status = ShopStatus.active),
              ),
              ConsoleMetric(
                value: '$pending',
                label: l.toReview,
                attention: pending > 0,
                onTap: () => setState(() => _status = ShopStatus.pending),
              ),
              ConsoleMetric(
                value: '${count(ShopStatus.suspended)}',
                label: ShopStatus.suspended.labelIn(l),
                onTap: () => setState(() => _status = ShopStatus.suspended),
              ),
            ],
          ),
          ConsoleToolbar(
            search: SearchField(
              hintText: l.consoleSearchShops,
              onChanged: (v) => setState(() => _query = v),
            ),
            filters: [
              ConsoleFilterChip(
                label: l.staffFilterAll,
                count: all.length,
                selected: _status == null,
                onSelected: () => setState(() => _status = null),
              ),
              for (final s in ShopStatus.values)
                ConsoleFilterChip(
                  label: s.labelIn(l),
                  count: count(s),
                  selected: _status == s,
                  onSelected: () => setState(() => _status = s),
                ),
            ],
          ),
        ],
      ),
      children: [
        if (shown.isEmpty)
          _status == ShopStatus.pending && _query.trim().isEmpty
              ? EmptyView.inline(
                  icon: Icons.inbox_outlined,
                  title: l.nothingToReview,
                  message: l.nothingToReviewMessage,
                )
              : EmptyView.inline(
                  icon: Icons.search_off,
                  title: l.consoleNoMatches,
                  message: l.staffTryAnotherFilter,
                )
        else ...[
          ConsoleHeading(
            _status?.labelIn(l) ?? l.staffFilterAll,
            count: shown.length,
          ),
          ConsoleTable(
            columns: [
              ConsoleColumn(l.shopLabel, flex: 4),
              ConsoleColumn(l.locationLabel, flex: 3, compact: false),
              ConsoleColumn(l.listingPrefix, flex: 2, compact: false),
              ConsoleColumn(l.consoleStatus, flex: 3),
            ],
            rows: [
              for (final s in shown)
                ConsoleRow(
                  onTap: () => context.push(AppRoutes.superadminShop(s.id)),
                  cells: [
                    ConsoleCellText(
                      s.name,
                      strong: true,
                      secondary: context.isCompact ? _place(s) : s.phone,
                    ),
                    ConsoleCellText(_place(s)),
                    StatusBadge.fromVisual(
                      shopListingVisual(isListed: s.isListed),
                      semanticsPrefix: l.listingPrefix,
                      plain: true,
                    ),
                    StatusBadge.fromVisual(
                      s.status.visual,
                      semanticsPrefix: l.shopStatusPrefix,
                      plain: true,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ],
    );
  }

  static String _place(ShopVO s) => [s.township, s.city]
      .whereType<String>()
      .where((v) => v.trim().isNotEmpty)
      .join(', ');
}

class _ShopsSkeleton extends StatelessWidget {
  const _ShopsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      children: [
        for (var i = 0; i < 6; i++)
          const ContentConstraint(
            width: ContentWidth.dashboard,
            child: SkeletonListTile(),
          ),
      ],
    );
  }
}
