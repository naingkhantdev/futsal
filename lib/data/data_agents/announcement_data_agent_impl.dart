import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../../firebase/firestore/announcement_fields.dart';
import '../../firebase/firestore/announcements_collection.dart';
import '../responses/announcement_response.dart';
import 'announcement_data_agent.dart';

class AnnouncementDataAgentImpl implements AnnouncementDataAgent {
  AnnouncementDataAgentImpl(this._announcements);

  final AnnouncementsCollection _announcements;

  @override
  Stream<List<AnnouncementResponse>> watchAll() {
    return _announcements.watchAll().map(
          (query) => [
            for (final doc in query.docs)
              if (AnnouncementResponse.tryFromFirestore(doc.id, doc.data())
                  case final r?)
                r,
          ],
        );
  }

  @override
  Future<String> create({
    required String title,
    required String body,
    required AnnouncementAudience audience,
    required String createdBy,
  }) {
    // Exactly the shape firestore.rules `validNewAnnouncement` accepts.
    return _announcements.create({
      AnnouncementFields.title: title,
      AnnouncementFields.body: body,
      AnnouncementFields.audience: audience.name,
      AnnouncementFields.createdBy: createdBy,
    });
  }
}

final announcementDataAgentProvider = Provider<AnnouncementDataAgent>(
  (ref) =>
      AnnouncementDataAgentImpl(ref.watch(announcementsCollectionProvider)),
);
