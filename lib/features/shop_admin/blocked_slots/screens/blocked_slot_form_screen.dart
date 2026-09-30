import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/booking_policy.dart';
import '../../../../core/constants/domain_enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/date_key.dart';
import '../../../../core/utils/display_format.dart';
import '../../../../core/utils/time_range.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/app_tour.dart';
import '../../../shared/widgets/app_tours.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/shop-admin/blocked-slots/new?stadiumId=&courtId=&date=` — SHOP scope:
/// block up to [BookingPolicy.maxSlotsPerBooking] consecutive slots of one
/// court. PREVIEW: pickers use sample venues; saving writes nothing.
class BlockedSlotFormScreen extends StatefulWidget {
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
  State<BlockedSlotFormScreen> createState() => _BlockedSlotFormScreenState();
}

class _BlockedSlotFormScreenState extends State<BlockedSlotFormScreen> {
  final _stadiums = DemoData.stadiumsOf(DemoData.myShopId);
  late String _stadiumId = _stadiums
      .firstWhere((s) => s.id == widget.stadiumId, orElse: () => _stadiums.first)
      .id;
  late String _courtId = DemoData.courtsOf(_stadiumId)
      .firstWhere((c) => c.id == widget.courtId,
          orElse: () => DemoData.courtsOf(_stadiumId).first)
      .id;
  late DateTime _date = DateKey.tryParse(widget.date) ??
      DateTime.now().add(const Duration(days: 1));
  int? _startIndex;
  int _slotCount = 1;
  BlockedSlotReason _reason = BlockedSlotReason.maintenance;
  final _note = TextEditingController();

  List<TimeRange> get _slots {
    final s = DemoData.stadium(_stadiumId);
    return DemoData.court(_courtId)
        .slots(openMinute: s.openMinute, closeMinute: s.closeMinute);
  }

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

  @override
  Widget build(BuildContext context) {
    final slots = _slots;
    final courts = DemoData.courtsOf(_stadiumId);
    final start = _startIndex;
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
            onPressed: start == null
                ? null
                : () {
                    showPreviewOnly(context, l.blockTimeTitle);
                    context.pop();
                  },
          ),
        ),
      ),
      body: PreviewBody(
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
                _courtId = DemoData.courtsOf(id).first.id;
                _startIndex = null;
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            value: _courtId,
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
