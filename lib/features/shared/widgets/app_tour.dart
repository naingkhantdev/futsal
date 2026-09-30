import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/adaptive_nav_shell.dart';
import '../../../core/widgets/coach_mark_tour.dart';
import '../providers/app_tour_providers.dart';

/// One step of a page tour: points at a [TourAnchor] ([AppTourStep.anchor]),
/// at a bottom-bar tab ([AppTourStep.tab]), or at nothing
/// ([AppTourStep.intro]: a centered card explaining the page).
@immutable
class AppTourStep {
  const AppTourStep.anchor(
    String this.anchor, {
    required this.title,
    required this.body,
  }) : tabIndex = null;

  const AppTourStep.tab(
    int this.tabIndex, {
    required this.title,
    required this.body,
  }) : anchor = null;

  const AppTourStep.intro({required this.title, required this.body})
      : anchor = null,
        tabIndex = null;

  final String? anchor;
  final int? tabIndex;
  final String title;
  final String body;

  bool get isIntro => anchor == null && tabIndex == null;
}

/// A page's tour: a stable [id] (the "seen" flag) and its steps, built when
/// it starts so texts follow the current language.
@immutable
class AppTourDef {
  const AppTourDef(this.id, this.steps);

  final String id;
  final List<AppTourStep> Function(AppLocalizations l) steps;

  /// Wraps a page (usually in its route builder) with this tour.
  Widget wrap(Widget page) =>
      AppTourLauncher(key: ValueKey('tour:$id'), tour: this, child: page);
}

/// Runs [tour] once, the first time the page is shown; again when
/// [appTourRequestProvider] asks for it or a [TourHelpButton] is tapped.
/// Widgets the tour points at are [TourAnchor]s below it.
class AppTourLauncher extends ConsumerStatefulWidget {
  const AppTourLauncher({super.key, required this.tour, required this.child});

  final AppTourDef tour;
  final Widget child;

  @override
  ConsumerState<AppTourLauncher> createState() => _AppTourLauncherState();
}

class _AppTourLauncherState extends ConsumerState<AppTourLauncher> {
  final Map<String, GlobalKey> _anchors = {};
  bool _running = false;

  /// Lets entrance animations and route transitions settle first.
  static const Duration _startDelay = Duration(milliseconds: 700);

  String get _id => widget.tour.id;

  GlobalKey _keyFor(String id) =>
      _anchors.putIfAbsent(id, () => GlobalKey(debugLabel: 'tour:$id'));

  @override
  void initState() {
    super.initState();
    if (!ref.read(appTourStoreProvider).isSeen(_id)) _schedule();
    ref.listenManual<String?>(appTourRequestProvider, (_, request) {
      if (request == _id) _schedule();
    }, fireImmediately: true);
  }

  void _schedule() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future<void>.delayed(
        MediaQuery.disableAnimationsOf(context) ? Duration.zero : _startDelay,
        _run,
      );
    });
  }

  /// Only while this page is the one on top (not a hidden tab or under a
  /// pushed route).
  bool get _visible =>
      mounted &&
      TickerMode.of(context) &&
      (ModalRoute.of(context)?.isCurrent ?? true);

  Future<void> _run() async {
    if (_running || !_visible) return;
    _running = true;
    if (ref.read(appTourRequestProvider) == _id) {
      ref.read(appTourRequestProvider.notifier).state = null;
    }
    // Read before awaiting: this page may be gone when the tour ends.
    final store = ref.read(appTourStoreProvider);
    try {
      final steps = <CoachMarkStep>[];
      for (final s in widget.tour.steps(context.l10n)) {
        final target = _target(s);
        if (s.isIntro || target != null) {
          steps.add(CoachMarkStep(target: target, title: s.title, body: s.body));
        }
      }
      await showCoachMarkTour(context, steps: steps);
      await store.markSeen(_id);
    } finally {
      _running = false;
    }
  }

  CoachMarkTarget? _target(AppTourStep s) {
    final tab = s.tabIndex;
    if (tab != null) return NavBarScope.tabTarget(context, tab);
    final anchor = s.anchor;
    if (anchor == null) return null;
    return coachMarkKeyTarget(_keyFor(anchor));
  }

  @override
  Widget build(BuildContext context) {
    return _TourScope(keyFor: _keyFor, start: _run, child: widget.child);
  }
}

class _TourScope extends InheritedWidget {
  const _TourScope({
    required this.keyFor,
    required this.start,
    required super.child,
  });

  final GlobalKey Function(String id) keyFor;
  final Future<void> Function() start;

  @override
  bool updateShouldNotify(_TourScope old) => false;
}

/// Marks a widget an [AppTourStep.anchor] step can point at. Outside an
/// [AppTourLauncher] it renders [child] unchanged.
class TourAnchor extends StatelessWidget {
  const TourAnchor({super.key, required this.id, required this.child});

  final String id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<_TourScope>();
    if (scope == null) return child;
    return KeyedSubtree(key: scope.keyFor(id), child: child);
  }
}

/// App bar "?" that replays the page's tour. Renders nothing outside an
/// [AppTourLauncher].
class TourHelpButton extends StatelessWidget {
  const TourHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<_TourScope>();
    if (scope == null) return const SizedBox.shrink();
    return IconButton(
      tooltip: context.l10n.tourHelp,
      icon: const Icon(Icons.help_outline),
      onPressed: scope.start,
    );
  }
}

/// "App tour" in Profile / Settings: every page shows its tips again on the
/// next visit, starting with [home] right away.
Future<void> replayAppTours(
  BuildContext context,
  WidgetRef ref,
  AppTourDef home,
  String homeRoute,
) async {
  await ref.read(appTourStoreProvider).resetAll();
  ref.read(appTourRequestProvider.notifier).state = home.id;
  if (context.mounted) context.go(homeRoute);
}
