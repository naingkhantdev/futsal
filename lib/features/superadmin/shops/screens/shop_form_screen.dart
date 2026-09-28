import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/venue_policy.dart';
import '../../../../core/extensions/async_value_ext.dart';
import '../../../../core/helpers/form_leave_guard.dart';
import '../../../../core/helpers/form_submit.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/inline_banner.dart';
import '../../../../data/requests/venue_write_requests.dart';
import '../../../../data/vos/shop_private_vo.dart';
import '../../../../data/vos/shop_vo.dart';
import '../providers/shops_providers.dart';

typedef _ShopDocs = AsyncValue<({ShopVO? shop, ShopPrivateVO? details})>;

/// `/superadmin/shops/new` and `/superadmin/shops/:shopId/edit`.
/// PLATFORM scope: shop profile + owner contact. Status and listing are
/// changed from the shop detail screen, not here.
class ShopFormScreen extends ConsumerWidget {
  const ShopFormScreen({super.key, this.shopId});

  /// `null` → create.
  final String? shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = shopId;
    final l = context.l10n;
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.shopNew)),
        body: const _ShopForm(shopId: null, shop: null, details: null),
      );
    }
    final shop = ref.watch(shopProvider(id));
    final details = ref.watch(shopPrivateProvider(id));
    // Seed the form only once both docs have loaded.
    final _ShopDocs both = switch ((shop, details)) {
      (AsyncData(value: final s), AsyncData(value: final d)) =>
        AsyncValue.data((shop: s, details: d)),
      (AsyncError(:final error, :final stackTrace), _) ||
      (_, AsyncError(:final error, :final stackTrace)) =>
        AsyncValue.error(error, stackTrace),
      _ => const AsyncValue.loading(),
    };
    return Scaffold(
      appBar: AppBar(title: Text(l.shopEdit)),
      body: AsyncValueView<({ShopVO? shop, ShopPrivateVO? details})>(
        value: both,
        onRetry: () {
          ref.invalidate(shopProvider(id));
          ref.invalidate(shopPrivateProvider(id));
        },
        isEmpty: (v) => v.shop == null,
        empty: EmptyView(
          icon: Icons.storefront_outlined,
          title: l.shopNotFound,
          message: l.notFoundRemoved,
        ),
        data: (v) => _ShopForm(shopId: id, shop: v.shop, details: v.details),
      ),
    );
  }
}

class _ShopForm extends ConsumerStatefulWidget {
  const _ShopForm({
    required this.shopId,
    required this.shop,
    required this.details,
  });

  final String? shopId;
  final ShopVO? shop;
  final ShopPrivateVO? details;

  @override
  ConsumerState<_ShopForm> createState() => _ShopFormState();
}

