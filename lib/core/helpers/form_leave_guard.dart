import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n.dart';
import '../widgets/app_dialogs.dart';

/// "Discard changes?" handling for edit forms (same behaviour as the
/// profile form): wrap the form in
/// `PopScope(canPop: canLeave, onPopInvoked: onPopBlocked, ...)`, call
/// `setState` when [hasChanges] may have changed, and [leave] after a save.
mixin FormLeaveGuard<T extends StatefulWidget> on State<T> {
  bool _allowPop = false;

  /// True when the form differs from what was loaded.
  bool get hasChanges;

  /// Where to go when there is nothing to pop (deep link into the form).
  String get fallbackRoute;

  bool get canLeave => _allowPop || !hasChanges;

  /// Leaves on purpose (saved / discarded) without asking again.
  void leave() {
    setState(() => _allowPop = true);
    // Pop after the rebuild so PopScope.canPop is already true.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(fallbackRoute);
      }
    });
  }

  Future<void> onPopBlocked(bool didPop) async {
    if (didPop) return;
    final l = context.l10n;
    final discard = await showConfirmDialog(
      context,
      title: l.commonDiscardTitle,
      message: l.formDiscardMessage,
      confirmLabel: l.commonDiscard,
      dismissLabel: l.commonKeepEditing,
      destructive: true,
    );
    if (discard && mounted) leave();
  }
}
