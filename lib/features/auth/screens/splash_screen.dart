import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/account_copy.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_brand.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/widgets/error_view.dart';
import '../../../data/vos/auth_session.dart';
import '../providers/auth_session_provider.dart';
import '../providers/sign_out_controller.dart';
import '../providers/splash_intro_provider.dart';

/// `/splash` — animated brand intro, shown while the session resolves (auth
/// state, `users/{uid}` profile, re-creating a missing profile).
///
/// The emblem fades in without its light arcs and swoosh, then the ball
/// enters on the light arcs at the right, rides them down, crosses behind the emblem and
/// runs the swoosh ray (from its tip, around the lower left and up) with a
/// comet light trail, drawing the arcs and swoosh in behind it; it hits its spot with a flash
/// and the wordmark slides up. A constellation background (from the logo
/// artwork) drifts behind and a light shine sweeps the emblem afterwards.
///
/// The router holds here until the intro ends ([splashIntroDoneProvider]);
/// a slim progress bar appears only if the session is still loading after
/// that, plus "Setting up your account…" after 3s. On [SessionError] it
/// shows "We couldn't load your account" with "Try again" / "Sign out"
/// (design_system.md §8.3).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentAuthSessionProvider);
    if (session is SessionError) {
      return _SessionErrorView(session: session);
    }
    return const _AnimatedSplash();
  }
}

class _AnimatedSplash extends ConsumerStatefulWidget {
  const _AnimatedSplash();

