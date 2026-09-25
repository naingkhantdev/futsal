import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_exception.dart';

extension AsyncValueAppErrorX<T> on AsyncValue<T> {
  /// The error of a settled (not loading) state as an [AppException], for
  /// inline form banners. `null` while loading so a retry clears the banner.
  /// Repositories already map errors; anything else becomes
  /// [UnknownException] so raw text never reaches the UI.
  AppException? get appError {
    if (isLoading || !hasError) return null;
    final e = error;
    return e is AppException
        ? e
        : UnknownException(cause: e, stackTrace: stackTrace);
  }
}
