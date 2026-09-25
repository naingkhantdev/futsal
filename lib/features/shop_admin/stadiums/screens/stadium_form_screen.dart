import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/constants/domain_labels.dart';
import '../../../../core/constants/venue_policy.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/helpers/form_leave_guard.dart';
import '../../../../core/helpers/form_submit.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../data/requests/venue_write_requests.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../providers/shop_venue_providers.dart';

/// `/shop-admin/stadiums/new` and `/shop-admin/stadiums/:stadiumId/edit`.
/// SHOP scope: the stadium always belongs to the admin's own shop
/// (firestore.rules check `shopId` against `users/{uid}.shopId`).
class StadiumFormScreen extends ConsumerWidget {
  const StadiumFormScreen({super.key, this.stadiumId});

  /// `null` → create.
  final String? stadiumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = stadiumId;
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('New stadium')),
        body: const _StadiumForm(stadium: null),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Edit stadium')),
      body: AsyncValueView<StadiumVO?>(
        value: ref.watch(adminStadiumProvider(id)),
        onRetry: () => ref.invalidate(adminStadiumProvider(id)),
        isEmpty: (s) => s == null,
        empty: const EmptyView(
          icon: Icons.stadium_outlined,
          title: 'Stadium not found',
          message: 'It may have been removed.',
        ),
        data: (s) => _StadiumForm(stadium: s),
      ),
    );
  }
}

class _StadiumForm extends ConsumerStatefulWidget {
  const _StadiumForm({required this.stadium});

  /// `null` → create.
  final StadiumVO? stadium;

  @override
  ConsumerState<_StadiumForm> createState() => _StadiumFormState();
}

