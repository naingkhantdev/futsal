import '../../responses/shop_private_response.dart';
import '../../responses/shop_response.dart';
import '../../vos/shop_private_vo.dart';
import '../../vos/shop_vo.dart';

extension ShopResponseMapper on ShopResponse {
  ShopVO toVO() => ShopVO(
        id: id,
        name: name,
        slug: slug,
        description: description,
        logo: logo,
        coverImage: coverImage,
        phone: phone,
        email: email,
        address: address,
        township: township,
        city: city,
        latitude: latitude,
        longitude: longitude,
        status: status,
        isListed: isListed,
        approvedAt: approvedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension ShopPrivateResponseMapper on ShopPrivateResponse {
  ShopPrivateVO toVO() => ShopPrivateVO(
        shopId: shopId,
        ownerName: ownerName,
        ownerPhone: ownerPhone,
        adminIds: adminIds,
        approvedBy: approvedBy,
        suspendedAt: suspendedAt,
        suspendedReason: suspendedReason,
        updatedAt: updatedAt,
      );
}
