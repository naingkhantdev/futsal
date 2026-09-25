import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/booking_policy.dart';
import '../../firebase/firestore/firestore_instance.dart';
import '../../firebase/firestore/stadium_fields.dart';
import '../../firebase/firestore/stadiums_collection.dart';
import '../responses/stadium_response.dart';
import 'stadium_data_agent.dart';

class StadiumDataAgentImpl implements StadiumDataAgent {
  StadiumDataAgentImpl(this._stadiums);

  final StadiumsCollection _stadiums;

  @override
  Stream<List<StadiumResponse>> watchPublishedStadiums({
    String? city,
    String? township,
  }) {
    return _stadiums
        .watchPublished(city: city, township: township)
        .map(_fromQuery);
  }

  @override
  Future<StadiumResponse?> getStadium(String stadiumId) async {
    return _fromSnapshot(await _stadiums.get(stadiumId));
  }

  @override
  Stream<StadiumResponse?> watchStadium(String stadiumId) {
    return _stadiums.watch(stadiumId).map(_fromSnapshot);
  }

  @override
  Stream<List<StadiumResponse>> watchShopStadiums(String shopId) {
    return _stadiums.watchByShop(shopId).map(_byName);
  }

  @override
  Future<List<StadiumResponse>> getShopStadiums(String shopId) async {
    return _byName(await _stadiums.getByShop(shopId));
  }

  @override
  Future<String> createStadium({
    required String shopId,
    required Map<String, Object?> fields,
    required bool isPublished,
  }) async {
    final id = _stadiums.newId();
    await _stadiums.create(id, {
      ...fields,
      StadiumFields.shopId: shopId,
      StadiumFields.timeZone: BookingPolicy.defaultTimeZone,
      StadiumFields.isPublished: isPublished,
      StadiumFields.minHourlyPrice: null,
    });
    return id;
  }

  @override
  Future<void> updateStadium(
    String stadiumId, {
    required Map<String, Object?> fields,
    required bool isPublished,
  }) {
    return _stadiums.update(stadiumId, {
      ...fields,
      StadiumFields.isPublished: isPublished,
    });
  }

  static List<StadiumResponse> _fromQuery(QuerySnapshot<JsonMap> query) => [
        for (final doc in query.docs)
          StadiumResponse.fromFirestore(doc.id, doc.data()),
      ];

  /// Shop queries are unordered (no composite index); sort here.
  static List<StadiumResponse> _byName(QuerySnapshot<JsonMap> query) =>
      _fromQuery(query)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  static StadiumResponse? _fromSnapshot(DocumentSnapshot<JsonMap> snapshot) {
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;
    return StadiumResponse.fromFirestore(snapshot.id, data);
  }
}

final stadiumDataAgentProvider = Provider<StadiumDataAgent>(
  (ref) => StadiumDataAgentImpl(ref.watch(stadiumsCollectionProvider)),
);
