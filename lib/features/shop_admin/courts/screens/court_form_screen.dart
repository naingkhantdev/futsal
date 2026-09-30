import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/constants/venue_policy.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/helpers/form_leave_guard.dart';
import '../../../../core/helpers/form_submit.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../core/theme/theme_context_ext.dart';
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
import '../../../../data/vos/court_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../stadiums/providers/shop_venue_providers.dart';

/// `/shop-admin/stadiums/:stadiumId/courts/new` and `.../:courtId/edit`.
/// SHOP scope: the court's shop is the parent stadium's (firestore.rules).
///
/// The slot length is chosen once, at creation: changing it later could let
/// a new booking skip an existing booking's slot lock (see VenuePolicy).
class CourtFormScreen extends ConsumerWidget {
  const CourtFormScreen({super.key, required this.stadiumId, this.courtId});

  final String stadiumId;

  /// `null` → create.
  final String? courtId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = courtId;
    final l = context.l10n;
    if (id == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.courtNew),
          actions: const [TourHelpButton()],
        ),
        body: _CourtForm(stadiumId: stadiumId, court: null),
      );
    }
    final key = (stadiumId: stadiumId, courtId: id);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.courtEdit),
        actions: const [TourHelpButton()],
      ),
      body: AsyncValueView<CourtVO?>(
        value: ref.watch(adminCourtProvider(key)),
        onRetry: () => ref.invalidate(adminCourtProvider(key)),
        isEmpty: (c) => c == null,
        empty: EmptyView(
          icon: Icons.sports_soccer,
          title: l.courtNotFound,
          message: l.notFoundRemoved,
        ),
        data: (c) => _CourtForm(stadiumId: stadiumId, court: c),
      ),
    );
  }
}

class _CourtForm extends ConsumerStatefulWidget {
  const _CourtForm({required this.stadiumId, required this.court});

  final String stadiumId;

  /// `null` → create.
  final CourtVO? court;

  @override
  ConsumerState<_CourtForm> createState() => _CourtFormState();
}

