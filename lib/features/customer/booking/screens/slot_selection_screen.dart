import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/day_strip.dart';
import '../../../../core/widgets/slot_tile.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../../data/vos/booking_draft.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../shared/widgets/preview_body.dart';
import '../providers/booking_draft_provider.dart';

/// `/customer/stadiums/:stadiumId/book?courtId=&date=` — CUSTOMER scope:
/// pick a court, a day and up to [BookingPolicy.maxSlotsPerBooking]
/// consecutive slots. PREVIEW: availability from `DemoData` until Phase 8.
class SlotSelectionScreen extends ConsumerStatefulWidget {
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
  ConsumerState<SlotSelectionScreen> createState() =>
      _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends ConsumerState<SlotSelectionScreen> {
  static const int _days = 7;

  late final stadium = DemoData.stadium(widget.stadiumId);
  late final List<CourtVO> courts = DemoData.courtsOf(stadium.id);
  late CourtVO court = courts.firstWhere(
    (c) => c.id == widget.courtId,
    orElse: () => courts.first,
  );
  late String date = DateKey.isValid(widget.date)
      ? widget.date!
      : DateKey.fromDate(DateTime.now());

  /// Selected consecutive slots: start index and count in [_slots].
  int? _first;
  int _count = 0;

  List<TimeRange> get _slots => court.slots(
        openMinute: stadium.openMinute,
        closeMinute: stadium.closeMinute,
      );

  SlotState _stateOf(int i) {
    final slot = _slots[i];
    if (_first != null && i >= _first! && i < _first! + _count) {
      return SlotState.selected;
    }
    // Already started today.
    final now = DateTime.now();
    if (date == DateKey.fromDate(now) &&
        slot.startMinute <= now.hour * 60 + now.minute) {
      return SlotState.unavailable;
    }
    if (DemoData.isBlocked(court.id, date, slot.startMinute, slot.endMinute)) {
      return SlotState.blocked;
    }
    if (DemoData.isBusy(court.id, date, slot.startMinute, slot.endMinute)) {
      return SlotState.booked;
    }
    return SlotState.available;
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
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final slots = _slots;
    final minutes = _count * court.slotMinutes;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(stadium.name)),
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
            PrimaryButton(
              label: l.commonContinue,
              onPressed: _first == null ? null : _continue,
            ),
          ],
        ),
      ),
      body: PreviewBody(
        children: [
          Text(l.courtLabel, style: styles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final c in courts)
                ChoiceChip(
                  label: Text(c.name),
                  selected: c.id == court.id,
                  onSelected: (_) => setState(() {
                    court = c;
                    _reset();
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l.dayLabel, style: styles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          DayStrip(
            days: _days,
            selected: date,
            onSelected: (key) => setState(() {
              date = key;
              _reset();
            }),
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
          GridView.builder(
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
              final state = _stateOf(i);
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
        ],
      ),
    );
  }
}
