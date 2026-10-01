import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../constants/maps_config.dart';
import '../helpers/maps_launcher.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import '../utils/geo_location.dart';

/// OpenStreetMap view used for every in-app map (venue preview, pin
/// picker). [interactive] off = a still picture that ignores gestures, so
/// it sits inside scrolling pages. [pin] draws the gold venue marker;
/// pickers leave it `null` and overlay their own fixed centre pin.
class VenueMap extends StatelessWidget {
  const VenueMap({
    super.key,
    required this.center,
    this.zoom = MapsConfig.venueZoom,
    this.interactive = false,
    this.pin,
    this.onMoved,
  });

  final MapPoint center;
  final double zoom;
  final bool interactive;
  final MapPoint? pin;

  /// New map centre while the user pans / zooms (interactive maps only).
  final ValueChanged<MapPoint>? onMoved;

  @override
  Widget build(BuildContext context) {
    final g = context.gradients;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final p = pin;

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(center.latitude, center.longitude),
        initialZoom: zoom,
        maxZoom: MapsConfig.maxZoom,
        backgroundColor: context.depth.well,
        interactionOptions: InteractionOptions(
          flags: interactive
              ? InteractiveFlag.all & ~InteractiveFlag.rotate
              : InteractiveFlag.none,
        ),
        onPositionChanged: onMoved == null
            ? null
            : (camera, _) => onMoved!((
                  latitude: camera.center.latitude,
                  longitude: camera.center.longitude,
                )),
      ),
      children: [
        TileLayer(
          urlTemplate: MapsConfig.tileUrl,
          userAgentPackageName: MapsConfig.userAgentPackage,
          maxNativeZoom: MapsConfig.maxZoom.toInt(),
          // Navy-friendly tiles in dark mode.
          tileBuilder: dark ? darkModeTileBuilder : null,
        ),
        if (p != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(p.latitude, p.longitude),
                width: AppSizes.mapPin,
                height: AppSizes.mapPin,
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.place,
                  size: AppSizes.mapPin,
                  color: g.gold,
                  shadows: [
                    Shadow(
                      color: context.depth.shade,
                      blurRadius: AppSpacing.sm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        // Required credit (OSM tile policy); tap opens the licence page.
        SimpleAttributionWidget(
          source: const Text('OpenStreetMap contributors'),
          onTap: () => openInMaps(context, Uri.parse(MapsConfig.copyrightUrl)),
        ),
      ],
    );
  }
}
