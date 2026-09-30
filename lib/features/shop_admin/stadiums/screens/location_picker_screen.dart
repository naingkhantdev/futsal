import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/maps_config.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_map_style.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/geo_location.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';

/// `/shop-admin/stadiums/pick-location` — SHOP scope, UI only: the admin
/// drags the map until the fixed centre pin sits on the venue, then pops
/// the chosen [MapPoint]. Nothing is saved here; the stadium form saves it
/// (and firestore.rules validate it). Only reachable when
/// [MapsConfig.enabled].
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key, this.initial});

  /// Current pin, if the stadium already has one.
  final MapPoint? initial;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final ValueNotifier<MapPoint> _center = ValueNotifier(
    widget.initial ??
        (
          latitude: MapsConfig.defaultLatitude,
          longitude: MapsConfig.defaultLongitude,
        ),
  );

  @override
  void dispose() {
    _center.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final g = context.gradients;
    final start = _center.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.pickLocationTitle),
        actions: const [TourHelpButton()],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: Row(
          children: [
            Expanded(
              // Only the coordinates rebuild while the map moves.
              child: ValueListenableBuilder<MapPoint>(
                valueListenable: _center,
                builder: (context, p, _) => Text(
                  GeoLocation.format(p),
                  style: context.textStyles.bodyMedium
                      ?.copyWith(color: context.colors.onSurfaceVariant),
                ),
              ),
            ),
            TourAnchor(
              id: TourIds.primary,
              child: PrimaryButton(
                label: l.useThisLocation,
                icon: Icons.check,
                onPressed: () => context.pop(_center.value),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TourAnchor(
            id: TourIds.map,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(start.latitude, start.longitude),
                zoom: widget.initial == null
                    ? MapsConfig.defaultZoom
                    : MapsConfig.venueZoom,
              ),
              style: AppMapStyle.of(Theme.of(context).brightness),
              onCameraMove: (camera) => _center.value = (
                latitude: camera.target.latitude,
                longitude: camera.target.longitude,
              ),
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
            ),
          ),
          // Fixed pin: its tip marks the map centre.
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.mapPin),
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
            ),
          ),
          Positioned(
            top: AppSpacing.lg,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: context.depth.raisedDecoration(
                  borderRadius: AppRadius.mdAll,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    l.pickLocationHint,
                    style: context.textStyles.bodyMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
