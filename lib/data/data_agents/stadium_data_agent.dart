import '../responses/stadium_response.dart';

/// `stadiums/{stadiumId}` access as typed Responses. Writes are SHOP scope
/// (admins of the stadium's shop, enforced by firestore.rules). Throws raw
/// Firebase errors; repositories map them.
abstract interface class StadiumDataAgent {
  /// CUSTOMER discovery: published stadiums only, by name.
  Stream<List<StadiumResponse>> watchPublishedStadiums({
    String? city,
    String? township,
  });

  /// `null` when the doc does not exist.
  Future<StadiumResponse?> getStadium(String stadiumId);

  Stream<StadiumResponse?> watchStadium(String stadiumId);

  /// SHOP / PLATFORM scope: every stadium of [shopId] (active or not),
  /// by name.
  Stream<List<StadiumResponse>> watchShopStadiums(String shopId);

  Future<List<StadiumResponse>> getShopStadiums(String shopId);

  /// SHOP scope. [fields] are the admin-edited fields; this adds `shopId`,
  /// `timeZone`, [isPublished] and the timestamps. Returns the new id.
  Future<String> createStadium({
    required String shopId,
    required Map<String, Object?> fields,
    required bool isPublished,
  });

  /// SHOP scope. Writes [fields] plus [isPublished] and `updatedAt`.
  Future<void> updateStadium(
    String stadiumId, {
    required Map<String, Object?> fields,
    required bool isPublished,
  });
}
