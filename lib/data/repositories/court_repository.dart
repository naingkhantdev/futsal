import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_agents/court_data_agent_impl.dart';
import '../data_agents/stadium_data_agent_impl.dart';
import '../requests/venue_write_requests.dart';
import '../vos/court_availability_vo.dart';
import '../vos/court_vo.dart';
import 'court_repository_impl.dart';

/// Courts and availability. Every method throws / emits only
/// `AppException`.
abstract interface class CourtRepository {
  /// Courts of a stadium by name. Customers must use `activeOnly: true`
  /// (the default); only admins of the owning shop and the superadmin may
  /// list inactive courts.
  Stream<List<CourtVO>> watchCourts(String stadiumId, {bool activeOnly = true});

  /// Emits `null` while the court does not exist.
  Stream<CourtVO?> watchCourt(String stadiumId, String courtId);

  /// Occupied slots of one court on one stadium-local date (`yyyy-MM-dd`),
  /// from the slot lock docs. Emits an empty [CourtAvailabilityVO] while
  /// nothing is booked/blocked, and `InvalidDateException` for a malformed
  /// [dateKey].
  ///
  /// Display only: firestore.rules refuse any booking touching a taken slot.
  Stream<CourtAvailabilityVO> watchCourtSlots(
    String stadiumId,
    String courtId,
    String dateKey,
  );

  /// SHOP scope: a court in [stadiumId] (the stadium's shop must be the
  /// admin's). Also refreshes the stadium's display-only `minHourlyPrice`.
  /// Returns the new court id.
  Future<String> createCourt(String stadiumId, CourtWriteRequest request);

  /// SHOP scope. `slotMinutes` is fixed at creation and not written.
  Future<void> updateCourt(
    String stadiumId,
    String courtId,
    CourtWriteRequest request,
  );
}

final courtRepositoryProvider = Provider<CourtRepository>(
  (ref) => CourtRepositoryImpl(
    courtDataAgent: ref.watch(courtDataAgentProvider),
    stadiumDataAgent: ref.watch(stadiumDataAgentProvider),
  ),
);
