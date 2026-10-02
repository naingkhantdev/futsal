import '../../core/constants/domain_enums.dart';
import '../responses/announcement_response.dart';

/// `announcements` access as typed Responses. Throws raw Firebase errors;
/// repositories map them. firestore.rules decide which writes succeed.
abstract interface class AnnouncementDataAgent {
  /// PLATFORM scope, newest first.
  Stream<List<AnnouncementResponse>> watchAll();

  /// PLATFORM scope: returns the new id.
  Future<String> create({
    required String title,
    required String body,
    required AnnouncementAudience audience,
    required String createdBy,
  });
}
