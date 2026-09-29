import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/maps_config.dart';
import '../helpers/maps_launcher.dart';
import '../l10n/l10n.dart';
import '../theme/app_map_style.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import '../utils/geo_location.dart';
import 'app_button.dart';
import 'app_card.dart';

/// Where a venue is: a static map with a gold pin (tap to open Google
/// Maps), the address, and "Directions". Without a [point] but with an
/// [address], offers a Google Maps search for the address instead. When
/// the Maps SDK is off ([MapsConfig.enabled]) the map area becomes a
/// map-free pin banner; directions still work.
class VenueLocationCard extends StatelessWidget {
  const VenueLocationCard({
    super.key,
    required this.name,
    this.point,
    this.address,
  });

  /// Venue name (marker title, screen-reader label).
  final String name;
  final MapPoint? point;
  final String? address;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    final p = point;
    final text = (address ?? '').trim();

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (p != null)
            Semantics(
              button: true,
              label: l.mapPinSemantics(name),
              onTap: () => openInMaps(context, GeoLocation.viewUri(p)),
              excludeSemantics: true,
              child: SizedBox(
                height: AppSizes.mapPreviewHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (MapsConfig.enabled)
                      _StaticMap(point: p, name: name)
                    else
                      _MapFallback(point: p),
                    // The map ignores gestures; the whole area opens Maps.
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () =>
                            openInMaps(context, GeoLocation.viewUri(p)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (text.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: AppSizes.iconMd,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(text, style: styles.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (p != null)
                  SecondaryButton(
                    label: l.mapDirections,
                    icon: Icons.directions_outlined,
                    expand: true,
                    onPressed: () =>
                        openInMaps(context, GeoLocation.directionsUri(p)),
                  )
                else if (text.isNotEmpty)
                  SecondaryButton(
                    label: l.mapOpenInGoogleMaps,
                    icon: Icons.map_outlined,
                    expand: true,
                    onPressed: () =>
                        openInMaps(context, GeoLocation.searchUri(text)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Non-interactive Google map centred on the venue. Lite mode on Android
/// (a static bitmap: cheap, and smooth inside a scrolling page).
class _StaticMap extends StatelessWidget {
  const _StaticMap({required this.point, required this.name});

  final MapPoint point;
  final String name;

  @override
  Widget build(BuildContext context) {
    final target = LatLng(point.latitude, point.longitude);
    return IgnorePointer(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: target,
          zoom: MapsConfig.venueZoom,
        ),
        style: AppMapStyle.of(Theme.of(context).brightness),
        liteModeEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('venue'),
            position: target,
            infoWindow: InfoWindow(title: name),
            icon: BitmapDescriptor.defaultMarkerWithHue(MapsConfig.markerHue),
          ),
        },
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
      ),
    );
  }
}

/// Map-free stand-in: navy panel, gold pin, coordinates.
class _MapFallback extends StatelessWidget {
  const _MapFallback({required this.point});

  final MapPoint point;

  @override
  Widget build(BuildContext context) {
    final g = context.gradients;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: g.pitch),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.minTouchTarget,
            height: AppSizes.minTouchTarget,
            decoration: BoxDecoration(
              color: g.onHero.withOpacity(0.08),
              borderRadius: AppRadius.fullAll,
            ),
            child: Icon(Icons.place, color: g.gold, size: AppSizes.iconLg),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            GeoLocation.format(point),
            style: context.textStyles.labelMedium
                ?.copyWith(color: g.onHeroMuted),
          ),
        ],
      ),
    );
  }
}
