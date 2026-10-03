import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/stadium_card.dart';
import '../../../../data/vos/stadium_vo.dart';

/// [StadiumCard] filled from a [StadiumVO]; opens the stadium page.
class StadiumListCard extends StatelessWidget {
  const StadiumListCard({
    super.key,
    required this.stadium,
    this.aspectRatio = 3 / 2,
    this.distanceKm,
  });

  final StadiumVO stadium;

  /// Straight-line distance from the user, shown after the township.
  final double? distanceKm;

  /// 3:2 in vertical lists, 4:3 in horizontal carousels.
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final s = stadium;
    final l = context.l10n;
    final place = [s.township, s.city].whereType<String>().join(', ');
    final location = [
      if (place.isNotEmpty) place,
      if (distanceKm case final km?) l.distanceKm(DisplayFormat.km(km)),
    ].join(' · ');
    final price = s.minHourlyPrice == null
        ? l.priceOnRequest
        : l.priceFromPerHour(Money.formatMmk(s.minHourlyPrice!));
    return StadiumCard(
      name: s.name,
      location: location,
      priceLabel: price,
      imageUrl: s.coverImage,
      aspectRatio: aspectRatio,
      facilities: [for (final f in s.facilities) f.labelIn(l)],
      semanticLabel: '${s.name}, $location, $price',
      onTap: () => context.push(AppRoutes.customerStadium(s.id)),
    );
  }
}
