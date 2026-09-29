import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_motion.dart';
import '../theme/theme_context_ext.dart';

/// A venue photo that fills its box (cover crop). While loading, on error
/// or without a [url] it shows [PitchPlaceholder], so a card never looks
/// broken or empty. Decorative: callers give the card its semantics.
class StadiumPhoto extends StatelessWidget {
  const StadiumPhoto({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) return const PitchPlaceholder();
    final animate = !MediaQuery.disableAnimationsOf(context);
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      fadeInDuration: animate ? AppMotion.enterExit : Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (_, __) => const PitchPlaceholder(),
      errorWidget: (_, __, ___) => const PitchPlaceholder(),
    );
  }
}

/// Navy field with faint futsal-court markings (touchlines, halfway line,
/// centre circle): stands in for a venue photo without a clip-art icon.
class PitchPlaceholder extends StatelessWidget {
  const PitchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final g = context.gradients;
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: g.pitch),
        child: CustomPaint(
          painter: _PitchLinesPainter(g.onHero.withOpacity(0.12)),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _PitchLinesPainter extends CustomPainter {
  const _PitchLinesPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final inset = math.min(size.width, size.height) * 0.12;
    final field = Rect.fromLTRB(
      inset,
      inset,
      size.width - inset,
      size.height - inset,
    );
    final cx = field.center.dx;
    final radius = field.height * 0.18;
    canvas
      ..drawRect(field, paint)
      ..drawLine(Offset(cx, field.top), Offset(cx, field.bottom), paint)
      ..drawCircle(field.center, radius, paint);
    // Penalty arcs at both ends.
    final arc = field.height * 0.3;
    canvas
      ..drawArc(
        Rect.fromCircle(center: Offset(field.left, field.center.dy), radius: arc),
        -math.pi / 2,
        math.pi,
        false,
        paint,
      )
      ..drawArc(
        Rect.fromCircle(center: Offset(field.right, field.center.dy), radius: arc),
        math.pi / 2,
        math.pi,
        false,
        paint,
      );
  }

  @override
  bool shouldRepaint(_PitchLinesPainter oldDelegate) =>
      oldDelegate.color != color;
}
