import '../../core/constants/domain_enums.dart';
import '../responses/court_response.dart';
import '../responses/court_slot_response.dart';

/// Courts and their slot lock docs as typed Responses. Court writes are
/// SHOP scope (admins of the stadium's shop, enforced by firestore.rules).
/// Throws raw Firebase errors; repositories map them.
abstract interface class CourtDataAgent {
  /// Customers must pass `activeOnly: true` (firestore.rules).
  Stream<List<CourtResponse>> watchCourts(
    String stadiumId, {
    required bool activeOnly,
  });

  /// Emits `null` while the court doc does not exist.
  Stream<CourtResponse?> watchCourt(String stadiumId, String courtId);

  /// SHOP scope: every court of the stadium (active or not).
  Future<List<CourtResponse>> getAllCourts(String stadiumId);

  /// Occupied slots (booked or blocked) of one court on one local date.
  /// Empty while nothing is booked or blocked.
  Stream<List<CourtSlotResponse>> watchCourtSlots(
    String stadiumId,
    String courtId,
    String dateKey,
  );

  /// SHOP scope. Creates the court when [courtId] is null (adding `shopId`,
  /// `stadiumId`, `currency`, timestamps) or updates it, and writes the
  /// stadium's [minHourlyPrice] in the same batch. Returns the court id.
  Future<String> saveCourt(
    String stadiumId, {
    String? courtId,
    required String shopId,
    required Map<String, Object?> fields,
    required int? minHourlyPrice,
    required List<CourtSurface> surfaces,
  });
}