  @override
  ConsumerState<_AnimatedSplash> createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends ConsumerState<_AnimatedSplash>
    with TickerProviderStateMixin {
  static const String _tagline = 'Book your court in seconds';
  static const String _setupCaption = 'Setting up your account…';
  static const double _logoSize = 180;
  static const double _progressWidth = 120;

  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: AppConstants.splashIntroDuration,
  );
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: AppConstants.splashAmbientLoop,
  );

  late final Animation<double> _title = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.62, 0.88, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _tag = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.72, 0.98, curve: Curves.easeOutCubic),
  );

  Timer? _captionTimer;
  bool _introDone = false;
  bool _showCaption = false;

  @override
  void initState() {
    super.initState();
    _intro.addStatusListener((status) {
      if (status == AnimationStatus.completed) _finishIntro();
    });
    _captionTimer = Timer(AppConstants.splashCaptionDelay, () {
      if (mounted) setState(() => _showCaption = true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      // Reduce motion: final frame, no hold, no ambient loop.
      _ambient.stop();
      _intro.value = 1;
      _finishIntro();
    } else if (!_intro.isAnimating && _intro.value == 0) {
      _intro.forward();
      _ambient.repeat();
    }
  }

  void _finishIntro() {
    if (_introDone) return;
    _introDone = true;
    // Post-frame: completing may make the router navigate away.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {});
      ref.read(splashIntroDoneProvider.notifier).complete();
    });
  }

  @override
  void dispose() {
    _captionTimer?.cancel();
    _intro.dispose();
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppBrand.navy,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppBrand.background),
          child: Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(
                child: CustomPaint(
                  painter: _ConstellationPainter(
                    drift: _ambient,
                    reveal: _intro,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    _LogoStage(
                      intro: _intro,
                      ambient: _ambient,
                      logoSize: _logoSize,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _slideFade(
                      _title,
                      Semantics(
                        header: true,
                        label: AppConstants.appName,
                        excludeSemantics: true,
                        child: _Wordmark(textTheme: text),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _slideFade(
                      _tag,
                      Text(
                        _tagline,
                        textAlign: TextAlign.center,
                        style: text.bodyMedium?.copyWith(
                          color: AppBrand.onNavyMuted,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const Spacer(flex: 4),
                    _buildProgress(text),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slideFade(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.6),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  /// Visible only after the intro, i.e. while the session is still loading.
  Widget _buildProgress(TextTheme text) {
    final captionHeight = (text.bodySmall?.fontSize ?? 12) * 1.6;
    return AnimatedOpacity(
      opacity: _introDone ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _progressWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.refreshBarHeight),
              child: const LinearProgressIndicator(
                minHeight: AppSizes.refreshBarHeight,
                color: AppBrand.gold,
                backgroundColor: AppBrand.navyLight,
                semanticsLabel: 'Loading your account',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: captionHeight,
            child: _showCaption && _introDone
                ? Text(
                    _setupCaption,
                    textAlign: TextAlign.center,
                    style:
                        text.bodySmall?.copyWith(color: AppBrand.onNavyMuted),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

/// Emblem + the ball shot along the swoosh, with trail, impact flash, orbit
/// ring and light shine. All positions are fractions of [logoSize] so the
/// ball lands exactly on its spot in the artwork.
class _LogoStage extends StatelessWidget {
  const _LogoStage({
    required this.intro,
    required this.ambient,
    required this.logoSize,
  });

  // Intro timeline (fractions of the intro controller).
  static const Interval _emblemIn = Interval(0, 0.3, curve: Curves.easeOutBack);
  static const Interval _emblemFade = Interval(0, 0.22, curve: Curves.easeOut);
  static const Interval _flight =
      Interval(0.1, 0.58, curve: Curves.easeInOutCubic);
  static const double _landAt = 0.58;

  /// Part of the flight over which the ball fades in on the right arcs.
  static const double _ballFadeIn = 0.06;

  /// The swoosh is revealed this far (path fraction) behind the ball, so it
  /// appears in its wake, never ahead of it; it completes on landing.
  static const double _revealLag = 0.1;

  /// Half-width of the swoosh reveal band around the path (fraction of the
  /// logo size); wide enough to cover every arc and streak of the swoosh.
  static const double revealRadius = 0.12;
  static const Interval _impact = Interval(0.58, 0.82, curve: Curves.easeOut);
  static const Interval _settleWindow = Interval(0.58, 0.8);
  static const Interval _ring =
      Interval(0.5, 0.85, curve: Curves.easeOutCubic);

  /// Ball pops on impact, then springs back to its artwork size.
  static final Animatable<double> _settle = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.16), weight: 30),
    TweenSequenceItem(
      tween: Tween<double>(begin: 1.16, end: 1)
          .chain(CurveTween(curve: Curves.elasticOut)),
      weight: 70,
    ),
  ]);

  final Animation<double> intro;
  final Animation<double> ambient;
  final double logoSize;

  /// Stage is larger than the logo so the halo / ring have room.
  static const double _stageFactor = 1.6;

  /// Ball center and diameter in logo_emblem.png (fractions of its width).
  static const Offset ballCenter = Offset(0.6217, 0.4219);
  static const double ballDiameter = 0.1953;

  /// The ball's path, traced from logo_mark.png (fractions of the logo
  /// size, logo top-left = 0,0): in on the light arcs at the right edge,
  /// down them, across behind the emblem to the swoosh's gold tip at the
  /// left, then along the swoosh ray — down and around the left side, along
  /// the bottom, up-right through the streaks into the ball's spot. First
  /// and last points are Catmull-Rom guides only (start / end direction).
  static const List<Offset> _swoosh = [
    Offset(0.79, 0.28), // guide
    Offset(0.825, 0.34), // right arcs, top
    Offset(0.865, 0.41),
    Offset(0.848, 0.48),
    Offset(0.80, 0.53),
    Offset(0.70, 0.575), // right arcs end (inner tip)
    Offset(0.57, 0.605), // behind the emblem
    Offset(0.42, 0.58),
    Offset(0.28, 0.52),
    Offset(0.20, 0.47),
    Offset(0.155, 0.49), // gold tip (swoosh ray starts)
    Offset(0.12, 0.55),
    Offset(0.11, 0.60),
    Offset(0.14, 0.66),
    Offset(0.22, 0.70),
    Offset(0.31, 0.71),
    Offset(0.40, 0.68),
    Offset(0.46, 0.62),
    Offset(0.52, 0.555),
    Offset(0.57, 0.50),
    ballCenter,
    Offset(0.66, 0.36), // guide
  ];

  /// Indices in [_swoosh] of the right arcs' end and of the gold tip,
  /// where the swoosh ray starts.
  static const int _arcsEndIndex = 5;
  static const int _tipIndex = 10;

  /// Ball scale as it enters on the right arcs, shrinking to [launchScale]
  /// at the tip (far side of the orbit), then growing to 1 on landing.
  static const double entryScale = 0.75;
  static const double launchScale = 0.45;

  /// How much the ball dims while it crosses behind the emblem.
  static const double _behindDim = 0.45;

  static const int _samplesPerSegment = 24;

  /// Swoosh sampled densely, with normalized cumulative arc length, so the
  /// ball moves at an even speed along the curve.
  static final ({
    List<Offset> points,
    List<double> lengths,
    double arcsEnd,
    double tip,
  }) _path = () {
    final points = <Offset>[];
    for (var i = 1; i < _swoosh.length - 2; i++) {
      final p0 = _swoosh[i - 1], p1 = _swoosh[i];
      final p2 = _swoosh[i + 1], p3 = _swoosh[i + 2];
      for (var s = 0; s < _samplesPerSegment; s++) {
        final u = s / _samplesPerSegment;
        final u2 = u * u, u3 = u2 * u;
        points.add(
          (p1 * 2 +
                  (p2 - p0) * u +
                  (p0 * 2 - p1 * 5 + p2 * 4 - p3) * u2 +
                  (p1 * 3 - p0 - p2 * 3 + p3) * u3) *
              0.5,
        );
      }
    }
    points.add(_swoosh[_swoosh.length - 2]);

    final lengths = <double>[0];
    for (var i = 1; i < points.length; i++) {
      lengths.add(lengths.last + (points[i] - points[i - 1]).distance);
    }
    final total = lengths.last;
    return (
      points: points,
      lengths: [for (final l in lengths) l / total],
      arcsEnd: lengths[(_arcsEndIndex - 1) * _samplesPerSegment] / total,
      tip: lengths[(_tipIndex - 1) * _samplesPerSegment] / total,
    );
  }();

  /// Path fraction of the swoosh's gold tip: the swoosh ray is
  /// [tipT]..1, everything before it is the approach from the right.
  static double get tipT => _path.tip;

  /// Path fraction where the ball leaves the right arcs (0..[arcsEndT]).
  static double get arcsEndT => _path.arcsEnd;

  /// Point on the path at [t] (0 = right arcs, 1 = ball spot) by arc length.
  static Offset pathAt(double t) {
    final points = _path.points;
    final lengths = _path.lengths;
    if (t <= 0) return points.first;
    if (t >= 1) return points.last;
    var lo = 0, hi = lengths.length - 1;
    while (hi - lo > 1) {
      final mid = (lo + hi) >> 1;
      if (lengths[mid] <= t) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    final span = lengths[hi] - lengths[lo];
    final f = span == 0 ? 0.0 : (t - lengths[lo]) / span;
    return Offset.lerp(points[lo], points[hi], f)!;
  }

  static double scaleAt(double t) {
    final tip = tipT;
    if (t < tip) return entryScale + (launchScale - entryScale) * t / tip;
    return launchScale + (1 - launchScale) * (t - tip) / (1 - tip);
  }

  /// Ball opacity factor: dimmed mid-way across the back of the orbit.
  static double depthAt(double t) {
    final tip = tipT;
    if (t >= tip) return 1;
    return 1 - _behindDim * math.sin(math.pi * t / tip);
  }

  @override
  Widget build(BuildContext context) {
    final stage = logoSize * _stageFactor;
    final origin = Offset((stage - logoSize) / 2, (stage - logoSize) / 2);

    return SizedBox.square(
      dimension: stage,
      child: AnimatedBuilder(
        animation: Listenable.merge([intro, ambient]),
        builder: (context, _) {
          final t = intro.value;
          final emblemIn = _emblemIn.transform(t);
          final emblemFade = _emblemFade.transform(t);
          final ring = _ring.transform(t);
          final flight = _flight.transform(t);
          final landed = t >= _landAt;
          final reveal =
              (flight * (1 + _revealLag) - _revealLag).clamp(0.0, 1.0);
          final impact = landed ? _impact.transform(t) : 0.0;
          final flash = landed ? 1 - impact : 0.0;
          final wave = 0.5 + 0.5 * math.sin(ambient.value * 2 * math.pi);
          final pulse = wave * ring;

          final ballPos = origin + pathAt(flight) * logoSize;
          final ballSize = logoSize *
              ballDiameter *
              (landed
                  ? _settle.transform(_settleWindow.transform(t))
                  : scaleAt(flight));

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Halo; flares on impact, then breathes.
              Opacity(
                opacity: emblemFade,
                child: Container(
                  width: logoSize * (1 + 0.2 * ring),
                  height: logoSize * (1 + 0.2 * ring),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppBrand.gold.withOpacity(
                          (0.12 + 0.12 * pulse + 0.35 * flash).clamp(0.0, 1.0),
                        ),
                        blurRadius: 60 + 24 * pulse + 30 * flash,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: AppBrand.blue.withOpacity(0.22),
                        blurRadius: 90,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                size: Size.square(logoSize * 1.42),
                painter: _OrbitPainter(
                  progress: ring,
                  rotation: ambient.value,
                ),
              ),
              // Emblem, plus the swoosh drawn in behind the ball, with a
              // periodic light shine.
              Opacity(
                opacity: emblemFade,
                child: Transform.scale(
                  scale: 0.6 + 0.4 * emblemIn,
                  child: _Shine(
                    progress: ambient.value,
                    strength: ring,
                    child: SizedBox.square(
                      dimension: logoSize,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            AppAssets.logoEmblem,
                            filterQuality: FilterQuality.medium,
                            excludeFromSemantics: true,
                          ),
                          // Light arcs (right) and swoosh ray (left), each
                          // shown only where the ball has already passed.
                          if (reveal > 0)
                            ClipPath(
                              clipper: _PathRevealClipper(
                                from: 0,
                                to: math.min(reveal, arcsEndT),
                              ),
                              child: Image.asset(
                                AppAssets.logoArcs,
                                filterQuality: FilterQuality.medium,
                                excludeFromSemantics: true,
                              ),
                            ),
                          if (reveal > tipT)
                            ClipPath(
                              clipper: _PathRevealClipper(from: tipT, to: reveal),
                              child: Image.asset(
                                AppAssets.logoSwoosh,
                                filterQuality: FilterQuality.medium,
                                excludeFromSemantics: true,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Comet trail + impact burst (painted beyond the stage).
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _ShotPainter(
                      flight: flight,
                      impact: impact,
                      landed: landed,
                      origin: origin,
                      logoSize: logoSize,
                    ),
                  ),
                ),
              ),
              if (flight > 0)
                Positioned(
                  left: ballPos.dx - ballSize / 2,
                  top: ballPos.dy - ballSize / 2,
                  width: ballSize,
                  height: ballSize,
                  child: Opacity(
                    opacity: (flight / _ballFadeIn).clamp(0.0, 1.0) *
                        depthAt(flight),
                    child: _Ball(
                      // Two full forward turns; ends upright.
                      turns: flight * 2,
                      glow: landed ? 0.35 + 0.3 * wave + 0.6 * flash : 1.0,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Band along the ball's path between the path fractions [from] and [to]:
/// a union of circles, so only the part the ball has passed is visible.
class _PathRevealClipper extends CustomClipper<Path> {
  _PathRevealClipper({required this.from, required this.to});

  final double from;
  final double to;

  static const int _steps = 60;

  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.width * _LogoStage.revealRadius;
    for (var i = 0; i <= _steps; i++) {
      final point = _LogoStage.pathAt(from + (to - from) * i / _steps);
      path.addOval(
        Rect.fromCircle(
          center: point.scale(size.width, size.height),
          radius: radius,
        ),
      );
    }
    return path;
  }

  @override
  bool shouldReclip(_PathRevealClipper old) =>
      old.from != from || old.to != to;
}

class _Ball extends StatelessWidget {
  const _Ball({required this.turns, required this.glow});

  final double turns;

  /// 0–1+: strength of the light around the ball.
  final double glow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppBrand.goldLight.withOpacity((0.45 * glow).clamp(0.0, 1.0)),
            blurRadius: 18,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppBrand.blueLight.withOpacity((0.35 * glow).clamp(0.0, 1.0)),
            blurRadius: 36,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Transform.rotate(
        angle: turns * 2 * math.pi,
        child: Image.asset(
          AppAssets.logoBall,
          filterQuality: FilterQuality.medium,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}

/// Diagonal light band sweeping across [child] during the first part of
/// every ambient loop.
class _Shine extends StatelessWidget {
  const _Shine({
    required this.progress,
    required this.strength,
    required this.child,
  });

  final double progress;
  final double strength;
  final Widget child;

  static const double _activePart = 0.45;
  static const double _bandHalfWidth = 0.12;

  @override
  Widget build(BuildContext context) {
    // Always wrapped (idle = transparent band) so the child isn't rebuilt.
    final t = (progress / _activePart).clamp(0.0, 1.0);
    final alpha = t < 1 ? 0.45 * strength : 0.0;
    // Band center travels from before the top-left to past the bottom-right.
    final c = -0.2 + 1.4 * t;
    double stop(double v) => v.clamp(0.0, 1.0);
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          AppBrand.goldLight.withOpacity(alpha),
          Colors.transparent,
        ],
        stops: [
          stop(c - _bandHalfWidth),
          stop(c),
          stop(c + _bandHalfWidth),
        ],
      ).createShader(bounds),
      child: child,
    );
  }
}

/// Comet light trail behind the flying ball and the impact burst on landing.
class _ShotPainter extends CustomPainter {
  _ShotPainter({
    required this.flight,
    required this.impact,
    required this.landed,
    required this.origin,
    required this.logoSize,
  });

  final double flight;
  final double impact;
  final bool landed;
  final Offset origin;
  final double logoSize;

  static const int _trailSamples = 28;
  static const double _trailLength = 0.3;

  Offset _at(double t) => origin + _LogoStage.pathAt(t) * logoSize;

  @override
  void paint(Canvas canvas, Size size) {
    final ballRadius = logoSize * _LogoStage.ballDiameter / 2;
    if (flight > 0) _paintTrail(canvas, ballRadius);
    if (landed && impact < 1) _paintImpact(canvas, ballRadius);
  }

  void _paintTrail(Canvas canvas, double ballRadius) {
    // After landing the trail shrinks into the ball.
    final fade = landed ? (1 - impact * 2).clamp(0.0, 1.0) : 1.0;
    if (fade <= 0) return;
    final length = _trailLength * fade;

    final glow = Paint()
      ..blendMode = BlendMode.plus
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final core = Paint()
      ..blendMode = BlendMode.plus
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset? previous;
    for (var i = _trailSamples; i >= 0; i--) {
      final k = i / _trailSamples; // 0 = head, 1 = tail end
      final t = flight - length * k;
      if (t < 0) continue;
      final p = _at(t);
      final r = ballRadius * _LogoStage.scaleAt(t) * (1 - k);
      final a =
          math.pow(1 - k, 1.6).toDouble() * fade * _LogoStage.depthAt(t);

      glow.color = Color.lerp(AppBrand.goldLight, AppBrand.blue, k)!
          .withOpacity(0.5 * a);
      canvas.drawCircle(p, r * 1.1, glow);

      if (previous != null) {
        core
          ..strokeWidth = math.max(1.0, r * 0.55)
          ..color = Color.lerp(Colors.white, AppBrand.gold, k)!
              .withOpacity(0.7 * a);
        canvas.drawLine(previous, p, core);
      }
      previous = p;
    }
  }

  void _paintImpact(Canvas canvas, double ballRadius) {
    final center = _at(1);
    final fade = 1 - impact;

    // Light burst.
    final burstRadius = ballRadius * (2 + 2.5 * impact);
    canvas.drawCircle(
      center,
      burstRadius,
      Paint()
        ..blendMode = BlendMode.plus
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.85 * fade * fade),
            AppBrand.gold.withOpacity(0.45 * fade),
            AppBrand.gold.withOpacity(0),
          ],
          stops: const [0, 0.35, 1],
        ).createShader(Rect.fromCircle(center: center, radius: burstRadius)),
    );

    // Shock ring.
    canvas.drawCircle(
      center,
      ballRadius * (1.1 + 2.6 * impact),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * fade + 0.5
        ..color = AppBrand.goldLight.withOpacity(0.9 * fade),
    );

    // Light rays.
    const rays = 10;
    final ray = Paint()
      ..blendMode = BlendMode.plus
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    for (var i = 0; i < rays; i++) {
      final angle = i * 2 * math.pi / rays + 0.3;
      final dir = Offset(math.cos(angle), math.sin(angle));
      final long = i.isEven;
      final inner = ballRadius * (1.2 + 0.6 * impact);
      final outer = ballRadius * (1.4 + (long ? 3.4 : 2.2) * impact);
      ray
        ..strokeWidth = long ? 2.2 : 1.4
        ..color = (long ? AppBrand.goldLight : AppBrand.blueLight)
            .withOpacity(0.85 * fade);
      canvas.drawLine(center + dir * inner, center + dir * outer, ray);
    }
  }

  @override
  bool shouldRepaint(_ShotPainter old) =>
      old.flight != flight ||
      old.impact != impact ||
      old.landed != landed ||
      old.logoSize != logoSize;
}

/// "FUTSAL" in a gold gradient over a lighter "BOOKING".
class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: AppBrand.goldText.createShader,
          child: Text(
            'FUTSAL',
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 10,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'BOOKING',
          style: textTheme.titleSmall?.copyWith(
            color: AppBrand.onNavy,
            fontWeight: FontWeight.w600,
            letterSpacing: 8,
          ),
        ),
      ],
    );
  }
}

/// Gold arc that draws itself around the logo, then slowly rotates.
class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.progress, required this.rotation});

  final double progress;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2 - 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 2 * math.pi);
    canvas.translate(-center.dx, -center.dy);

    final sweep = 2 * math.pi * 0.72 * progress;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [AppBrand.gold.withOpacity(0), AppBrand.goldLight],
        endAngle: sweep,
      ).createShader(rect);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      sweep,
      false,
      arc,
    );

    // Spark at the head of the arc.
    final head = center + Offset(math.cos(sweep), math.sin(sweep)) * radius;
    canvas.drawCircle(
      head,
      8,
      Paint()
        ..color = AppBrand.gold.withOpacity(0.35 * progress)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(
      head,
      3,
      Paint()..color = AppBrand.goldLight.withOpacity(progress),
    );

    // Thin inner blue ring.
    canvas.drawCircle(
      center,
      radius - 12,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppBrand.blueLight.withOpacity(0.15 * progress),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.progress != progress || old.rotation != rotation;
}

/// Drifting, twinkling constellation of gold / blue nodes (echoes the logo
/// artwork's background).
class _ConstellationPainter extends CustomPainter {
  _ConstellationPainter({required this.drift, required this.reveal})
      : super(repaint: Listenable.merge([drift, reveal]));

  final Animation<double> drift;

  /// Intro progress; the constellation fades in over its first fifth.
  final Animation<double> reveal;

  static const int _nodeCount = 34;
  static const double _linkDistance = 0.22;
  static const double _driftAmount = 0.012;
  static const double _revealPart = 0.2;

  // Fixed seed: same layout on every launch.
  static final List<_Node> _nodes = () {
    final random = math.Random(7);
    return List.generate(_nodeCount, (i) {
      return _Node(
        x: random.nextDouble(),
        y: random.nextDouble(),
        phase: random.nextDouble() * 2 * math.pi,
        gold: i.isEven,
        radius: 1.2 + random.nextDouble() * 1.8,
      );
    });
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = (reveal.value / _revealPart).clamp(0.0, 1.0);
    if (alpha <= 0) return;
    final t = drift.value * 2 * math.pi;

    final points = [
      for (final n in _nodes)
        Offset(
          (n.x + _driftAmount * math.sin(t + n.phase)) * size.width,
          (n.y + _driftAmount * math.cos(t + n.phase)) * size.height,
        ),
    ];

    final line = Paint()..strokeWidth = 0.6;
    final maxDist = _linkDistance * size.shortestSide;
    for (var i = 0; i < points.length; i++) {
      for (var j = i + 1; j < points.length; j++) {
        final d = (points[i] - points[j]).distance;
        if (d > maxDist) continue;
        final strength = 1 - d / maxDist;
        line.color = (_nodes[i].gold ? AppBrand.gold : AppBrand.blueLight)
            .withOpacity(0.18 * strength * alpha);
        canvas.drawLine(points[i], points[j], line);
      }
    }

    final dot = Paint();
    final glow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    for (var i = 0; i < points.length; i++) {
      final n = _nodes[i];
      final twinkle = 0.55 + 0.45 * math.sin(t * 2 + n.phase);
      final color = n.gold ? AppBrand.goldLight : AppBrand.blueLight;
      glow.color = color.withOpacity(0.35 * twinkle * alpha);
      canvas.drawCircle(points[i], n.radius * 3, glow);
      dot.color = color.withOpacity(0.9 * twinkle * alpha);
      canvas.drawCircle(points[i], n.radius, dot);
    }
  }

  // Repaints via the `repaint` listenable.
  @override
  bool shouldRepaint(_ConstellationPainter old) => false;
}

class _Node {
  const _Node({
    required this.x,
    required this.y,
    required this.phase,
    required this.gold,
    required this.radius,
  });

  final double x;
  final double y;
  final double phase;
  final bool gold;
  final double radius;
}

class _SessionErrorView extends ConsumerWidget {
  const _SessionErrorView({required this.session});

  final SessionError session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retrying = ref.watch(authSessionProvider).isLoading;
    final signingOut = ref.watch(signOutControllerProvider).isLoading;
    final busy = retrying || signingOut;
    final title = switch (session.failure) {
      SessionFailure.unrecognizedRole ||
      SessionFailure.accountDisabled =>
        AccountCopy.unavailableTitle,
      SessionFailure.timeout ||
      SessionFailure.setupFailed ||
      SessionFailure.loadFailed =>
        "We couldn't load your account",
    };

    return Scaffold(
      body: SafeArea(
        child: ErrorView(
          error: session.error,
          title: title,
          // Retry re-subscribes the session stream: fresh token + profile.
          onRetry: session.failure.canRetry && !busy
              ? () => ref.invalidate(authSessionProvider)
              : null,
          secondaryActionLabel: 'Sign out',
          onSecondaryAction: busy
              ? null
              : () => ref.read(signOutControllerProvider.notifier).signOut(),
        ),
      ),
    );
  }
}
