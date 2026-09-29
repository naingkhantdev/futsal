import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// App-wide scrolling: iOS-style bouncing physics on every platform, and
/// drag-to-scroll with a mouse / trackpad too (web, desktop, emulators).
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
        decelerationRate: ScrollDecelerationRate.normal,
      );

  /// Bouncing replaces the Android stretch / glow.
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

/// Marks when a list / page first appeared. [FadeSlideIn]s inside it only
/// animate during the first [AppMotion.entranceWindow]; items a lazy list
/// builds later (scrolling back up) show at once instead of fading in again.
class EntranceScope extends StatefulWidget {
  const EntranceScope({super.key, required this.child});

  final Widget child;

  @override
  State<EntranceScope> createState() => _EntranceScopeState();
}

class _EntranceScopeState extends State<EntranceScope> {
  final DateTime _start = DateTime.now();

  @override
  Widget build(BuildContext context) =>
      _EntranceClock(start: _start, child: widget.child);
}

class _EntranceClock extends InheritedWidget {
  const _EntranceClock({required this.start, required super.child});

  final DateTime start;

  @override
  bool updateShouldNotify(_EntranceClock oldWidget) => false;
}

/// Fades [child] in while it rises [AppMotion.entranceOffset] into place,
/// once, when first built. [index] staggers siblings in a list; items past
/// [AppMotion.maxStaggerIndex] share the last delay. Skipped when the
/// platform asks for reduced motion, or when built after the enclosing
/// [EntranceScope]'s window.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: AppMotion.entrance);
  late final Animation<double> _t =
      CurvedAnimation(parent: _controller, curve: AppMotion.entranceCurve);
  Timer? _delay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.status != AnimationStatus.dismissed || _delay != null) {
      return;
    }
    final clock = context.getInheritedWidgetOfExactType<_EntranceClock>();
    final tooLate = clock != null &&
        DateTime.now().difference(clock.start) > AppMotion.entranceWindow;
    if (tooLate || MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      return;
    }
    final steps = widget.index.clamp(0, AppMotion.maxStaggerIndex);
    _delay = Timer(AppMotion.stagger * steps, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _t.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _t.value) * AppMotion.entranceOffset),
          child: child,
        ),
      ),
    );
  }
}

/// Scales [child] down slightly while a pointer is pressed on it: tactile
/// feedback for cards. Listens without claiming the gesture, so the
/// child's own `InkWell` / buttons still receive taps. Inert when
/// [enabled] is false or reduced motion is on.
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;
  Offset? _down;

  void _set(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }
    return Listener(
      onPointerDown: (e) {
        _down = e.position;
        _set(true);
      },
      // A drag is a scroll, not a press: release as soon as it moves.
      onPointerMove: (e) {
        final down = _down;
        if (down != null && (e.position - down).distance > kTouchSlop) {
          _set(false);
        }
      },
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? AppMotion.pressScale : 1,
        duration: AppMotion.press,
        curve: AppMotion.curve,
        child: widget.child,
      ),
    );
  }
}
