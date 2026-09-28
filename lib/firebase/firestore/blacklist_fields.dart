/// Field names of `shops/{shopId}/blacklist/{customerId}`. Written by that
/// shop's admins (or the superadmin); immutable (delete to lift). The
/// booking create rule refuses customers who have an entry.
abstract final class BlacklistFields {
  static const String shopId = 'shopId';
  static const String customerId = 'customerId';

  /// Display snapshots from the customer's booking.
  static const String customerNameSnapshot = 'customerNameSnapshot';
  static const String customerPhoneSnapshot = 'customerPhoneSnapshot';

  /// `BlacklistReason` wire value.
  static const String reason = 'reason';
  static const String note = 'note';
  static const String createdBy = 'createdBy';
  static const String createdAt = 'createdAt';
}
