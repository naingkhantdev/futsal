import '../../responses/blacklist_entry_response.dart';
import '../../vos/blacklist_entry_vo.dart';

extension BlacklistEntryResponseMapper on BlacklistEntryResponse {
  BlacklistEntryVO toVO() => BlacklistEntryVO(
        customerId: customerId,
        shopId: shopId,
        customerName: customerNameSnapshot,
        customerPhone: customerPhoneSnapshot,
        reason: reason,
        note: note,
        createdBy: createdBy,
        createdAt: createdAt,
      );
}
