import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/maps_config.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/geo_location.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Stadium form section for the map pin: shows the current point, lets the
/// admin pick it on a map (when the Maps SDK is on) or paste coordinates /
/// a Google Maps link, and remove it. Controlled: the form owns [value].
class StadiumLocationField extends StatefulWidget {
  const StadiumLocationField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final MapPoint? value;
  final ValueChanged<MapPoint?> onChanged;
  final bool enabled;

  @override
  State<StadiumLocationField> createState() => _StadiumLocationFieldState();
}

class _StadiumLocationFieldState extends State<StadiumLocationField> {
  final _paste = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _paste.dispose();
    super.dispose();
  }

  void _apply() {
    final l = context.l10n;
    final input = _paste.text;
    if (input.trim().isEmpty) return;
    final point = GeoLocation.parse(input);
    if (point == null) {
      setState(() {
        _error = GeoLocation.isShortMapsLink(input)
            ? l.locationShortLink
            : l.locationInvalid;
      });
      return;
    }
    setState(() => _error = null);
    _paste.clear();
    FocusScope.of(context).unfocus();
    widget.onChanged(point);
  }

  Future<void> _pickOnMap() async {
    final point = await context.push<MapPoint>(
      AppRoutes.shopAdminPickLocation,
      extra: widget.value,
    );
    if (point != null && mounted) widget.onChanged(point);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    final g = context.gradients;
    final p = widget.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.locationLabel, style: styles.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l.locationNote,
          style: styles.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            leading: Icon(
              p == null ? Icons.location_off_outlined : Icons.place,
              color: p == null ? colors.onSurfaceVariant : g.gold,
              size: AppSizes.iconLg,
            ),
            title: Text(p == null ? l.locationNotSet : GeoLocation.format(p)),
            trailing: p == null
                ? null
                : IconButton(
                    tooltip: l.locationClear,
                    icon: const Icon(Icons.close),
                    onPressed:
                        widget.enabled ? () => widget.onChanged(null) : null,
                  ),
          ),
        ),
        if (MapsConfig.enabled) ...[
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: p == null ? l.locationPickOnMap : l.locationChangeOnMap,
            icon: Icons.map_outlined,
            expand: true,
            onPressed: widget.enabled ? _pickOnMap : null,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l.locationPasteLabel,
          controller: _paste,
          prefixIcon: Icons.link,
          helperText: l.locationPasteHelper,
          errorText: _error,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          readOnly: !widget.enabled,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onFieldSubmitted: (_) => _apply(),
          suffixIcon: IconButton(
            tooltip: l.useThisLocation,
            icon: const Icon(Icons.check),
            onPressed: widget.enabled ? _apply : null,
          ),
        ),
      ],
    );
  }
}
