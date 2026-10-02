import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/day_strip.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/slot_tile.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../data/vos/booking_draft.dart';
import '../../../../data/vos/court_availability_vo.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../../data/vos/stadium_vo.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/page_body.dart';
import '../../stadiums/providers/customer_venue_providers.dart';
import '../providers/booking_draft_provider.dart';

/// `/customer/stadiums/:stadiumId/book?courtId=&date=` — CUSTOMER scope:
/// pick a court, a day and up to [BookingPolicy.maxSlotsPerBooking]
/// consecutive slots. Availability is live from the slot lock docs; the
/// booking itself is still checked by firestore.rules.
class SlotSelectionScreen extends ConsumerWidget {
  const SlotSelectionScreen({
    super.key,
    required this.stadiumId,
    this.courtId,
    this.date,
  });

  final String stadiumId;
  final String? courtId;
  final String? date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stadium = ref.watch(customerStadiumProvider(stadiumId));
    final courts = ref.watch(customerCourtsProvider(stadiumId));
    final s = stadium.valueOrNull;
    final bookable = courts.valueOrNull?.where((c) => c.hasPrice).toList();
    if (s != null && bookable != null && bookable.isNotEmpty) {
      return _SlotPicker(
        stadium: s,
        courts: bookable,
        initialCourtId: courtId,
        initialDate: date,
      );
    }
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(s?.name ?? l.stadiumLabel)),
      body: AsyncValueView<void>(
        value: switch ((stadium, courts)) {
          (AsyncError(:final error, :final stackTrace), _) ||
          (_, AsyncError(:final error, :final stackTrace)) =>
            AsyncError(error, stackTrace),
          (AsyncData(), AsyncData()) => const AsyncData(null),
          _ => const AsyncLoading(),
        },
        onRetry: () {
          ref.invalidate(customerStadiumProvider(stadiumId));
          ref.invalidate(customerCourtsProvider(stadiumId));
        },
        isEmpty: (_) => true,
        empty: s == null
            ? EmptyView(
                icon: Icons.stadium_outlined,
                title: l.stadiumNotFound,
                message: l.notFoundRemoved,
              )
            : EmptyView(icon: Icons.sports_soccer, title: l.noCourtsYet),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _SlotPicker extends ConsumerStatefulWidget {
  const _SlotPicker({
    required this.stadium,
    required this.courts,
    this.initialCourtId,
    this.initialDate,
  });

  final StadiumVO stadium;

  /// Active, priced courts (never empty).
  final List<CourtVO> courts;
  final String? initialCourtId;
  final String? initialDate;

  @override
  ConsumerState<_SlotPicker> createState() => _SlotPickerState();
}

class _SlotPickerState extends ConsumerState<_SlotPicker> {
  static const int _days = 7;

  StadiumVO get stadium => widget.stadium;
  List<CourtVO> get courts => widget.courts;

  late String _courtId = courts
      .firstWhere(
        (c) => c.id == widget.initialCourtId,
        orElse: () => courts.first,
      )
      .id;

  /// The picked court, read from the live list (falls back to the first
  /// court if it was deactivated meanwhile).
  CourtVO get court =>
      courts.firstWhere((c) => c.id == _courtId, orElse: () => courts.first);

  late String date = DateKey.isValid(widget.initialDate)
      ? widget.initialDate!
      : DateKey.fromDate(DateTime.now());

  /// Selected consecutive slots: start index and count in [_slots].
  int? _first;
  int _count = 0;

  List<TimeRange> get _slots => court.slots(
        openMinute: stadium.openMinute,
        closeMinute: stadium.closeMinute,
      );

  CourtDay get _key => (stadiumId: stadium.id, courtId: court.id, date: date);

  SlotState _stateOf(int i, CourtAvailabilityVO busy) {
    final slot = _slots[i];
    if (_first != null && i >= _first! && i < _first! + _count) {
      return SlotState.selected;
    }
    if (slotHasStarted(date, slot.startMinute)) return SlotState.unavailable;
    return switch (busy.busyKindFor(slot)) {
      BusyKind.blocked => SlotState.blocked,
      BusyKind.booked => SlotState.booked,
      null => SlotState.available,
    };
  }

  void _tap(int i) {
    setState(() {
      final first = _first;
      if (first == null) {
        _first = i;
        _count = 1;
      } else if (i == first + _count &&
          _count < BookingPolicy.maxSlotsPerBooking) {
        _count++; // extend forward
      } else if (i == first - 1 &&
          _count < BookingPolicy.maxSlotsPerBooking) {
        _first = i; // extend backward
        _count++;
      } else if (i >= first && i < first + _count) {
        _first = null; // tap inside the selection clears it
        _count = 0;
      } else {
        _first = i;
        _count = 1;
      }
    });
  }

  void _reset() {
    _first = null;
    _count = 0;
  }

  void _continue() {
    final slots = _slots;
    ref.read(bookingDraftProvider.notifier).set(
          BookingDraft(
            stadium: stadium,
            court: court,
            date: date,
            startMinute: slots[_first!].startMinute,
            endMinute: slots[_first! + _count - 1].endMinute,
          ),
        );
    context.push(AppRoutes.customerBookingReview(stadium.id));
  }

  @override
  Widget build(BuildContext context) {
    final court = this.court;
    final availability = ref.watch(courtAvailabilityProvider(_key));
    final busy = availability.valueOrNull;
    // Someone took a selected slot meanwhile: drop the selection.
    ref.listen(courtAvailabilityProvider(_key), (_, next) {
      final first = _first;
      final value = next.valueOrNull;
      if (first == null || value == null) return;
      final slots = _slots;
      final picked = TimeRange(
        slots[first].startMinute,
        slots[first + _count - 1].endMinute,
      );
      if (!value.isFree(picked)) setState(_reset);
    });
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final slots = _slots;
    final minutes = _count * court.slotMinutes;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(stadium.name),
        actions: const [TourHelpButton()],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: Row(
          children: [
            Expanded(
              child: _first == null
                  ? Text(
                      l.pickStartTime,
                      style: styles.bodyMedium?.copyWith(color: muted),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DisplayFormat.timeRange(
                            slots[_first!].startMinute,
                            slots[_first! + _count - 1].endMinute,
                          ),
                          style: styles.titleMedium,
                        ),
                        Text(
                          '${DisplayFormat.duration(minutes, l)} · '
                          '${Money.formatMmk(court.previewPrice(minutes) ?? 0)}',
                          style: styles.bodySmall?.copyWith(color: muted),
                        ),
                      ],
                    ),
            ),
            TourAnchor(
              id: TourIds.primary,
              child: PrimaryButton(
                label: l.commonContinue,
                onPressed: _first == null ? null : _continue,
              ),
            ),
          ],
        ),
      ),
      body: PageBody(
        children: [
          Text(l.courtLabel, style: styles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          TourAnchor(
            id: TourIds.courts,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final c in courts)
                  ChoiceChip(
                    label: Text(c.name),
                    selected: c.id == court.id,
                    onSelected: (_) => setState(() {
                      _courtId = c.id;
                      _reset();
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l.dayLabel, style: styles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          TourAnchor(
            id: TourIds.dayStrip,
            child: DayStrip(
              days: _days,
              selected: date,
              onSelected: (key) => setState(() {
                date = key;
                _reset();
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.slotRules(
              BookingPolicy.maxSlotsPerBooking,
              court.slotMinutes,
              Money.formatMmk(court.hourlyPrice!),
            ),
            style: styles.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: AppSpacing.md),
          if (availability.hasError && busy == null)
            ErrorView.inline(
              error: availability.error is AppException
                  ? availability.error! as AppException
                  : UnknownException(cause: availability.error),
              onRetry: () => ref.invalidate(courtAvailabilityProvider(_key)),
            )
          else if (busy == null)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: LoadingView(),
            )
          else
            TourAnchor(
            id: TourIds.slots,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: slots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.slotGridColumns,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisExtent: 72,
              ),
              itemBuilder: (_, i) {
                final state = _stateOf(i, busy);
                final label = formatMinuteOfDay(slots[i].startMinute);
                final tappable = state == SlotState.available ||
                    state == SlotState.selected;
                final stateText = switch (state) {
                  SlotState.available => l.slotAvailable,
                  SlotState.selected => l.slotSelected,
                  SlotState.booked => l.slotBooked,
                  SlotState.blocked => l.slotClosed,
                  SlotState.unavailable => l.slotUnavailable,
                };
                return SlotTile(
                  state: state,
                  startLabel: label,
                  semanticLabel: '$label, $stateText',
                  onTap: tappable ? () => _tap(i) : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
