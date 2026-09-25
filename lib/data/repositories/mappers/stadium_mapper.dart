import '../../responses/stadium_response.dart';
import '../../vos/stadium_vo.dart';

extension StadiumResponseMapper on StadiumResponse {
  StadiumVO toVO() => StadiumVO(
        id: id,
        shopId: shopId,
        name: name,
        description: description,
        address: address,
        township: township,
        city: city,
        latitude: latitude,
        longitude: longitude,
        images: images,
        facilities: facilities,
        openMinute: openMinute,
        closeMinute: closeMinute,
        timeZone: timeZone,
        isActive: isActive,
        isPublished: isPublished,
        minHourlyPrice: minHourlyPrice,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
