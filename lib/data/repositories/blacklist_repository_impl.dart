import '../../core/constants/blacklist_policy.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/error_guard.dart';
import '../../core/utils/validators.dart';
import '../data_agents/auth_data_agent.dart';
import '../data_agents/blacklist_data_agent.dart';
import '../requests/blacklist_requests.dart';
import '../vos/blacklist_entry_vo.dart';
import 'blacklist_repository.dart';
import 'mappers/blacklist_mapper.dart';

class BlacklistRepositoryImpl implements BlacklistRepository {
  BlacklistRepositoryImpl({
    required BlacklistDataAgent blacklistDataAgent,
    required AuthDataAgent authDataAgent,
  })  : _blacklist = blacklistDataAgent,
        _auth = authDataAgent;

  final BlacklistDataAgent _blacklist;
  final AuthDataAgent _auth;

  @override
  Stream<List<BlacklistEntryVO>> watchShopBlacklist(String shopId) {
    return mapStreamErrors(
      _blacklist
          .watchShopBlacklist(shopId)
          .map((list) => [for (final r in list) r.toVO()]),
    );
  }

  @override
  Stream<BlacklistEntryVO?> watchEntry(String shopId, String customerId) {
    return mapStreamErrors(
      _blacklist.watchEntry(shopId, customerId).map((r) => r?.toVO()),
    );
  }

  @override
  Future<bool> isBlacklisted(String shopId, String customerId) {
    return guardAppException(
      () => _blacklist.isBlacklisted(shopId, customerId),
    );
  }

  @override
  Future<void> add(String shopId, BlacklistAddRequest request) {
    return guardAppException(() async {
      final user = _auth.currentUser;
      if (user == null) throw const AuthenticationException();
      // Mirrors firestore.rules validBlacklistEntry.
      final name = request.customerName.trim();
      final note = request.note?.trim() ?? '';
      if (request.customerId.isEmpty ||
          request.customerId == user.uid ||
          name.length < ValidationLimits.nameMinLength ||
          name.length > ValidationLimits.nameMaxLength ||
          note.length > BlacklistPolicy.noteMaxLength) {
        throw const InvalidVenueDetailsException();
      }
      await _blacklist.addEntry(
        shopId,
        request.customerId,
        request.toFields(shopId: shopId, createdBy: user.uid),
      );
    });
  }

  @override
  Future<void> remove(String shopId, String customerId) {
    return guardAppException(
      () => _blacklist.removeEntry(shopId, customerId),
    );
  }
}