class _StadiumFormState extends ConsumerState<_StadiumForm>
    with FormLeaveGuard<_StadiumForm> {
  static const int _defaultOpen = 8 * 60;
  static const int _defaultClose = 22 * 60;

  /// Closing time can be any half hour (the slot grid only depends on the
  /// opening time, see VenuePolicy).
  static const int _closeStep = 30;

  final _formKey = GlobalKey<FormState>();
  // Seeded once; later snapshots don't overwrite in-progress edits.
  late final _name = TextEditingController(text: widget.stadium?.name);
  late final _address = TextEditingController(text: widget.stadium?.address);
  late final _township =
      TextEditingController(text: widget.stadium?.township);
  late final _city = TextEditingController(text: widget.stadium?.city);
  late final _description =
      TextEditingController(text: widget.stadium?.description);
  final _nameFocus = FocusNode();

  late int _open = _initialOpen;
  late int _close = _initialClose;
  late Set<Facility> _facilities = {...?widget.stadium?.facilities};
  late bool _isActive = widget.stadium?.isActive ?? true;
  late final Map<TextEditingController, String> _initialText;
  bool _submitted = false;

  bool get _isCreate => widget.stadium == null;

  /// Hours saved before this rule existed may not be on the hour: round
  /// down so the form always proposes a value the rules accept.
  int get _initialOpen {
    final open = widget.stadium?.openMinute ?? _defaultOpen;
    return open - open % VenuePolicy.openingHourStep;
  }

  int get _initialClose {
    final close = widget.stadium?.closeMinute ?? _defaultClose;
    return close > _initialOpen ? close : _initialOpen + _closeStep;
  }

  List<TextEditingController> get _controllers =>
      [_name, _address, _township, _city, _description];

  @override
  void initState() {
    super.initState();
    _initialText = {for (final c in _controllers) c: c.text.trim()};
    for (final c in _controllers) {
      c.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _nameFocus.dispose();
    super.dispose();
  }

  bool _wasDirty = false;

  void _onTextChanged() {
    final dirty = hasChanges;
    if (dirty != _wasDirty) setState(() => _wasDirty = dirty);
  }

  @override
  bool get hasChanges {
    final s = widget.stadium;
    return _controllers.any((c) => c.text.trim() != _initialText[c]) ||
        _open != _initialOpen ||
        _close != _initialClose ||
        _isActive != (s?.isActive ?? true) ||
        !_sameFacilities(_facilities, s?.facilities ?? const []);
  }

  static bool _sameFacilities(Set<Facility> a, List<Facility> b) =>
      a.length == b.toSet().length && a.containsAll(b);

  @override
  String get fallbackRoute => _isCreate
      ? AppRoutes.shopAdminStadiums
      : AppRoutes.shopAdminStadium(widget.stadium!.id);

  @override
  String get discardSubject => 'this stadium';

  static String? _nameError(String? v) =>
      VenueValidators.title(v, emptyMessage: 'Enter the stadium name');
  static String? _placeError(String? v) =>
      VenueValidators.optionalText(v, VenuePolicy.placeMaxLength);
  static String? _addressError(String? v) =>
      VenueValidators.optionalText(v, VenuePolicy.addressMaxLength);
  static String? _descriptionError(String? v) =>
      VenueValidators.optionalText(v, VenuePolicy.descriptionMaxLength);

  List<int> get _openOptions => [
        for (var m = 0;
            m < BookingPolicy.minutesPerDay;
            m += VenuePolicy.openingHourStep)
          m,
      ];

  List<int> get _closeOptions => [
        for (var m = _open + _closeStep;
            m <= BookingPolicy.minutesPerDay;
            m += _closeStep)
          m,
      ];

  void _setOpen(int open) {
    setState(() {
      _open = open;
      if (_close <= open) _close = open + _closeStep;
    });
  }

  Future<void> _save() async {
    if (!_isCreate && !hasChanges) {
      FocusScope.of(context).unfocus();
      leave();
      return;
    }
    setState(() => _submitted = true);
    final valid = validateFormForSubmit(
      context,
      formKey: _formKey,
      fields: [
        (focusNode: _nameFocus, validate: () => _nameError(_name.text)),
      ],
    );
    if (!valid) return;
    final id = await ref.read(stadiumFormControllerProvider.notifier).save(
          stadiumId: widget.stadium?.id,
          request: StadiumWriteRequest(
            name: _name.text,
            description: _description.text,
            address: _address.text,
            township: _township.text,
            city: _city.text,
            facilities: Facility.values.where(_facilities.contains).toList(),
            openMinute: _open,
            closeMinute: _close,
            isActive: _isActive,
          ),
        );
    if (id == null || !mounted) return;
    if (_isCreate) {
      showAppSnackBar(
        context,
        'Stadium added. Now add its courts.',
        tone: SnackTone.success,
      );
      context.pushReplacement(AppRoutes.shopAdminStadium(id));
    } else {
      showAppSnackBar(context, 'Stadium updated', tone: SnackTone.success);
      leave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stadiumFormControllerProvider);
    final isLoading = state.isLoading;
    final error = state.appError;
    final autovalidate = _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;
    final muted = context.colors.onSurfaceVariant;

    Widget text(
      String label,
      TextEditingController controller, {
      required IconData icon,
      required FormFieldValidator<String> validator,
      FocusNode? focusNode,
      bool multiline = false,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: AppTextField(
          label: label,
          controller: controller,
          focusNode: focusNode,
          prefixIcon: icon,
          keyboardType:
              multiline ? TextInputType.multiline : TextInputType.text,
          textInputAction:
              multiline ? TextInputAction.newline : TextInputAction.next,
          textCapitalization: multiline
              ? TextCapitalization.sentences
              : TextCapitalization.words,
          validator: validator,
          autovalidateMode: autovalidate,
          readOnly: isLoading,
          minLines: multiline ? 3 : null,
          maxLines: multiline ? 6 : 1,
        ),
      );
    }

    return PopScope(
      canPop: canLeave,
      onPopInvoked: onPopBlocked,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: ContentConstraint(
          width: ContentWidth.form,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                text('Stadium name', _name,
                    icon: Icons.stadium_outlined,
                    focusNode: _nameFocus,
                    validator: _nameError),
                text('Address (optional)', _address,
                    icon: Icons.place_outlined, validator: _addressError),
                text('Township (optional)', _township,
                    icon: Icons.map_outlined, validator: _placeError),
                text('City (optional)', _city,
                    icon: Icons.location_city_outlined,
                    validator: _placeError),
                text('Description (optional)', _description,
                    icon: Icons.notes,
                    multiline: true,
                    validator: _descriptionError),
                const SizedBox(height: AppSpacing.sm),
                Text('Opening hours', style: context.textStyles.titleSmall),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _TimeDropdown(
                        label: 'Opens',
                        value: _open,
                        options: _openOptions,
                        onChanged: isLoading ? null : _setOpen,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _TimeDropdown(
                        label: 'Closes',
                        value: _close,
                        options: _closeOptions,
                        onChanged: isLoading
                            ? null
                            : (v) => setState(() => _close = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Stadiums open on the hour. Changing hours never moves or '
                  'cancels existing bookings.',
                  style: context.textStyles.bodySmall?.copyWith(color: muted),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Facilities', style: context.textStyles.titleSmall),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final f in Facility.values)
                      FilterChip(
                        avatar: Icon(f.icon, size: AppSizes.iconSm),
                        label: Text(f.label),
                        selected: _facilities.contains(f),
                        onSelected: isLoading
                            ? null
                            : (on) => setState(() {
                                  _facilities = on
                                      ? {..._facilities, f}
                                      : ({..._facilities}..remove(f));
                                }),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: SwitchListTile(
                    title: const Text('Open for bookings'),
                    subtitle: const Text(
                      "When off, customers can't see or book this stadium.",
                    ),
                    value: _isActive,
                    onChanged: isLoading
                        ? null
                        : (v) => setState(() => _isActive = v),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (error != null) ...[
                  InlineBanner(message: error.message),
                  const SizedBox(height: AppSpacing.lg),
                ],
                PrimaryButton(
                  label: _isCreate ? 'Add stadium' : 'Save changes',
                  onPressed: _save,
                  isLoading: isLoading,
                  size: AppButtonSize.large,
                  expand: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeDropdown extends StatelessWidget {
  const _TimeDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final int value;
  final List<int> options;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: options.contains(value) ? value : options.first,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.schedule, size: AppSizes.iconMd),
      ),
      items: [
        for (final m in options)
          DropdownMenuItem(value: m, child: Text(formatMinuteOfDay(m))),
      ],
      onChanged: onChanged == null ? null : (v) => onChanged!(v!),
    );
  }
}
