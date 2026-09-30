import '../../core/constants/domain_enums.dart';
import '../../core/constants/push_topics.dart';
import '../../core/errors/error_guard.dart';
import '../data_agents/push_data_agent.dart';
import '../responses/push_message_response.dart';
import '../vos/push_message_vo.dart';
import 'push_repository.dart';

class PushRepositoryImpl implements PushRepository {
  PushRepositoryImpl({required PushDataAgent pushDataAgent})
      : _push = pushDataAgent;

  final PushDataAgent _push;

  @override
  Future<void> enableFor({required UserRole role, String? shopId}) {
    return guardAppException(() async {
      final allowed = await _push.requestPermission();
      if (!allowed || !_push.supportsTopics) return;
      await _push.subscribe(PushTopics.all);
      for (final r in UserRole.values) {
        final topic = PushTopics.role(r);
        await (r == role ? _push.subscribe(topic) : _push.unsubscribe(topic));
      }
      if (role == UserRole.shopAdmin && shopId != null && shopId.isNotEmpty) {
        await _push.subscribe(PushTopics.shop(shopId));
      }
    });
  }

  @override
  Future<void> disable() => guardAppException(_push.reset);

  @override
  Stream<PushMessageVO> get foregroundMessages =>
      mapStreamErrors(_push.foregroundMessages.map(_toVO));

  @override
  Stream<PushMessageVO> get openedMessages =>
      mapStreamErrors(_push.openedMessages.map(_toVO));

  @override
  Future<PushMessageVO?> initialMessage() {
    return guardAppException(() async {
      final r = await _push.initialMessage();
      return r == null ? null : _toVO(r);
    });
  }

  /// Only in-app paths (`/customer/...`); anything else (full URLs,
  /// `//host`) is dropped.
  static PushMessageVO _toVO(PushMessageResponse r) {
    final route = r.route;
    final safe =
        route != null && route.startsWith('/') && !route.startsWith('//');
    return PushMessageVO(
      title: r.title,
      body: r.body,
      route: safe ? route : null,
    );
  }
}
