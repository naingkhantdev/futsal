import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context_ext.dart';
import 'app_button.dart';

/// Where a coach mark points: resolves to a rect in global coordinates, or
/// `null` when the target is not on screen (that step is skipped).
typedef CoachMarkTarget = Future<Rect?> Function();

/// One step of a [showCoachMarkTour]: a spotlight on [target], an arrow to
/// it and a card with [title] + [body]. Without a target it is an intro:
/// the card alone, centered (e.g. "This page lists ...").
@immutable
class CoachMarkStep {
  const CoachMarkStep({
    required this.target,
    required this.title,
    required this.body,
  });

  final CoachMarkTarget? target;
  final String title;
  final String body;
}

/// Target = the widget holding [key]. Scrolls it into view first.
CoachMarkTarget coachMarkKeyTarget(GlobalKey key) => () async {
      final context = key.currentContext;
      if (context == null) return null;
      await Scrollable.ensureVisible(
        context,
        alignment: 0.3,
        duration: AppMotion.enterExit,
        curve: AppMotion.curve,
      );
      return _globalRect(key.currentContext);
    };

Rect? _globalRect(BuildContext? context) {
  final box = context?.findRenderObject();
  if (box is! RenderBox || !box.attached || !box.hasSize) return null;
  final rect = box.localToGlobal(Offset.zero) & box.size;
  return rect.isEmpty ? null : rect;
}

/// Shows the tour above everything (root navigator, so Back = skip).
/// Completes when it is finished or skipped. Steps whose target is missing
/// are skipped; with no visible step nothing is shown.
Future<void> showCoachMarkTour(
  BuildContext context, {
  required List<CoachMarkStep> steps,
}) {
  if (steps.isEmpty) return Future.value();
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: AppMotion.enterExit,
      reverseTransitionDuration: AppMotion.enterExit,
      pageBuilder: (_, __, ___) => _CoachMarkOverlay(steps: steps),
      transitionsBuilder: (context, animation, _, child) => FadeTransition(
        opacity: MediaQuery.disableAnimationsOf(context)
            ? const AlwaysStoppedAnimation(1)
            : CurvedAnimation(parent: animation, curve: AppMotion.curve),
        child: child,
      ),
    ),
  );
}

class _CoachMarkOverlay extends StatefulWidget {
  const _CoachMarkOverlay({required this.steps});

  final List<CoachMarkStep> steps;

  @override
  State<_CoachMarkOverlay> createState() => _CoachMarkOverlayState();
}

