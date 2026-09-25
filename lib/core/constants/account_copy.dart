/// Account-status copy shared by the splash error view and
/// `/account-blocked` so both states read identically (design_system.md §9).
abstract final class AccountCopy {
  static const String unavailableTitle = 'Account unavailable';
  static const String disabledMessage =
      'Your account has been disabled. Contact support if you think this is a mistake.';

  /// SHOP scope: active shop admin without a shopId in `users/{uid}`.
  static const String missingShopMessage =
      "Your shop access isn't set up yet. Contact the platform team.";
}
