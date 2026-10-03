import '../../core/constants/venue_policy.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../../core/utils/date_key.dart';
import '../../core/utils/validators.dart';
import '../data_agents/court_data_agent.dart';
import '../data_agents/stadium_data_agent.dart';
import '../requests/venue_write_requests.dart';
import '../vos/court_availability_vo.dart';
import '../vos/court_vo.dart';
import 'court_repository.dart';
import 'mappers/court_mapper.dart';
import 'mappers/court_slot_mapper.dart';

class CourtRepositoryImpl implements CourtRepository {
  CourtRepositoryImpl({
    required CourtDataAgent courtDataAgent,
    required StadiumDataAgent stadiumDataAgent,
  })  : _courts = courtDataAgent,
        _stadiums = stadiumDataAgent;

  final CourtDataAgent _courts;
  final StadiumDataAgent _stadiums;

  @override
  Stream<List<CourtVO>> watchCourts(
    String stadiumId, {
    bool activeOnly = true,
  }) {
    return mapStreamErrors(
      _courts
          .watchCourts(stadiumId, activeOnly: activeOnly)
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Stream<CourtVO?> watchCourt(String stadiumId, String courtId) {
    return mapStreamErrors(
      _courts
          .watchCourt(stadiumId, courtId)
          .map((response) => response?.toVO()),
    );
  }

  @override
  Stream<CourtAvailabilityVO> watchCourtSlots(
    String stadiumId,
    String courtId,
    String dateKey,
  ) {
    if (!DateKey.isValid(dateKey)) {
      return Stream.error(const InvalidDateException());
    }
    return mapStreamErrors(
      _courts.watchCourtSlots(stadiumId, courtId, dateKey).map(
            (slots) => slots.toAvailability(
              stadiumId: stadiumId,
              courtId: courtId,
              date: dateKey,
            ),
          ),
    );
  }

  @override
  Future<String> createCourt(String stadiumId, CourtWriteRequest request) {
    return guardAppException(() async {
      _check(request);
      final stadium = await _stadiums.getStadium(stadiumId);
      if (stadium == null) throw const NotFoundException();
      final others = await _courts.getAllCourts(stadiumId);
      return _courts.saveCourt(
        stadiumId,
        shopId: stadium.shopId,
        fields: request.toCreateFields(),
        minHourlyPrice: VenuePolicy.minHourlyPrice([
          for (final c in others)
            (isActive: c.isActive, hourlyPrice: c.hourlyPrice),
          (isActive: request.isActive, hourlyPrice: request.hourlyPrice),
        ]),
        surfaces: VenuePolicy.surfacesOf([
          for (final c in others)
            (isActive: c.isActive, surfaceType: c.surfaceType),
          (isActive: request.isActive, surfaceType: request.surfaceType),
        ]),
      );
    });
  }

  @override
  Future<void> updateCourt(
    String stadiumId,
    String courtId,
    CourtWriteRequest request,
  ) {
    return guardAppException(() async {
      // slotMinutes is not written on update, so it isn't checked.
      _check(request, creating: false);
      final courts = await _courts.getAllCourts(stadiumId);
      final current = courts.where((c) => c.id == courtId).firstOrNull;
      if (current == null) throw const NotFoundException();
      await _courts.saveCourt(
        stadiumId,
        courtId: courtId,
        shopId: current.shopId,
        fields: request.toUpdateFields(),
        minHourlyPrice: VenuePolicy.minHourlyPrice([
          for (final c in courts)
            c.id == courtId
                ? (isActive: request.isActive, hourlyPrice: request.hourlyPrice)
                : (isActive: c.isActive, hourlyPrice: c.hourlyPrice),
        ]),
        surfaces: VenuePolicy.surfacesOf([
          for (final c in courts)
            c.id == courtId
                ? (isActive: request.isActive, surfaceType: request.surfaceType)
                : (isActive: c.isActive, surfaceType: c.surfaceType),
        ]),
      );
    });
  }

  /// Mirrors `validCourtShape` (see `VenuePolicy`).
  static void _check(CourtWriteRequest r, {bool creating = true}) {
    final capacity = r.capacity;
    final ok = VenueValidators.title(r.name, emptyMessage: '') == null &&
        VenueValidators.optionalText(
              r.description,
              VenuePolicy.descriptionMaxLength,
            ) ==
            null &&
        VenueValidators.optionalText(
              r.surfaceType,
              VenuePolicy.surfaceMaxLength,
            ) ==
            null &&
        (capacity == null ||
            (capacity >= 1 && capacity <= VenuePolicy.maxCapacity)) &&
        r.hourlyPrice >= 0 &&
        r.hourlyPrice <= VenuePolicy.maxHourlyPrice &&
        (!creating || VenuePolicy.allowedSlotMinutes.contains(r.slotMinutes));
    if (!ok) throw const InvalidVenueDetailsException();
  }
}
