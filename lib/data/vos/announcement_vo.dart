import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/domain_enums.dart';

part 'announcement_vo.freezed.dart';

/// A platform announcement (`announcements/{id}`). PLATFORM scope: written
/// by the superadmin only (`AnnouncementRepository`).
@freezed
class AnnouncementVO with _$AnnouncementVO {
  const factory AnnouncementVO({
    required String id,
    required String title,
    required String body,
    required AnnouncementAudience audience,
    String? createdBy,
    DateTime? createdAt,
  }) = _AnnouncementVO;
}
