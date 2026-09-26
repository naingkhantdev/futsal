import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the splash intro animation has finished. The router keeps the
/// user on `/splash` until it has (see `resolveRedirect(holdOnSplash:)`).
/// Only ever flips false → true, so later visits to splash are not held.
class SplashIntroNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void complete() {
    if (!state) state = true;
  }
}

final splashIntroDoneProvider =
    NotifierProvider<SplashIntroNotifier, bool>(SplashIntroNotifier.new);
