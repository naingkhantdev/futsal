import '../../responses/announcement_response.dart';
import '../../vos/announcement_vo.dart';

extension AnnouncementResponseMapper on AnnouncementResponse {
  AnnouncementVO toVO() => AnnouncementVO(
        id: id,
        title: title,
        body: body,
        audience: audience,
        createdBy: createdBy,
        createdAt: createdAt,
      );
}
