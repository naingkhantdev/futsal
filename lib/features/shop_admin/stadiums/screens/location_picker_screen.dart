import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/maps_config.dart';
import '../../../../core/helpers/reverse_geocoder.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/geo_location.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../core/widgets/venue_map.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';

/// `/shop-admin/stadiums/pick-location` (and `/superadmin/shops/
/// pick-location`) — UI only: the admin drags the OpenStreetMap until the
/// fixed centre pin sits on the venue, sees the detected township / city,
/// then pops the chosen [MapPoint]. Nothing is saved here; the form saves
/// it (and firestore.rules validate it).
class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({super.key, this.initial});

  /// Current pin, if the stadium already has one.
  final MapPoint? initial;

  @override
  ConsumerState<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

/// Address under the pin: `null` place = not found; [loading] while the
/// lookup for the latest map position runs.
typedef _PinPlace = ({bool loading, PlaceAddress? place});

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  late final ValueNotifier<MapPoint> _center = ValueNotifier(
    widget.initial ??
        (
          latitude: MapsConfig.defaultLatitude,
          longitude: MapsConfig.defaultLongitude,
        ),
  );

  /// City / township / street under the pin, refreshed when the map stops.
  final ValueNotifier<_PinPlace> _place =
      ValueNotifier((loading: true, place: null));
  int _lookupSeq = 0;

  @override
  void initState() {
    super.initState();
    // First lookup once the locale is available.
    WidgetsBinding.instance.addPostFrameCallback((_) => _detect());
  }

  /// Reverse-geocodes the map centre; an older result is dropped when the
  /// map moved again meanwhile.
  Future<void> _detect() async {
    if (!mounted) return;
    final seq = ++_lookupSeq;
    _place.value = (loading: true, place: _place.value.place);
    final found = await ref
        .read(reverseGeocoderProvider)
        .lookup(_center.value, Localizations.localeOf(context).languageCode);
    if (!mounted || seq != _lookupSeq) return;
    _place.value = (loading: false, place: found);
  }

  /// Looks the place up once the map has been still for a moment.
  Timer? _settle;
  static const _settleDelay = Duration(milliseconds: 600);

  void _onMoved(MapPoint p) {
    _center.value = p;
    if (!_place.value.loading) {
      _place.value = (loading: true, place: _place.value.place);
    }
    _settle?.cancel();
    _settle = Timer(_settleDelay, _detect);
  }

  @override
  void dispose() {
    _settle?.cancel();
    _place.dispose();
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detected township / city + street; live as the pin moves.
                  ValueListenableBuilder<_PinPlace>(
                    valueListenable: _place,
                    builder: (context, v, _) => _PlaceText(value: v),
                  ),
                  // Only the coordinates rebuild while the map moves.
                  ValueListenableBuilder<MapPoint>(
                    valueListenable: _center,
                    builder: (context, p, _) => Text(
                      GeoLocation.format(p),
                      style: context.textStyles.bodySmall
                          ?.copyWith(color: context.colors.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
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
            child: VenueMap(
              center: start,
              zoom: widget.initial == null
                  ? MapsConfig.defaultZoom
                  : MapsConfig.venueZoom,
              interactive: true,
              onMoved: _onMoved,
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

/// "Hlaing, Yangon" (bold) over the street line, or a finding / not-found
/// note.
class _PlaceText extends StatelessWidget {
  const _PlaceText({required this.value});

  final _PinPlace value;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final place = value.place;
    final area = [place?.township, place?.city]
        .whereType<String>()
        .where((v) => v.isNotEmpty)
        .join(', ');

    if (value.loading) {
      return Text(
        l.shopLocationFinding,
        style: styles.bodyMedium?.copyWith(color: muted),
      );
    }
    if (place == null) {
      return Text(
        l.pickLocationNoAddress,
        style: styles.bodyMedium?.copyWith(color: muted),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          area.isNotEmpty ? area : (place.address ?? ''),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: styles.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (area.isNotEmpty && place.address != null)
          Text(
            place.address!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styles.bodySmall?.copyWith(color: muted),
          ),
      ],
    );
  }
}