class _CourtFormState extends ConsumerState<_CourtForm>
    with FormLeaveGuard<_CourtForm> {
  final _formKey = GlobalKey<FormState>();
  // Seeded once; later snapshots don't overwrite in-progress edits.
  late final _name = TextEditingController(text: widget.court?.name);
  late final _price =
      TextEditingController(text: widget.court?.hourlyPrice?.toString());
  late final _capacity =
      TextEditingController(text: widget.court?.capacity?.toString());
  late final _surface =
      TextEditingController(text: widget.court?.surfaceType);
  late final _description =
      TextEditingController(text: widget.court?.description);
  final _nameFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _capacityFocus = FocusNode();

  late int _slotMinutes =
      widget.court?.slotMinutes ?? BookingPolicy.defaultSlotMinutes;
  late bool _isActive = widget.court?.isActive ?? true;
  late final Map<TextEditingController, String> _initialText;
  bool _submitted = false;
  bool _wasDirty = false;

  bool get _isCreate => widget.court == null;

  List<TextEditingController> get _controllers =>
      [_name, _price, _capacity, _surface, _description];

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
    _priceFocus.dispose();
    _capacityFocus.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final dirty = hasChanges;
    if (dirty != _wasDirty) setState(() => _wasDirty = dirty);
  }

  @override
  bool get hasChanges =>
      _controllers.any((c) => c.text.trim() != _initialText[c]) ||
      _isActive != (widget.court?.isActive ?? true) ||
      (_isCreate && _slotMinutes != BookingPolicy.defaultSlotMinutes);

  @override
  String get fallbackRoute => _isCreate
      ? AppRoutes.shopAdminStadium(widget.stadiumId)
      : AppRoutes.shopAdminCourt(widget.stadiumId, widget.court!.id);

  String? _nameError(String? v) => VenueValidators.title(
        v,
        emptyMessage: context.l10n.courtNameRequired,
      );
  static String? _surfaceError(String? v) =>
      VenueValidators.optionalText(v, VenuePolicy.surfaceMaxLength);
  static String? _descriptionError(String? v) =>
      VenueValidators.optionalText(v, VenuePolicy.descriptionMaxLength);

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
        (
          focusNode: _priceFocus,
          validate: () => VenueValidators.hourlyPrice(_price.text),
        ),
        (
          focusNode: _capacityFocus,
          validate: () => VenueValidators.optionalCapacity(_capacity.text),
        ),
      ],
    );
    if (!valid) return;
    final id = await ref.read(courtFormControllerProvider.notifier).save(
          widget.stadiumId,
          courtId: widget.court?.id,
          request: CourtWriteRequest(
            name: _name.text,
            hourlyPrice: VenueValidators.parseInt(_price.text)!,
            capacity: VenueValidators.parseInt(_capacity.text),
            surfaceType: _surface.text,
            description: _description.text,
            slotMinutes: _slotMinutes,
            isActive: _isActive,
          ),
        );
    if (id == null || !mounted) return;
    showAppSnackBar(
      context,
      _isCreate ? context.l10n.courtAdded : context.l10n.courtUpdated,
      tone: SnackTone.success,
    );
    leave();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(courtFormControllerProvider);
    final isLoading = state.isLoading;
    final error = state.appError;
    final autovalidate = _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;
    final muted = context.colors.onSurfaceVariant;
    final l = context.l10n;

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
                TourAnchor(
                  id: TourIds.name,
                  child: AppTextField(
                    label: l.courtNameLabel,
                    controller: _name,
                    focusNode: _nameFocus,
                    prefixIcon: Icons.sports_soccer,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    validator: _nameError,
                    autovalidateMode: autovalidate,
                    readOnly: isLoading,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TourAnchor(
                  id: TourIds.price,
                  child: AppTextField(
                    label: l.pricePerHourLabel(BookingPolicy.currency),
                    controller: _price,
                    focusNode: _priceFocus,
                    prefixIcon: Icons.payments_outlined,
                    helperText: l.priceHelper,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: VenueValidators.hourlyPrice,
                    autovalidateMode: autovalidate,
                    readOnly: isLoading,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(l.slotLengthTitle, style: context.textStyles.titleSmall),
                const SizedBox(height: AppSpacing.md),
                if (_isCreate) ...[
                  TourAnchor(
                    id: TourIds.slotLength,
                    child: SegmentedButton<int>(
                      segments: [
                        for (final m in VenuePolicy.allowedSlotMinutes)
                          ButtonSegment(
                            value: m,
                            label: Text(l.durationMinutes(m)),
                          ),
                      ],
                      selected: {_slotMinutes},
                      onSelectionChanged: isLoading
                          ? null
                          : (s) => setState(() => _slotMinutes = s.first),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.slotLengthNote(BookingPolicy.maxSlotsPerBooking),
                    style:
                        context.textStyles.bodySmall?.copyWith(color: muted),
                  ),
                ] else
                  InlineBanner(
                    tone: StatusTone.neutral,
                    icon: Icons.lock_outline,
                    message: l.slotLengthFixed(_slotMinutes),
                  ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: l.playersOptional,
                  controller: _capacity,
                  focusNode: _capacityFocus,
                  prefixIcon: Icons.groups_outlined,
                  hintText: l.playersHint,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: VenueValidators.optionalCapacity,
                  autovalidateMode: autovalidate,
                  readOnly: isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: l.surfaceOptional,
                  controller: _surface,
                  prefixIcon: Icons.grass,
                  hintText: l.surfaceHint,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  validator: _surfaceError,
                  autovalidateMode: autovalidate,
                  readOnly: isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: l.descriptionOptional,
                  controller: _description,
                  prefixIcon: Icons.notes,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  validator: _descriptionError,
                  autovalidateMode: autovalidate,
                  readOnly: isLoading,
                  minLines: 3,
                  maxLines: 6,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: SwitchListTile(
                    title: Text(l.openForBookings),
                    subtitle: Text(l.courtOpenSubtitle),
                    value: _isActive,
                    onChanged: isLoading
                        ? null
                        : (v) => setState(() => _isActive = v),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (error != null) ...[
                  InlineBanner(message: error.messageIn(l)),
                  const SizedBox(height: AppSpacing.lg),
                ],
                TourAnchor(
                  id: TourIds.primary,
                  child: PrimaryButton(
                    label: _isCreate ? l.addCourt : l.commonSaveChanges,
                    onPressed: _save,
                    isLoading: isLoading,
                    size: AppButtonSize.large,
                    expand: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
