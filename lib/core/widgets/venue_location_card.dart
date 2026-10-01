import 'package:flutter/material.dart';

import '../helpers/maps_launcher.dart';
import '../l10n/l10n.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import '../utils/geo_location.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'venue_map.dart';

/// Where a venue is: a still OpenStreetMap preview with a gold pin (tap to
/// open Google Maps), the address, and "Directions". Without a [point] but
/// with an [address], offers a Google Maps search for the address instead.
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
                    VenueMap(center: p, pin: p),
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
