import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_exception.dart';
import '../theme/app_motion.dart';
import '../theme/app_sizes.dart';
import 'error_view.dart';
import 'loading_view.dart';
import 'motion.dart';

/// Maps a Riverpod [AsyncValue] to loading / empty / error / data views so a
/// screen is never blank (design_system.md §7).
///
/// - First load → [loading] (pass a skeleton) or [LoadingView].
/// - Refresh with data present → data stays visible + 2dp progress bar.
/// - Error with no data → [ErrorView] (non-[AppException] errors are shown
///   as [UnknownException]; repositories should already have mapped them).
/// - Error with stale data → data stays visible; surface a snackbar from the
///   screen via `ref.listen` if needed.
///
/// Switching between those states crossfades (skeleton → content); updates
/// within the same state don't re-animate.
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
    final (String phase, Widget child) = _resolve();
    return AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : AppMotion.enterExit,
      switchInCurve: AppMotion.curve,
      switchOutCurve: AppMotion.curve,
      // Top-aligned so lists don't jump to the middle while fading.
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topCenter,
        children: [...previous, if (current != null) current],
      ),
      // Each state gets its own entrance window for staggered lists.
      child: KeyedSubtree(
        key: ValueKey(phase),
        child: EntranceScope(child: child),
      ),
    );
  }

  /// The state's name (switch key) and its view.
  (String, Widget) _resolve() {
    if (value.hasValue) {
      final current = value.requireValue;
      final showEmpty = empty != null && (isEmpty?.call(current) ?? false);
      final content = showEmpty ? empty! : data(current);
      final phase = showEmpty ? 'empty' : 'data';
      if (!value.isRefreshing && !value.isReloading) return (phase, content);
      final refreshing = Stack(
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
      return (phase, refreshing);
    }
    if (value.hasError) {
      final error = value.error;
      final view = ErrorView(
        error: error is AppException
            ? error
            : UnknownException(cause: error, stackTrace: value.stackTrace),
        onRetry: onRetry,
      );
      return ('error', view);
    }
    return ('loading', loading ?? const LoadingView());
  }
}
