import '../../responses/court_response.dart';
import '../../vos/court_vo.dart';

extension CourtResponseMapper on CourtResponse {
  CourtVO toVO() => CourtVO(
        id: id,
        shopId: shopId,
        stadiumId: stadiumId,
        name: name,
        description: description,
        surfaceType: surfaceType,
        capacity: capacity,
        hourlyPrice: hourlyPrice,
        currency: currency,
        slotMinutes: slotMinutes,
        images: images,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
