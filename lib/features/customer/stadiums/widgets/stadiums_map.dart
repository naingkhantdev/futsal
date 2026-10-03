import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/maps_config.dart';
import '../../../../core/helpers/maps_launcher.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/geo_location.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/explore_providers.dart';

/// Explore map: one pin per stadium that has a map location, plus the
/// user's position when known. Tapping a pin shows a summary card; the
/// selected pin also shows the venue name, so selection isn't color-only.
class StadiumsMap extends StatefulWidget {
  const StadiumsMap({super.key, required this.hits, this.me});

  final List<ExploreHit> hits;
  final MapPoint? me;

  @override
  State<StadiumsMap> createState() => _StadiumsMapState();
}

class _StadiumsMapState extends State<StadiumsMap> {
  String? _selectedId;

  List<ExploreHit> get _pinned =>
      widget.hits.where((h) => h.stadium.hasLocation).toList();

  /// Fits every pin (and the user) when there are two or more points;
  /// otherwise centres on the one point, or on Yangon.
  MapOptions _options(BuildContext context) {
    final points = [
      for (final h in _pinned)
        LatLng(h.stadium.latitude!, h.stadium.longitude!),
      if (widget.me case final me?) LatLng(me.latitude, me.longitude),
    ];
    final fit = points.length >= 2;
    return MapOptions(
      initialCameraFit: fit
          ? CameraFit.coordinates(
              coordinates: points,
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              maxZoom: MapsConfig.venueZoom,
            )
          : null,
      initialCenter: points.length == 1
          ? points.first
          : const LatLng(MapsConfig.defaultLatitude, MapsConfig.defaultLongitude),
      initialZoom: points.length == 1 ? 14 : MapsConfig.defaultZoom,
      maxZoom: MapsConfig.maxZoom,
      backgroundColor: context.depth.well,
      interactionOptions: const InteractionOptions(
        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
      ),
      onTap: (_, __) => setState(() => _selectedId = null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final g = context.gradients;
    final colors = context.colors;
    final pinned = _pinned;
    final selected =
        pinned.where((h) => h.stadium.id == _selectedId).firstOrNull;
    final unpinned = widget.hits.length - pinned.length;
    final l = context.l10n;

    return Stack(
      children: [
        FlutterMap(
          options: _options(context),
          children: [
            TileLayer(
              urlTemplate: MapsConfig.tileUrl,
              userAgentPackageName: MapsConfig.userAgentPackage,
              maxNativeZoom: MapsConfig.maxZoom.toInt(),
              tileBuilder: dark ? darkModeTileBuilder : null,
            ),
            MarkerLayer(
              markers: [
                if (widget.me case final me?)
                  Marker(
                    point: LatLng(me.latitude, me.longitude),
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    child: Semantics(
                      label: l.mapYouAreHere,
                      child: Icon(
                        Icons.my_location,
                        size: AppSizes.iconLg,
                        color: colors.primary,
                      ),
                    ),
                  ),
                for (final h in pinned)
                  Marker(
                    point: LatLng(h.stadium.latitude!, h.stadium.longitude!),
                    width: AppSizes.mapPin * 4,
                    height: AppSizes.mapPin * 2,
                    alignment: Alignment.topCenter,
                    child: _Pin(
                      name: h.stadium.name,
                      selected: h.stadium.id == _selectedId,
                      color: g.gold,
                      onTap: () =>
                          setState(() => _selectedId = h.stadium.id),
                    ),
                  ),
              ],
            ),
            SimpleAttributionWidget(
              source: const Text('OpenStreetMap contributors'),
              onTap: () =>
                  openInMaps(context, Uri.parse(MapsConfig.copyrightUrl)),
            ),
          ],
        ),
        if (unpinned > 0)
          Positioned(
            top: AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: Center(
              child: Material(
                color: colors.surface,
                shape: const StadiumBorder(),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    l.mapVenuesWithoutPin(unpinned),
                    style: context.textStyles.labelMedium,
                  ),
                ),
              ),
            ),
          ),
        if (selected != null)
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xxl,
            child: _SelectedCard(hit: selected),
          ),
      ],
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({
    required this.name,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: name,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.place,
              size: selected ? AppSizes.mapPin * 1.3 : AppSizes.mapPin,
              color: color,
              shadows: [
                Shadow(color: context.depth.shade, blurRadius: AppSpacing.sm),
              ],
            ),
            if (selected)
              ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                  ),
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.labelSmall,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectedCard extends StatelessWidget {
  const _SelectedCard({required this.hit});

  final ExploreHit hit;

  @override
  Widget build(BuildContext context) {
    final s = hit.stadium;
    final l = context.l10n;
    final muted = context.colors.onSurfaceVariant;
    final details = [
      if (s.township ?? s.city case final place?) place,
      if (hit.distanceKm case final km?) l.distanceKm(DisplayFormat.km(km)),
      s.minHourlyPrice == null
          ? l.priceOnRequest
          : l.priceFromPerHour(Money.formatMmk(s.minHourlyPrice!)),
    ].join(' · ');
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(AppRoutes.customerStadium(s.id)),
      child: ListTile(
        leading: const Icon(Icons.stadium_outlined, size: AppSizes.iconLg),
        title: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(details),
        trailing: Icon(Icons.chevron_right, color: muted),
      ),
    );
  }
}
