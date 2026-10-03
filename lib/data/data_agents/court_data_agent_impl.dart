import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/booking_policy.dart';
import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/court_fields.dart';
import '../../firebase/firestore/courts_collection.dart';
import '../responses/court_response.dart';
import '../responses/court_slot_response.dart';
import 'court_data_agent.dart';

class CourtDataAgentImpl implements CourtDataAgent {
  CourtDataAgentImpl(this._courts);

  final CourtsCollection _courts;

  @override
  Stream<List<CourtResponse>> watchCourts(
    String stadiumId, {
    required bool activeOnly,
  }) {
    return _courts.watchCourts(stadiumId, activeOnly: activeOnly).map(
          (query) => [
            for (final doc in query.docs)
              CourtResponse.fromFirestore(
                doc.id,
                doc.data(),
                parentStadiumId: stadiumId,
              ),
          ],
        );
  }

  @override
  Stream<CourtResponse?> watchCourt(String stadiumId, String courtId) {
    return _courts.watchCourt(stadiumId, courtId).map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return CourtResponse.fromFirestore(
        snapshot.id,
        data,
        parentStadiumId: stadiumId,
      );
    });
  }

  @override
  Future<List<CourtResponse>> getAllCourts(String stadiumId) async {
    final query = await _courts.getAll(stadiumId);
    return [
      for (final doc in query.docs)
        CourtResponse.fromFirestore(
          doc.id,
          doc.data(),
          parentStadiumId: stadiumId,
        ),
    ];
  }

  @override
  Future<String> saveCourt(
    String stadiumId, {
    String? courtId,
    required String shopId,
    required Map<String, Object?> fields,
    required int? minHourlyPrice,
    required List<CourtSurface> surfaces,
  }) async {
    final create = courtId == null;
    final id = courtId ?? _courts.newId(stadiumId);
    await _courts.save(
      stadiumId,
      id,
      create: create,
      court: create
          ? {
              ...fields,
              CourtFields.shopId: shopId,
              CourtFields.stadiumId: stadiumId,
              CourtFields.currency: BookingPolicy.currency,
            }
          : fields,
      minHourlyPrice: minHourlyPrice,
      surfaces: [for (final s in surfaces) s.name],
    );
    return id;
  }

  @override
  Stream<List<CourtSlotResponse>> watchCourtSlots(
    String stadiumId,
    String courtId,
    String dateKey,
  ) {
    return _courts.watchSlots(stadiumId, courtId, dateKey).map(
          (query) => [
            for (final doc in query.docs)
              if (CourtSlotResponse.tryFromFirestore(
                doc.id,
                doc.data(),
                stadiumId: stadiumId,
                courtId: courtId,
              )
                  case final CourtSlotResponse slot)
                slot,
          ],
        );
  }
}

final courtDataAgentProvider = Provider<CourtDataAgent>(
  (ref) => CourtDataAgentImpl(ref.watch(courtsCollectionProvider)),
);
