import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_brand.dart';
import '../theme/theme_context_ext.dart';

/// Brand loading indicator: a hairline track with a navy arc that fades out
/// behind its head and a small gold dot leading it, rotating smoothly. With
/// [showBall] the logo ball sits in the centre (full-screen loading).
///
/// Replaces `CircularProgressIndicator` app-wide. Reduced motion: the arc
/// stays still.
class AppLoader extends StatefulWidget {
  const AppLoader({
    super.key,
    this.size = 40,
    this.color,
    this.showBall = false,
    this.semanticLabel,
  });

  /// Small size for buttons.
  const AppLoader.small({super.key, this.color, this.semanticLabel})
      : size = 20,
        showBall = false;

  final double size;

  /// Arc color; defaults to `primary`. Buttons pass their foreground color.
  final Color? color;
  final bool showBall;
  final String? semanticLabel;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _spin.stop();
    } else if (!_spin.isAnimating) {
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.colors.primary;
    final small = widget.size < 28;
    final loader = SizedBox.square(
      dimension: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              size: Size.square(widget.size),
              painter: _LoaderPainter(
                turn: _spin,
                color: color,
                track: color.withOpacity(0.12),
                // The gold head reads as brand at full size; small loaders
                // (inside buttons) stay one color for contrast.
                head: small ? color : AppBrand.gold,
                stroke: small ? 2.2 : 2.6,
              ),
            ),
          ),
          if (widget.showBall)
            Image.asset(
              AppAssets.logoBall,
              width: widget.size * 0.5,
              height: widget.size * 0.5,
              filterQuality: FilterQuality.medium,
              excludeFromSemantics: true,
            ),
        ],
      ),
    );
    return Semantics(
      label: widget.semanticLabel,
      // Announce as progress when labelled.
      liveRegion: widget.semanticLabel != null,
      child: loader,
    );
  }
}

class _LoaderPainter extends CustomPainter {
  _LoaderPainter({
    required this.turn,
    required this.color,
    required this.track,
    required this.head,
    required this.stroke,
  }) : super(repaint: turn);

  final Animation<double> turn;
  final Color color;
  final Color track;
  final Color head;
  final double stroke;

  /// Arc length (fraction of the circle).
  static const double _sweep = 0.72;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2 - 1;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );

    final start = 2 * math.pi * turn.value - math.pi / 2;
    const sweep = 2 * math.pi * _sweep;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(start);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawArc(
      rect,
      0,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: [color.withOpacity(0), color],
          stops: const [0, _sweep],
        ).createShader(rect),
    );
    // Head dot at the arc's leading end.
    final headPos = center + Offset(math.cos(sweep), math.sin(sweep)) * radius;
    canvas.drawCircle(headPos, stroke * 1.15, Paint()..color = head);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LoaderPainter old) =>
      old.color != color || old.head != head || old.stroke != stroke;
}