class _ShopFormState extends ConsumerState<_ShopForm>
    with FormLeaveGuard<_ShopForm> {
  final _formKey = GlobalKey<FormState>();
  // Seeded once; later snapshots don't overwrite in-progress edits.
  late final _name = TextEditingController(text: widget.shop?.name);
  late final _phone = TextEditingController(text: widget.shop?.phone);
  late final _email = TextEditingController(text: widget.shop?.email);
  late final _address = TextEditingController(text: widget.shop?.address);
  late final _township = TextEditingController(text: widget.shop?.township);
  late final _city = TextEditingController(text: widget.shop?.city);
  late final _description =
      TextEditingController(text: widget.shop?.description);
  late final _ownerName =
      TextEditingController(text: widget.details?.ownerName);
  late final _ownerPhone =
      TextEditingController(text: widget.details?.ownerPhone);
  late final Map<TextEditingController, String> _initial;
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _ownerPhoneFocus = FocusNode();
  bool _submitted = false;

  List<TextEditingController> get _fields => [
        _name,
        _phone,
        _email,
        _address,
        _township,
        _city,
        _description,
        _ownerName,
        _ownerPhone,
      ];

  @override
  void initState() {
    super.initState();
    _initial = {for (final c in _fields) c: c.text.trim()};
    for (final c in _fields) {
      c.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    for (final c in _fields) {
      c.dispose();
    }
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _ownerPhoneFocus.dispose();
    super.dispose();
  }

  bool _wasDirty = false;

  void _onChanged() {
    final dirty = hasChanges;
    if (dirty != _wasDirty) setState(() => _wasDirty = dirty);
  }

  @override
  bool get hasChanges => _fields.any((c) => c.text.trim() != _initial[c]);

  @override
  String get fallbackRoute => widget.shopId == null
      ? AppRoutes.superadminShops
      : AppRoutes.superadminShop(widget.shopId!);

  String? _descriptionError(String? v) =>
      VenueValidators.optionalText(v, VenuePolicy.descriptionMaxLength);
  String? _addressError(String? v) =>
      VenueValidators.optionalText(v, VenuePolicy.addressMaxLength);
  String? _placeError(String? v) =>
      VenueValidators.optionalText(v, VenuePolicy.placeMaxLength);
  String? _nameError(String? v) => VenueValidators.title(
        v,
        emptyMessage: context.l10n.shopNameRequired,
      );

  Future<void> _save() async {
    if (widget.shopId != null && !hasChanges) {
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
          focusNode: _phoneFocus,
          validate: () => AppValidators.optionalPhone(_phone.text),
        ),
        (
          focusNode: _emailFocus,
          validate: () => VenueValidators.optionalEmail(_email.text),
        ),
        (
          focusNode: _ownerPhoneFocus,
          validate: () => AppValidators.optionalPhone(_ownerPhone.text),
        ),
      ],
    );
    if (!valid) return;
    final id = await ref.read(shopFormControllerProvider.notifier).save(
          shopId: widget.shopId,
          request: ShopProfileRequest(
            name: _name.text,
            phone: _phone.text,
            email: _email.text,
            address: _address.text,
            township: _township.text,
            city: _city.text,
            description: _description.text,
            ownerName: _ownerName.text,
            ownerPhone: _ownerPhone.text,
          ),
        );
    if (id == null || !mounted) return;
    final creating = widget.shopId == null;
    showAppSnackBar(
      context,
      creating ? context.l10n.shopCreated : context.l10n.shopUpdated,
      tone: SnackTone.success,
    );
    if (creating) {
      // Replace the form with the new shop's detail screen.
      context.pushReplacement(AppRoutes.superadminShop(id));
    } else {
      leave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopFormControllerProvider);
    final isLoading = state.isLoading;
    final error = state.appError;
    final autovalidate = _submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;
    final l = context.l10n;

    Widget field(
      String label,
      TextEditingController controller, {
      IconData? icon,
      FocusNode? focusNode,
      FormFieldValidator<String>? validator,
      TextInputType keyboardType = TextInputType.text,
      TextCapitalization caps = TextCapitalization.words,
      String? helperText,
      int? minLines,
      int? maxLines = 1,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: AppTextField(
          label: label,
          controller: controller,
          focusNode: focusNode,
          prefixIcon: icon,
          helperText: helperText,
          keyboardType: keyboardType,
          textInputAction: maxLines == 1
              ? TextInputAction.next
              : TextInputAction.newline,
          textCapitalization: caps,
          validator: validator,
          autovalidateMode: autovalidate,
          readOnly: isLoading,
          minLines: minLines,
          maxLines: maxLines,
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
                if (widget.shopId == null) ...[
                  Text(
                    l.shopNewNote,
                    style: context.textStyles.bodyMedium
                        ?.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                field(l.shopNameLabel, _name,
                    icon: Icons.storefront_outlined,
                    focusNode: _nameFocus,
                    validator: _nameError),
                field(l.phoneOptionalLabel, _phone,
                    icon: Icons.phone_outlined,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    helperText: l.shopPhoneHelper,
                    validator: AppValidators.optionalPhone),
                field(l.emailOptional, _email,
                    icon: Icons.mail_outline,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    caps: TextCapitalization.none,
                    validator: VenueValidators.optionalEmail),
                field(l.addressOptional, _address,
                    icon: Icons.place_outlined, validator: _addressError),
                field(l.townshipOptional, _township,
                    icon: Icons.map_outlined, validator: _placeError),
                field(l.cityOptional, _city,
                    icon: Icons.location_city_outlined,
                    validator: _placeError),
                field(l.descriptionOptional, _description,
                    icon: Icons.notes,
                    keyboardType: TextInputType.multiline,
                    caps: TextCapitalization.sentences,
                    minLines: 3,
                    maxLines: 6,
                    validator: _descriptionError),
                const SizedBox(height: AppSpacing.sm),
                Text(l.ownerPrivateTitle, style: context.textStyles.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l.ownerPrivateNote,
                  style: context.textStyles.bodySmall
                      ?.copyWith(color: context.colors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.lg),
                field(l.ownerNameOptional, _ownerName,
                    icon: Icons.person_outline, validator: _placeError),
                field(l.ownerPhoneOptional, _ownerPhone,
                    icon: Icons.phone_outlined,
                    focusNode: _ownerPhoneFocus,
                    keyboardType: TextInputType.phone,
                    validator: AppValidators.optionalPhone),
                const SizedBox(height: AppSpacing.sm),
                if (error != null) ...[
                  InlineBanner(message: error.messageIn(l)),
                  const SizedBox(height: AppSpacing.lg),
                ],
                PrimaryButton(
                  label:
                      widget.shopId == null ? l.createShop : l.commonSaveChanges,
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
