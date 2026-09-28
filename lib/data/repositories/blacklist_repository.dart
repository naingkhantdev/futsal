import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_agents/auth_data_agent_impl.dart';
import '../data_agents/blacklist_data_agent_impl.dart';
import '../requests/blacklist_requests.dart';
import '../vos/blacklist_entry_vo.dart';
import 'blacklist_repository_impl.dart';

/// Shop blacklists. Every method throws / emits only `AppException`.
///
/// SHOP scope: a shop's admins (and the superadmin) manage the list of
/// their own shop only; a blacklisted customer can't create new bookings
/// at that shop (firestore.rules `validNewBooking`). Other shops and
/// existing bookings are not affected.
abstract interface class BlacklistRepository {
  /// Newest first.
  Stream<List<BlacklistEntryVO>> watchShopBlacklist(String shopId);

  /// `null` while [customerId] is not blacklisted at [shopId].
  Stream<BlacklistEntryVO?> watchEntry(String shopId, String customerId);

  /// Booking pre-check (the rules enforce it anyway).
  Future<bool> isBlacklisted(String shopId, String customerId);

  Future<void> add(String shopId, BlacklistAddRequest request);

  Future<void> remove(String shopId, String customerId);
}

final blacklistRepositoryProvider = Provider<BlacklistRepository>(
  (ref) => BlacklistRepositoryImpl(
    blacklistDataAgent: ref.watch(blacklistDataAgentProvider),
    authDataAgent: ref.watch(authDataAgentProvider),
  ),
);
