import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../data/vos/shop_vo.dart';
import '../providers/shop_venue_providers.dart';

/// Explains why customers can't see the shop's stadiums yet (pending
/// review, suspended, unlisted…). Renders nothing while the shop is live
/// or its status is still loading.
class ShopVisibilityBanner extends ConsumerWidget {
  const ShopVisibilityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shop = ref.watch(myShopProvider).valueOrNull;
    final message = shop == null ? null : _message(shop, context.l10n);
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ContentConstraint(
        child: InlineBanner(
          tone: shop!.status == ShopStatus.suspended
              ? StatusTone.danger
              : StatusTone.info,
          icon: Icons.visibility_off_outlined,
          message: message,
        ),
      ),
    );
  }

  static String? _message(ShopVO shop, AppLocalizations l) =>
      switch (shop.status) {
        ShopStatus.active when shop.isListed => null,
        ShopStatus.active => l.visibilityUnlisted,
        ShopStatus.pending => l.visibilityPending,
        ShopStatus.suspended => l.visibilitySuspended,
        ShopStatus.rejected || ShopStatus.inactive => l.visibilityInactive,
      };
}
