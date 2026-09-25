import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_exception.dart';
import '../theme/app_sizes.dart';
import 'error_view.dart';
import 'loading_view.dart';

/// Maps a Riverpod [AsyncValue] to loading / empty / error / data views so a
/// screen is never blank (design_system.md §7).
///
/// - First load → [loading] (pass a skeleton) or [LoadingView].
/// - Refresh with data present → data stays visible + 2dp progress bar.
/// - Error with no data → [ErrorView] (non-[AppException] errors are shown
///   as [UnknownException]; repositories should already have mapped them).
/// - Error with stale data → data stays visible; surface a snackbar from the
///   screen via `ref.listen` if needed.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.isEmpty,
    this.empty,
    required this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;

  /// When it returns true, [empty] is shown instead of [data].
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  /// Required so every caller decides explicitly; pass `null` for no retry.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (value.hasValue) {
      final current = value.requireValue;
      final showEmpty = empty != null && (isEmpty?.call(current) ?? false);
      final content = showEmpty ? empty! : data(current);
      if (!value.isRefreshing && !value.isReloading) return content;
      return Stack(
        children: [
          content,
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              minHeight: AppSizes.refreshBarHeight,
            ),
          ),
        ],
      );
    }
    if (value.hasError) {
      final error = value.error;
      return ErrorView(
        error: error is AppException
            ? error
            : UnknownException(cause: error, stackTrace: value.stackTrace),
        onRetry: onRetry,
      );
    }
    return loading ?? const LoadingView();
  }
}
