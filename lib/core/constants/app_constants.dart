/// App-wide constants (no magic numbers in widgets / router).
abstract final class AppConstants {
  static const String appName = 'Futsal Booking';

  /// Splash shows a spinner only after this delay (design_system.md §7.1).
  static const Duration splashSpinnerDelay = Duration(milliseconds: 600);

  /// Splash intro (emblem, ball shot, wordmark). The router holds on splash
  /// until it ends (skipped when the OS asks to reduce motion).
  static const Duration splashIntroDuration = Duration(milliseconds: 3000);

  /// One loop of the splash background drift / glow pulse.
  static const Duration splashAmbientLoop = Duration(seconds: 4);

  static const Duration snackBarDuration = Duration(seconds: 4);
  static const Duration snackBarWithActionDuration = Duration(seconds: 6);

  /// Nav badge counts above this show as "99+".
  static const int maxBadgeCount = 99;

  /// Query parameter carrying the originally requested path through
  /// splash / login redirects.
  static const String fromQueryParam = 'from';

  /// Max wait for the `users/{uid}` profile (role, shopId, isActive) after
  /// sign-in before the splash shows "We couldn't load your account"
  /// (design_system.md §8.3).
  static const Duration sessionResolveTimeout = Duration(seconds: 10);

  /// Signed in but `users/{uid}` missing (registration was interrupted
  /// after the Auth account was created): wait this long for the
  /// registration flow to write it before the session re-creates it.
  static const Duration profileRepairDelay = Duration(seconds: 3);

  /// Profile screens: how long "loading your profile" spins before offering
  /// "Try again".
  static const Duration profileProvisionTimeout = Duration(seconds: 15);

  /// "Resend" on the password-reset success view is disabled this long.
  static const Duration passwordResetResendCooldown = Duration(seconds: 60);

  /// Splash shows "Setting up your account…" under the spinner after this.
  static const Duration splashCaptionDelay = Duration(seconds: 3);
}
