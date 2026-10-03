import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/helpers/device_location.dart';
import '../../../../core/utils/geo_location.dart';
import '../../../../data/vos/stadium_vo.dart';
import 'customer_venue_providers.dart';

/// CUSTOMER scope: Explore search, filters, sort and "near me". Everything
/// here is computed on the device from reads the rules already allow
/// (published stadiums, active courts, slot lock docs). Nothing is written.

enum ExploreSort { name, price, distance }

/// Explore filter state. `date` + `startMinute` together mean "has a free
/// slot starting then"; either alone is ignored.
@immutable
class ExploreFilter {
  const ExploreFilter({
    this.query = '',
    this.facilities = const {},
    this.surfaces = const {},
    this.maxPrice,
    this.date,
    this.startMinute,
    this.sort = ExploreSort.name,
  });

  final String query;
  final Set<Facility> facilities;
  final Set<CourtSurface> surfaces;

  /// Int MMK per hour; compares with the stadium's cheapest court.
  final int? maxPrice;

  /// `yyyy-MM-dd`, stadium local.
  final String? date;
  final int? startMinute;
  final ExploreSort sort;

  /// Price choices offered in the filter sheet (MMK / hour).
  static const List<int> priceSteps = [15000, 20000, 30000, 40000];

  /// Start times offered for "free at" (whole hours; every court grid has
  /// a slot on the hour because stadiums open on the hour).
  static final List<int> startMinuteOptions = List.unmodifiable([
    for (var h = 6; h <= 23; h++) h * 60,
  ]);

  bool get hasTime => date != null && startMinute != null;

  /// Filters set in the sheet (shown as a count on the Filters button).
  int get activeCount =>
      facilities.length +
      surfaces.length +
      (maxPrice == null ? 0 : 1) +
      (hasTime ? 1 : 0);

  ExploreFilter copyWith({
    String? query,
    Set<Facility>? facilities,
    Set<CourtSurface>? surfaces,
    ValueGetter<int?>? maxPrice,
    ValueGetter<String?>? date,
    ValueGetter<int?>? startMinute,
    ExploreSort? sort,
  }) =>
      ExploreFilter(
        query: query ?? this.query,
        facilities: facilities ?? this.facilities,
        surfaces: surfaces ?? this.surfaces,
        maxPrice: maxPrice == null ? this.maxPrice : maxPrice(),
        date: date == null ? this.date : date(),
        startMinute: startMinute == null ? this.startMinute : startMinute(),
        sort: sort ?? this.sort,
      );

  /// Sheet filters cleared; search text and sort kept.
  ExploreFilter cleared() => ExploreFilter(query: query, sort: sort);

  bool matches(StadiumVO s) {
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      final text =
          '${s.name} ${s.township ?? ''} ${s.city ?? ''}'.toLowerCase();
      if (!text.contains(q)) return false;
    }
    if (!facilities.every(s.facilities.contains)) return false;
    if (surfaces.isNotEmpty && !surfaces.any(s.surfaces.contains)) {
      return false;
    }
    final max = maxPrice;
    if (max != null) {
      final from = s.minHourlyPrice;
      if (from == null || from > max) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) =>
      other is ExploreFilter &&
      other.query == query &&
      setEquals(other.facilities, facilities) &&
      setEquals(other.surfaces, surfaces) &&
      other.maxPrice == maxPrice &&
      other.date == date &&
      other.startMinute == startMinute &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(
        query,
        Object.hashAllUnordered(facilities),
        Object.hashAllUnordered(surfaces),
        maxPrice,
        date,
        startMinute,
        sort,
      );
}

class ExploreFilterNotifier extends AutoDisposeNotifier<ExploreFilter> {
  @override
  ExploreFilter build() => const ExploreFilter();

  void update(ExploreFilter Function(ExploreFilter) change) =>
      state = change(state);
}

final exploreFilterProvider =
    NotifierProvider.autoDispose<ExploreFilterNotifier, ExploreFilter>(
  ExploreFilterNotifier.new,
);

/// The phone's approximate position, `null` until the user asks for
/// "near me". Errors are `LocationUnavailableException`.
class MyLocationNotifier extends AutoDisposeAsyncNotifier<MapPoint?> {
  @override
  FutureOr<MapPoint?> build() => null;

