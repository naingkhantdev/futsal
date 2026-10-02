import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/page_body.dart';
import '../../bookings/providers/shop_bookings_providers.dart';
import '../../stadiums/providers/shop_venue_providers.dart';

/// `/shop-admin/blocked-slots/new?stadiumId=&courtId=&date=` — SHOP scope:
/// block up to [BookingPolicy.maxSlotsPerBooking] consecutive slots of one
/// court. A booked slot in the range makes the whole block fail
/// (firestore.rules + slot lock docs); decline that booking first.
class BlockedSlotFormScreen extends ConsumerWidget {
  const BlockedSlotFormScreen({
    super.key,
    this.stadiumId,
    this.courtId,
    this.date,
  });

  final String? stadiumId;
  final String? courtId;
  final String? date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stadiums = ref.watch(myStadiumsProvider);
    final active =
        stadiums.valueOrNull?.where((s) => s.isActive).toList() ?? const [];
    if (active.isNotEmpty) {
      return _BlockForm(
        stadiums: active,
        initialStadiumId: stadiumId,
        initialCourtId: courtId,
        initialDate: date,
      );
    }
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.blockTimeTitle)),
      body: AsyncValueView<List<StadiumVO>>(
        value: stadiums,
        onRetry: () => ref.invalidate(myStadiumsProvider),
        isEmpty: (_) => true,
        empty: EmptyView(
          icon: Icons.stadium_outlined,
          title: l.stadiumsEmptyTitle,
          message: l.stadiumsEmptyMessage,
        ),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _BlockForm extends ConsumerStatefulWidget {
  const _BlockForm({
    required this.stadiums,
    this.initialStadiumId,
    this.initialCourtId,
    this.initialDate,
  });

  /// Active stadiums of the admin's shop (never empty).
  final List<StadiumVO> stadiums;
  final String? initialStadiumId;
  final String? initialCourtId;
  final String? initialDate;

  @override
  ConsumerState<_BlockForm> createState() => _BlockFormState();
}

class _BlockFormState extends ConsumerState<_BlockForm> {
  List<StadiumVO> get _stadiums => widget.stadiums;
  late String _stadiumId = _stadiums
      .firstWhere(
        (s) => s.id == widget.initialStadiumId,
        orElse: () => _stadiums.first,
      )
      .id;
  late String? _courtId = widget.initialCourtId;
  late DateTime _date = DateKey.tryParse(widget.initialDate) ??
      DateTime.now().add(const Duration(days: 1));
  int? _startIndex;
  int _slotCount = 1;
  BlockedSlotReason _reason = BlockedSlotReason.maintenance;
  final _note = TextEditingController();

  StadiumVO get _stadium => _stadiums.firstWhere(
        (s) => s.id == _stadiumId,
        orElse: () => _stadiums.first,
      );

  List<TimeRange> _slotsOf(CourtVO? court) => court == null
      ? const []
      : court.slots(
          openMinute: _stadium.openMinute,
          closeMinute: _stadium.closeMinute,
        );

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: now,
      lastDate: now.add(const Duration(days: BookingPolicy.maxAdvanceDays)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save(CourtVO court, List<TimeRange> slots, int count) async {
    final start = _startIndex!;
    final note = _note.text.trim();
    final ok = await ref.read(blockedSlotsControllerProvider.notifier).block(
          stadium: _stadium,
          court: court,
          date: DateKey.fromDate(_date),
          startMinute: slots[start].startMinute,
          endMinute: slots[start + count - 1].endMinute,
          reason: _reason,
          note: note.isEmpty ? null : note,
        );
    if (!mounted) return;
    final l = context.l10n;
    if (ok) {
      showAppSnackBar(context, l.changesSaved, tone: SnackTone.success);
      context.pop();
      return;
    }
    final error = ref.read(blockedSlotsControllerProvider).error;
    final failure =
        error is AppException ? error : UnknownException(cause: error);
    showAppSnackBar(context, failure.messageIn(l), tone: SnackTone.error);
  }

  @override
  Widget build(BuildContext context) {
    final courts = ref
            .watch(adminCourtsProvider(_stadiumId))
            .valueOrNull
            ?.where((c) => c.isActive)
            .toList() ??
        const <CourtVO>[];
    final court = courts.where((c) => c.id == _courtId).firstOrNull ??
        courts.firstOrNull;
    final slots = _slotsOf(court);
    final saving = ref.watch(blockedSlotsControllerProvider).isLoading;
    final start = _startIndex != null && _startIndex! < slots.length
        ? _startIndex
        : null;
    final maxCount = start == null
        ? 1
        : (slots.length - start).clamp(1, BookingPolicy.maxSlotsPerBooking);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.blockTimeTitle),
        actions: const [TourHelpButton()],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TourAnchor(
          id: TourIds.primary,
          child: PrimaryButton(
            label: l.blockTimeTitle,
            expand: true,
            isLoading: saving,
            onPressed: start == null || court == null || saving
                ? null
                : () => _save(court, slots, _slotCount.clamp(1, maxCount)),
          ),
        ),
      ),
      body: PageBody(
        width: ContentWidth.form,
        children: [
          TourAnchor(
            id: TourIds.where,
            child: DropdownButtonFormField<String>(
              value: _stadiumId,
              decoration: InputDecoration(labelText: l.stadiumLabel),
              items: [
                for (final s in _stadiums)
                  DropdownMenuItem(value: s.id, child: Text(s.name)),
              ],
              onChanged: (id) => setState(() {
                _stadiumId = id!;
                _courtId = null;
                _startIndex = null;
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            key: ValueKey(_stadiumId),
            value: court?.id,
            decoration: InputDecoration(labelText: l.courtLabel),
            items: [
              for (final c in courts)
                DropdownMenuItem(value: c.id, child: Text(c.name)),
            ],
            onChanged: (id) => setState(() {
              _courtId = id!;
              _startIndex = null;
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l.dateLabel,
                suffixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              child: Text(DisplayFormat.fullDate(DateKey.fromDate(_date))),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<int>(
                  value: start,
                  decoration: InputDecoration(labelText: l.fromLabel),
                  items: [
                    for (final (i, s) in slots.indexed)
                      DropdownMenuItem(
                        value: i,
                        child: Text(formatMinuteOfDay(s.startMinute)),
                      ),
                  ],
                  onChanged: (i) => setState(() {
                    _startIndex = i;
                    _slotCount = 1;
                  }),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<int>(
                  value: _slotCount.clamp(1, maxCount),
                  decoration: InputDecoration(labelText: l.slotsLabel),
                  items: [
                    for (var n = 1; n <= maxCount; n++)
                      DropdownMenuItem(value: n, child: Text('$n')),
                  ],
                  onChanged: start == null
                      ? null
                      : (n) => setState(() => _slotCount = n!),
                ),
              ),
            ],
          ),
          if (start != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              DisplayFormat.timeRange(
                slots[start].startMinute,
                slots[start + _slotCount.clamp(1, maxCount) - 1].endMinute,
              ),
              style: context.textStyles.bodyMedium
                  ?.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<BlockedSlotReason>(
            value: _reason,
            decoration: InputDecoration(labelText: l.reasonFieldLabel),
            items: [
              for (final r in BlockedSlotReason.values)
                DropdownMenuItem(value: r, child: Text(r.labelIn(l))),
            ],
            onChanged: (r) => setState(() => _reason = r!),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _note,
            maxLength: 120,
            decoration: InputDecoration(labelText: l.noteOptional),
          ),
        ],
      ),
    );
  }
}