class _CoachMarkOverlayState extends State<_CoachMarkOverlay>
    with WidgetsBindingObserver {
  /// Current step (index into widget.steps) and its padded target rect.
  int _index = -1;
  Rect? _hole;
  bool _busy = false;

  static const double _holePadding = AppSpacing.sm;
  static const double _arrowGap = 64;
  static const double _cardMaxWidth = 360;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _goTo(0, forward: true));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Rotation / resize: measure the current target again.
  @override
  void didChangeMetrics() {
    final target = _index < 0 ? null : widget.steps[_index].target;
    if (target == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rect = await target();
      if (mounted && rect != null) setState(() => _hole = _pad(rect));
    });
  }

  Rect _pad(Rect r) => r.inflate(_holePadding);

  /// Shows the first step at or after (forward) / before [start] whose
  /// target is on screen; closes the tour when there is none.
  Future<void> _goTo(int start, {required bool forward}) async {
    if (_busy) return;
    _busy = true;
    try {
      for (var i = start;
          i >= 0 && i < widget.steps.length;
          i += forward ? 1 : -1) {
        final target = widget.steps[i].target;
        if (target == null) {
          setState(() {
            _index = i;
            _hole = null;
          });
          return;
        }
        final rect = await target();
        if (!mounted) return;
        final size = MediaQuery.sizeOf(context);
        if (rect != null && (Offset.zero & size).overlaps(rect)) {
          setState(() {
            _index = i;
            _hole = _pad(rect);
          });
          return;
        }
      }
      if (forward || _index < 0) _close();
    } finally {
      _busy = false;
    }
  }

  void _next() => _goTo(_index + 1, forward: true);

  void _back() => _goTo(_index - 1, forward: false);

  void _close() {
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hole = _hole;
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : AppMotion.enterExit;
    final scrim = colors.scrim.withOpacity(0.72);

    final Widget content;
    if (_index < 0) {
      content = ColoredBox(color: scrim, child: const SizedBox.expand());
    } else if (hole == null) {
      content = _buildIntro(context, scrim);
    } else {
      content = TweenAnimationBuilder<Rect?>(
        tween: RectTween(end: hole),
        duration: duration,
        curve: AppMotion.curve,
        builder: (context, rect, _) => LayoutBuilder(
          builder: (context, constraints) =>
              _buildStep(context, rect ?? hole, constraints.biggest, scrim),
        ),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Tapping anywhere outside the card moves on (and never reaches
        // the screen below).
        onTap: _next,
        child: content,
      ),
    );
  }

  Widget _card(BuildContext context) {
    final step = widget.steps[_index];
    return GestureDetector(
      // Taps on the card itself don't advance.
      onTap: () {},
      child: AnimatedSwitcher(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppMotion.state,
        child: _CoachCard(
          key: ValueKey(_index),
          counter: context.l10n.tourStepOf(_index + 1, widget.steps.length),
          title: step.title,
          body: step.body,
          isFirst: _index == 0,
          isLast: _index == widget.steps.length - 1,
          onSkip: _close,
          onBack: _back,
          onNext: _next,
        ),
      ),
    );
  }

  /// Intro step: dimmed screen, card in the middle, no arrow.
  Widget _buildIntro(BuildContext context, Color scrim) {
    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: scrim)),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
              child: _card(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(BuildContext context, Rect hole, Size size, Color scrim) {
    final padding = MediaQuery.paddingOf(context);
    final colors = context.colors;
    final spaceAbove = hole.top - padding.top;
    final spaceBelow = size.height - padding.bottom - hole.bottom;
    final below = spaceBelow >= spaceAbove;

    final cardWidth =
        math.min(_cardMaxWidth, size.width - 2 * AppSpacing.lg);
    final cardLeft = (hole.center.dx - cardWidth / 2)
        .clamp(AppSpacing.lg, size.width - AppSpacing.lg - cardWidth)
        .toDouble();

    // Arrow: from the card edge nearest the target to just short of it.
    final startX = hole.center.dx
        .clamp(cardLeft + AppSpacing.xxl, cardLeft + cardWidth - AppSpacing.xxl)
        .toDouble();
    final start = below
        ? Offset(startX, hole.bottom + _arrowGap)
        : Offset(startX, hole.top - _arrowGap);
    final end = below
        ? Offset(hole.center.dx, hole.bottom + AppSpacing.xs)
        : Offset(hole.center.dx, hole.top - AppSpacing.xs);

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _ScrimPainter(
              hole: hole,
              scrim: scrim,
              ring: colors.secondary,
            ),
            foregroundPainter: _ArrowPainter(
              start: start,
              end: end,
              color: colors.secondary,
            ),
          ),
        ),
        Positioned(
          left: cardLeft,
          width: cardWidth,
          top: below ? start.dy : null,
          bottom: below ? null : size.height - start.dy,
          child: _card(context),
        ),
      ],
    );
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({
    super.key,
    required this.counter,
    required this.title,
    required this.body,
    required this.isFirst,
    required this.isLast,
    required this.onSkip,
    required this.onBack,
    required this.onNext,
  });

  final String counter;
  final String title;
  final String body;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onSkip;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    return Semantics(
      liveRegion: true,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: colors.secondary, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: AppSizes.iconSm,
                    color: colors.secondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    counter,
                    style: styles.labelMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: styles.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                body,
                style: styles.bodyMedium
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (!isLast)
                    AppTextButton(label: l.tourSkip, onPressed: onSkip),
                  Expanded(
                    // Wraps instead of overflowing with long (Myanmar) labels.
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (!isFirst)
                          AppTextButton(label: l.tourBack, onPressed: onBack),
                        PrimaryButton(
                          label: isLast ? l.tourDone : l.tourNext,
                          onPressed: isLast ? onSkip : onNext,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dims everything except a rounded hole around the target, and rings it.
class _ScrimPainter extends CustomPainter {
  _ScrimPainter({required this.hole, required this.scrim, required this.ring});

  final Rect hole;
  final Color scrim;
  final Color ring;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(hole, const Radius.circular(AppRadius.md));
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(rrect);
    canvas.drawPath(path, Paint()..color = scrim);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = ring
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_ScrimPainter old) =>
      old.hole != hole || old.scrim != scrim || old.ring != ring;
}

/// A hand-drawn-looking curved arrow from [start] to [end] with a head.
class _ArrowPainter extends CustomPainter {
  _ArrowPainter({required this.start, required this.end, required this.color});

  final Offset start;
  final Offset end;
  final Color color;

  static const double _bulge = 36;
  static const double _headLength = 12;
  static const double _headAngle = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    final mid = Offset.lerp(start, end, 0.5)!;
    // Bend sideways, away from the screen edge.
    final side = end.dx > size.width / 2 ? -1.0 : 1.0;
    final control = mid + Offset(_bulge * side, 0);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy),
      paint,
    );

    // Head points along the curve's final tangent (control -> end).
    final angle = (end - control).direction;
    Offset wing(double a) =>
        end - Offset.fromDirection(angle + a, _headLength);
    canvas.drawPath(
      Path()
        ..moveTo(wing(_headAngle).dx, wing(_headAngle).dy)
        ..lineTo(end.dx, end.dy)
        ..lineTo(wing(-_headAngle).dx, wing(-_headAngle).dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter old) =>
      old.start != start || old.end != end || old.color != color;
}
