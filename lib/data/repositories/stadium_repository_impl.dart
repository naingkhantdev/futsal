import '../../core/constants/cancellation_policy.dart';
import '../../core/constants/venue_policy.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../../core/utils/time_range.dart';
import '../../core/utils/validators.dart';
import '../data_agents/shop_data_agent.dart';
import '../data_agents/stadium_data_agent.dart';
import '../requests/venue_write_requests.dart';
import '../vos/stadium_vo.dart';
import 'mappers/stadium_mapper.dart';
import 'stadium_repository.dart';

class StadiumRepositoryImpl implements StadiumRepository {
  StadiumRepositoryImpl({
    required StadiumDataAgent stadiumDataAgent,
    required ShopDataAgent shopDataAgent,
  })  : _stadiums = stadiumDataAgent,
        _shops = shopDataAgent;

  final StadiumDataAgent _stadiums;
  final ShopDataAgent _shops;

  @override
  Stream<List<StadiumVO>> watchPublishedStadiums({
    String? city,
    String? township,
  }) {
    return mapStreamErrors(
      _stadiums
          .watchPublishedStadiums(
            city: _filter(city),
            township: _filter(township),
          )
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Future<StadiumVO?> getStadium(String stadiumId) {
    return guardAppException(
      () async => (await _stadiums.getStadium(stadiumId))?.toVO(),
    );
  }

  @override
  Stream<StadiumVO?> watchStadium(String stadiumId) {
    return mapStreamErrors(
      _stadiums.watchStadium(stadiumId).map((response) => response?.toVO()),
    );
  }

  @override
  Stream<List<StadiumVO>> watchShopStadiums(String shopId) {
    return mapStreamErrors(
      _stadiums
          .watchShopStadiums(shopId)
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Future<String> createStadium(String shopId, StadiumWriteRequest request) {
    return guardAppException(() async {
      _check(request);
      return _stadiums.createStadium(
        shopId: shopId,
        fields: request.toFirestore(),
        isPublished: await _isPublished(shopId, request.isActive),
      );
    });
  }

  @override
  Future<void> updateStadium(String stadiumId, StadiumWriteRequest request) {
    return guardAppException(() async {
      _check(request);
      final current = await _stadiums.getStadium(stadiumId);
      if (current == null) throw const NotFoundException();
      await _stadiums.updateStadium(
        stadiumId,
        fields: request.toFirestore(),
        isPublished: await _isPublished(current.shopId, request.isActive),
      );
    });
  }

  /// Mirrors firestore.rules `stadiumPublished` (the rules check it).
  Future<bool> _isPublished(String shopId, bool stadiumIsActive) async {
    final shop = await _shops.getShop(shopId);
    if (shop == null) return false;
    return VenuePolicy.isPublished(
      shopStatus: shop.status,
      shopIsListed: shop.isListed,
      stadiumIsActive: stadiumIsActive,
    );
  }

  /// Mirrors `validStadiumShape`; see `VenuePolicy` for why opening hours
  /// must start on a whole hour.
  static void _check(StadiumWriteRequest r) {
    final ok = VenueValidators.title(r.name, emptyMessage: '') == null &&
        VenueValidators.optionalText(
              r.description,
              VenuePolicy.descriptionMaxLength,
            ) ==
            null &&
        VenueValidators.optionalText(r.address, VenuePolicy.addressMaxLength) ==
            null &&
        VenueValidators.optionalText(r.township, VenuePolicy.placeMaxLength) ==
            null &&
        VenueValidators.optionalText(r.city, VenuePolicy.placeMaxLength) ==
            null &&
        SlotRules.isValidOpeningHours(r.openMinute, r.closeMinute) &&
        r.openMinute % VenuePolicy.openingHourStep == 0 &&
        VenuePolicy.isValidLocation(r.latitude, r.longitude) &&
        CancellationPolicy.isValidFreeCancelHours(r.freeCancelHours) &&
        VenueValidators.optionalText(
              r.cancellationNote,
              CancellationPolicy.noteMaxLength,
            ) ==
            null;
    if (!ok) throw const InvalidVenueDetailsException();
  }

  static String? _filter(String? value) {
    final v = value?.trim() ?? '';
    return v.isEmpty ? null : v;
  }
}
