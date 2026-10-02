import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/domain_enums.dart';
import '../data_agents/announcement_data_agent_impl.dart';
import '../data_agents/auth_data_agent_impl.dart';
import '../vos/announcement_vo.dart';
import 'announcement_repository_impl.dart';

/// PLATFORM scope: announcements. Every method throws / emits only
/// `AppException`. Only an active superadmin can send them and list them
/// all (firestore.rules); they are never edited or deleted.
abstract interface class AnnouncementRepository {
  /// Newest first (latest 100).
  Stream<List<AnnouncementVO>> watchAll();

  /// Trims [title] and [body] and returns the new id. The rules refuse blank
  /// or over-long texts.
  Future<String> send({
    required String title,
    required String body,
    required AnnouncementAudience audience,
  });
}

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  (ref) => AnnouncementRepositoryImpl(
    announcementDataAgent: ref.watch(announcementDataAgentProvider),
    authDataAgent: ref.watch(authDataAgentProvider),
  ),
);
