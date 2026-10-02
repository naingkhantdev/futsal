import 'package:flutter/foundation.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/announcement_fields.dart';
import 'firestore_read.dart';

/// Typed DTO for `announcements/{id}`. `null` from [tryFromFirestore] when
/// the audience is unknown (e.g. written by a newer app version).
@immutable
class AnnouncementResponse {
  const AnnouncementResponse({
    required this.id,
    required this.title,
    required this.body,
    required this.audience,
    this.createdBy,
    this.createdAt,
  });

  static AnnouncementResponse? tryFromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final audience = AnnouncementAudience.tryParse(
      FirestoreRead.string(data[AnnouncementFields.audience]),
    );
    if (audience == null) return null;
    return AnnouncementResponse(
      id: id,
      title: FirestoreRead.string(data[AnnouncementFields.title]) ?? '',
      body: FirestoreRead.string(data[AnnouncementFields.body]) ?? '',
      audience: audience,
      createdBy: FirestoreRead.string(data[AnnouncementFields.createdBy]),
      createdAt: FirestoreRead.date(data[AnnouncementFields.createdAt]),
    );
  }

  final String id;
  final String title;
  final String body;
  final AnnouncementAudience audience;
  final String? createdBy;
  final DateTime? createdAt;
}