  /// Returns whether a location is now known.
  Future<bool> locate() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(deviceLocationProvider).current(),
    );
    return state.valueOrNull != null;
  }
}

final myLocationProvider =
    AsyncNotifierProvider.autoDispose<MyLocationNotifier, MapPoint?>(
  MyLocationNotifier.new,
);

typedef FreeAtKey = ({StadiumVO stadium, String date, int startMinute});

/// Whether some priced, active court of the stadium has a free slot
/// starting at `startMinute` on `date`. Display only: the booking rules
/// re-check every slot.
final stadiumFreeAtProvider =
    Provider.autoDispose.family<AsyncValue<bool>, FreeAtKey>((ref, key) {
  final s = key.stadium;
  if (slotHasStarted(key.date, key.startMinute)) return const AsyncData(false);
  final courtsValue = ref.watch(customerCourtsProvider(s.id));
  final courts = courtsValue.valueOrNull;
  if (courts == null) {
    return courtsValue.hasError
        ? AsyncError(courtsValue.error!, courtsValue.stackTrace!)
        : const AsyncLoading();
  }
  var pending = false;
  for (final c in courts.where((c) => c.hasPrice)) {
    final slot = c
        .slots(openMinute: s.openMinute, closeMinute: s.closeMinute)
        .where((r) => r.startMinute == key.startMinute)
        .firstOrNull;
    if (slot == null) continue;
    final busyValue = ref.watch(
      courtAvailabilityProvider(
        (stadiumId: s.id, courtId: c.id, date: key.date),
      ),
    );
    final busy = busyValue.valueOrNull;
    if (busy == null) {
      if (busyValue.hasError) {
        return AsyncError(busyValue.error!, busyValue.stackTrace!);
      }
      pending = true;
      continue;
    }
    if (busy.isFree(slot)) return const AsyncData(true);
  }
  return pending ? const AsyncLoading() : const AsyncData(false);
});

typedef ExploreHit = ({StadiumVO stadium, double? distanceKm});

/// Published stadiums after [exploreFilterProvider], sorted. Loading while
/// a "free at" check is still reading slots.
final exploreResultsProvider =
    Provider.autoDispose<AsyncValue<List<ExploreHit>>>((ref) {
  final f = ref.watch(exploreFilterProvider);
  final me = ref.watch(myLocationProvider).valueOrNull;
  final allValue = ref.watch(publishedStadiumsProvider);
  final all = allValue.valueOrNull;
  if (all == null) {
    return allValue.hasError
        ? AsyncError(allValue.error!, allValue.stackTrace!)
        : const AsyncLoading();
  }

  var matched = all.where(f.matches).toList();
  if (f.hasTime) {
    final free = <StadiumVO>[];
    var pending = false;
    for (final s in matched) {
      final v = ref.watch(stadiumFreeAtProvider(
        (stadium: s, date: f.date!, startMinute: f.startMinute!),
      ));
      if (v.hasError) return AsyncError(v.error!, v.stackTrace!);
      if (v.isLoading) pending = true;
      if (v.valueOrNull == true) free.add(s);
    }
    if (pending) return const AsyncLoading();
    matched = free;
  }

  final hits = [
    for (final s in matched)
      (
        stadium: s,
        distanceKm: me != null && s.hasLocation
            ? GeoLocation.distanceKm(
                me,
                (latitude: s.latitude!, longitude: s.longitude!),
              )
            : null,
      ),
  ];
  int byName(ExploreHit a, ExploreHit b) => a.stadium.name
      .toLowerCase()
      .compareTo(b.stadium.name.toLowerCase());
  // Unknown values (no price / no pin) sort last, then by name.
  int nullsLast<T extends num>(T? a, T? b) => a == null
      ? (b == null ? 0 : 1)
      : (b == null ? -1 : a.compareTo(b));
  hits.sort(switch (f.sort) {
    ExploreSort.name => byName,
    ExploreSort.price => (a, b) {
        final c = nullsLast(a.stadium.minHourlyPrice, b.stadium.minHourlyPrice);
        return c != 0 ? c : byName(a, b);
      },
    ExploreSort.distance => (a, b) {
        final c = nullsLast(a.distanceKm, b.distanceKm);
        return c != 0 ? c : byName(a, b);
      },
  });
  return AsyncData(hits);
});
