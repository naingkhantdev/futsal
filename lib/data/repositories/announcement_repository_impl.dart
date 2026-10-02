import '../../core/constants/domain_enums.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../data_agents/announcement_data_agent.dart';
import '../data_agents/auth_data_agent.dart';
import '../vos/announcement_vo.dart';
import 'announcement_repository.dart';
import 'mappers/announcement_mapper.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl({
    required AnnouncementDataAgent announcementDataAgent,
    required AuthDataAgent authDataAgent,
  })  : _announcements = announcementDataAgent,
        _auth = authDataAgent;

  final AnnouncementDataAgent _announcements;
  final AuthDataAgent _auth;

  @override
  Stream<List<AnnouncementVO>> watchAll() {
    return mapStreamErrors(
      _announcements.watchAll().map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Future<String> send({
    required String title,
    required String body,
    required AnnouncementAudience audience,
  }) {
    return guardAppException(() {
      final user = _auth.currentUser;
      if (user == null) throw const AuthenticationException();
      return _announcements.create(
        title: title.trim(),
        body: body.trim(),
        audience: audience,
        createdBy: user.uid,
      );
    });
  }
}
