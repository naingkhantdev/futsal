import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/firestore/blacklist_collection.dart';
import '../responses/blacklist_entry_response.dart';
import 'blacklist_data_agent.dart';

class BlacklistDataAgentImpl implements BlacklistDataAgent {
  BlacklistDataAgentImpl(this._blacklist);

  final BlacklistCollection _blacklist;

  @override
  Stream<List<BlacklistEntryResponse>> watchShopBlacklist(String shopId) {
    return _blacklist.watchShop(shopId).map(
          (query) => [
            for (final doc in query.docs)
              BlacklistEntryResponse.fromFirestore(doc.id, doc.data()),
          ],
        );
  }

  @override
  Stream<BlacklistEntryResponse?> watchEntry(
    String shopId,
    String customerId,
  ) {
    return _blacklist.watchEntry(shopId, customerId).map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return BlacklistEntryResponse.fromFirestore(snapshot.id, data);
    });
  }

  @override
  Future<bool> isBlacklisted(String shopId, String customerId) async =>
      (await _blacklist.getEntry(shopId, customerId)).exists;

  @override
  Future<void> addEntry(
    String shopId,
    String customerId,
    Map<String, Object?> fields,
  ) =>
      _blacklist.create(shopId, customerId, fields);

  @override
  Future<void> removeEntry(String shopId, String customerId) =>
      _blacklist.delete(shopId, customerId);
}

final blacklistDataAgentProvider = Provider<BlacklistDataAgent>(
  (ref) => BlacklistDataAgentImpl(ref.watch(blacklistCollectionProvider)),
);
