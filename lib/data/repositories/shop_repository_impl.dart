import '../../core/constants/domain_enums.dart';
import '../../core/constants/venue_policy.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../../core/utils/validators.dart';
import '../data_agents/auth_data_agent.dart';
import '../data_agents/shop_data_agent.dart';
import '../data_agents/stadium_data_agent.dart';
import '../requests/venue_write_requests.dart';
import '../vos/shop_private_vo.dart';
import '../vos/shop_vo.dart';
import 'mappers/shop_mapper.dart';
import 'shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  ShopRepositoryImpl({
    required ShopDataAgent shopDataAgent,
    required StadiumDataAgent stadiumDataAgent,
    required AuthDataAgent authDataAgent,
  })  : _shops = shopDataAgent,
        _stadiums = stadiumDataAgent,
        _auth = authDataAgent;

  final ShopDataAgent _shops;
  final StadiumDataAgent _stadiums;
  final AuthDataAgent _auth;

  @override
  Stream<ShopVO?> watchShop(String shopId) {
    return mapStreamErrors(
      _shops.watchShop(shopId).map((response) => response?.toVO()),
    );
  }

  @override
  Stream<ShopPrivateVO?> watchShopPrivateDetails(String shopId) {
    return mapStreamErrors(
      _shops
          .watchShopPrivateDetails(shopId)
          .map((response) => response?.toVO()),
    );
  }

  @override
  Stream<List<ShopVO>> watchShops() {
    return mapStreamErrors(
      _shops.watchShops().map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Future<String> createShop(ShopProfileRequest request) {
    return guardAppException(() {
      _checkProfile(request);
      return _shops.createShop(
        shop: {
          ...request.toShopFields(),
          ...const ShopStatusRequest(
            status: ShopStatus.pending,
            isListed: false,
          ).toShopFields(),
        },
        details: request.toPrivateFields(),
      );
    });
  }

  @override
  Future<void> updateShopProfile(String shopId, ShopProfileRequest request) {
    return guardAppException(() {
      _checkProfile(request);
      return _shops.updateShop(
        shopId,
        shop: request.toShopFields(),
        details: request.toPrivateFields(),
      );
    });
  }

  @override
  Future<void> setShopStatus(
    String shopId, {
    required ShopStatus status,
    required bool isListed,
    String? reason,
  }) {
    return guardAppException(() async {
      final current = await _shops.getShop(shopId);
      if (current == null) throw const NotFoundException();
      final now = DateTime.now();
      final firstApproval =
          status == ShopStatus.active && current.approvedAt == null;
      final suspending = status == ShopStatus.suspended;
      final request = ShopStatusRequest(
        status: status,
        isListed: isListed,
        approvedAt: firstApproval ? now : null,
        approvedBy: firstApproval ? _auth.currentUser?.uid : null,
        suspendedAt: suspending ? now : null,
        suspendedReason: suspending ? reason : null,
      );

      // Re-sync only stadiums whose published state actually changes.
      final stadiums = await _stadiums.getShopStadiums(shopId);
      final published = <String, bool>{
        for (final s in stadiums)
          if (VenuePolicy.isPublished(
                shopStatus: status,
                shopIsListed: isListed,
                stadiumIsActive: s.isActive,
              ) !=
              s.isPublished)
            s.id: !s.isPublished,
      };

      await _shops.updateShop(
        shopId,
        shop: request.toShopFields(),
        details: request.toPrivateFields(),
        stadiumPublished: published,
      );
    });
  }

  /// Mirrors `validShopShape` so an invalid save fails before the round
  /// trip with a clear error instead of `permission-denied`.
  static void _checkProfile(ShopProfileRequest r) {
    final ok = AppValidators.name(r.name) == null &&
        AppValidators.optionalPhone(r.phone) == null &&
        AppValidators.optionalPhone(r.ownerPhone) == null &&
        VenueValidators.optionalEmail(r.email) == null &&
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
        VenueValidators.optionalText(r.ownerName, VenuePolicy.placeMaxLength) ==
            null;
    if (!ok) throw const InvalidVenueDetailsException();
  }
}
