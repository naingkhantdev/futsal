import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/reverse_geocoder.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_tone.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/utils/geo_location.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/inline_banner.dart';

/// Venue location chosen on Google Map only (superadmin shop form, shop
/// admin stadium form). The written address is filled in from the pin by
/// the form ([PinAddressFiller]); [addressLine] shows it. Controlled: the
/// form owns the pin.
///
/// The map is OpenStreetMap (no key / billing), so picking always works.
class MapLocationField extends StatelessWidget {
  const MapLocationField({
    super.key,
    required this.point,
    required this.addressLine,
    required this.onPoint,
    required this.pickerRoute,
    required this.hint,
    this.resolving = false,
    this.addressNotFound = false,
    this.enabled = true,
    this.showTitle = false,
  });

  final MapPoint? point;

  /// "Street, Township, City" from the pin; empty when unknown.
  final String addressLine;
  final ValueChanged<MapPoint?> onPoint;

  /// The role's picker route (push with `extra: MapPoint?`, pops a point).
  final String pickerRoute;

  /// One line under the title, e.g. "Pick the shop on Google Map…".
  final String hint;

  /// Looking up the address for a new pin.
  final bool resolving;

  /// The geocoder found nothing for the pin (it is still saved).
  final bool addressNotFound;
  final bool enabled;

  /// "Location" heading, for forms without a section title of their own.
  final bool showTitle;

  Future<void> _pick(BuildContext context) async {
    final picked = await context.push<MapPoint>(pickerRoute, extra: point);
    if (picked != null) onPoint(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    final p = point;

    final title = [
      if (showTitle) ...[
        Text(l.locationLabel, style: styles.titleSmall),
        const SizedBox(height: AppSpacing.xs),
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...title,
        Text(
          hint,
          style: styles.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.md),
        if (p != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxs),
                child: Icon(
                  Icons.place,
                  color: context.gradients.gold,
                  size: AppSizes.iconLg,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (addressLine.isNotEmpty)
                      Text(
                        addressLine,
                        style: styles.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    Text(
                      GeoLocation.format(p),
                      style: styles.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l.locationClear,
                icon: const Icon(Icons.close),
                onPressed: enabled && !resolving ? () => onPoint(null) : null,
              ),
            ],
          ),
        ..._status(context),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          label: p == null ? l.locationPickOnMap : l.locationChangeOnMap,
          icon: Icons.map_outlined,
          expand: true,
          onPressed: enabled && !resolving ? () => _pick(context) : null,
        ),
      ],
    );
  }

  List<Widget> _status(BuildContext context) {
    final l = context.l10n;
    if (resolving) {
      return [
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const SizedBox.square(
              dimension: AppSizes.iconSm,
              child: CircularProgressIndicator(
                strokeWidth: AppSizes.buttonSpinnerStroke,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(l.shopLocationFinding, style: context.textStyles.bodySmall),
          ],
        ),
      ];
    }
    if (addressNotFound && point != null) {
      return [
        const SizedBox(height: AppSpacing.md),
        InlineBanner(
          tone: StatusTone.warning,
          message: l.shopLocationNoAddress,
        ),
      ];
    }
    return const [];
  }
}

/// Form state for a map-only venue location: a new pin rewrites the
/// stored address / township / city from the phone's geocoder; removing
/// the pin clears them. The form keeps the three text controllers (they
/// are still saved) but shows no inputs for them.
mixin PinAddressFiller<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  TextEditingController get pinAddress;
  TextEditingController get pinTownship;
  TextEditingController get pinCity;

  /// The form's current pin.
  MapPoint? get pinLocation;
  set pinLocation(MapPoint? value);

  /// Called after the pin or the address text changed (dirty tracking).
  void onPinChanged();

  /// Address lookup for the latest pin is running (save waits for it).
  bool pinResolving = false;
  bool pinAddressNotFound = false;

  /// Drops the result of an older lookup when the pin moved again.
  int _pinLookupSeq = 0;

  String get pinAddressLine => [pinAddress.text, pinTownship.text, pinCity.text]
      .map((v) => v.trim())
      .where((v) => v.isNotEmpty)
      .join(', ');

  Future<void> setPin(MapPoint? point) async {
    final seq = ++_pinLookupSeq;
    setState(() {
      pinLocation = point;
      pinAddressNotFound = false;
      pinResolving = point != null;
    });
    if (point == null) {
      pinAddress.clear();
      pinTownship.clear();
      pinCity.clear();
      onPinChanged();
      return;
    }
    final found = await ref
        .read(reverseGeocoderProvider)
        .lookup(point, Localizations.localeOf(context).languageCode);
    if (!mounted || seq != _pinLookupSeq) return;
    pinAddress.text = found?.address ?? '';
    pinTownship.text = found?.township ?? '';
    pinCity.text = found?.city ?? '';
    setState(() {
      pinResolving = false;
      pinAddressNotFound = found == null;
    });
    onPinChanged();
  }
}
