/// Field names of `announcements/{announcementId}`. PLATFORM scope:
/// create-only, by the superadmin. Read by the superadmin and by signed-in
/// users the audience covers (firestore.rules).
abstract final class AnnouncementFields {
  static const String title = 'title';
  static const String body = 'body';

  /// `AnnouncementAudience` wire value.
  static const String audience = 'audience';
  static const String createdBy = 'createdBy';
  static const String createdAt = 'createdAt';
}
