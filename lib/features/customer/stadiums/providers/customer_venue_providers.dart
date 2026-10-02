import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/local_time.dart';
import '../../../../data/repositories/court_repository.dart';
import '../../../../data/repositories/shop_repository.dart';
import '../../../../data/repositories/stadium_repository.dart';
import '../../../../data/vos/court_availability_vo.dart';
import '../../../../data/vos/court_vo.dart';
import '../../../../data/vos/shop_vo.dart';
import '../../../../data/vos/stadium_vo.dart';

/// CUSTOMER scope: discovery reads. firestore.rules let customers see only
/// published stadiums, active courts and active + listed shops; slot lock
/// docs carry no customer data.

/// Published stadiums, by name.
final publishedStadiumsProvider =
    StreamProvider.autoDispose<List<StadiumVO>>(
  (ref) => ref.watch(stadiumRepositoryProvider).watchPublishedStadiums(),
);

final customerStadiumProvider =
    StreamProvider.autoDispose.family<StadiumVO?, String>(
  (ref, stadiumId) =>
      ref.watch(stadiumRepositoryProvider).watchStadium(stadiumId),
);

/// Active courts of a stadium, by name.
final customerCourtsProvider =
    StreamProvider.autoDispose.family<List<CourtVO>, String>(
  (ref, stadiumId) => ref.watch(courtRepositoryProvider).watchCourts(stadiumId),
);

/// The shop behind a stadium (name, phone, map pin).
final publicShopProvider = StreamProvider.autoDispose.family<ShopVO?, String>(
  (ref, shopId) => ref.watch(shopRepositoryProvider).watchShop(shopId),
);

typedef CourtDay = ({String stadiumId, String courtId, String date});

/// Taken slots (booked / blocked) of one court on one local date. Display
/// only: the rules refuse any booking that touches a taken slot.
final courtAvailabilityProvider =
    StreamProvider.autoDispose.family<CourtAvailabilityVO, CourtDay>(
  (ref, key) => ref
      .watch(courtRepositoryProvider)
      .watchCourtSlots(key.stadiumId, key.courtId, key.date),
);

/// Whether the slot starting at [startMinute] on [date] has already begun.
bool slotHasStarted(String date, int startMinute, {DateTime? now}) {
  final start = LocalTime.instantFor(date, startMinute);
  return start == null || !start.isAfter(now ?? DateTime.now());
}

typedef OpenStart = ({CourtVO court, int startMinute});
typedef StadiumDay = ({StadiumVO stadium, String date});

/// Quick booking on home: the earliest [limit] start times on a day with a
/// free slot on some priced court (one entry per start time, on the first
/// court free then). Loading until every court's availability is in.
final openStartsProvider =
    Provider.autoDispose.family<AsyncValue<List<OpenStart>>, StadiumDay>(
  (ref, key) {
    const limit = 3;
    final s = key.stadium;
    final courtsValue = ref.watch(customerCourtsProvider(s.id));
    final courts = courtsValue.valueOrNull;
    if (courts == null) {
      return courtsValue.hasError
          ? AsyncError(courtsValue.error!, courtsValue.stackTrace!)
          : const AsyncLoading();
    }

    final byStart = <int, CourtVO>{};
    for (final c in courts.where((c) => c.hasPrice)) {
      final busyValue = ref.watch(
        courtAvailabilityProvider(
          (stadiumId: s.id, courtId: c.id, date: key.date),
        ),
      );
      final busy = busyValue.valueOrNull;
      if (busy == null) {
        return busyValue.hasError
            ? AsyncError(busyValue.error!, busyValue.stackTrace!)
            : const AsyncLoading();
      }
      final slots =
          c.slots(openMinute: s.openMinute, closeMinute: s.closeMinute);
      for (final slot in slots) {
        if (slotHasStarted(key.date, slot.startMinute)) continue;
        if (!busy.isFree(slot)) continue;
        byStart.putIfAbsent(slot.startMinute, () => c);
      }
    }
    final starts = byStart.keys.toList()..sort();
    return AsyncData([
      for (final m in starts.take(limit)) (court: byStart[m]!, startMinute: m),
    ]);
  },
);
