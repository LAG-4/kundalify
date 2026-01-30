import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_scaffold.dart';

const List<String> _loadingMessages = <String>[
  'Aligning the cosmos...',
  'Calculating planetary positions...',
  'Consulting the ephemeris...',
  'Mapping the 12 houses...',
  'Interpreting celestial patterns...',
];

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _outerRingController;
  late final AnimationController _innerRingController;
  late final AnimationController _spinnerController;
  late final AnimationController _pulseController;
  Timer? _timer;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _outerRingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _innerRingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!mounted) return;
      setState(
        () => _messageIndex = (_messageIndex + 1) % _loadingMessages.length,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _spinnerController.dispose();
    _innerRingController.dispose();
    _outerRingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CosmicScaffold(
      decorations: <Widget>[
        Opacity(
          opacity: 0.20,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _Rotating(
                  controller: _outerRingController,
                  reverse: false,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.mysticGold.withValues(alpha: 0.30),
                      ),
                    ),
                  ),
                ),
                _Rotating(
                  controller: _innerRingController,
                  reverse: true,
                  child: CustomPaint(
                    size: const Size(350, 350),
                    painter: _DashedCirclePainter(
                      color: AppColors.mysticPurple.withValues(alpha: 0.40),
                      strokeWidth: 1,
                      dashLength: 8,
                      dashGap: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      _Rotating(
                        controller: _spinnerController,
                        reverse: false,
                        child: CustomPaint(
                          size: const Size(96, 96),
                          painter: _ArcPainter(
                            color: AppColors.mysticGold,
                            strokeWidth: 2,
                            startAngle: math.pi,
                            sweepAngle: math.pi,
                          ),
                        ),
                      ),
                      _Rotating(
                        controller: _spinnerController,
                        reverse: true,
                        child: CustomPaint(
                          size: const Size(80, 80),
                          painter: _ArcPainter(
                            color: AppColors.mysticPurple,
                            strokeWidth: 2,
                            startAngle: -math.pi / 2,
                            sweepAngle: math.pi,
                          ),
                        ),
                      ),
                      Text(
                        '🕉️',
                        style: GoogleFonts.cinzel(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                FadeTransition(
                  opacity: Tween<double>(begin: 0.65, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _pulseController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Text(
                    'Generating Chart',
                    style: GoogleFonts.cinzel(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 32,
                  width: 320,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 0.25),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      _loadingMessages[_messageIndex],
                      key: ValueKey<int>(_messageIndex),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: AppColors.slate400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Rotating extends StatelessWidget {
  const _Rotating({
    required this.controller,
    required this.child,
    required this.reverse,
  });

  final Animation<double> controller;
  final Widget child;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        final turns = controller.value;
        final direction = reverse ? -1.0 : 1.0;
        return Transform.rotate(
          angle: 2 * math.pi * turns * direction,
          child: child,
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.color,
    required this.strokeWidth,
    required this.startAngle,
    required this.sweepAngle,
  });

  final Color color;
  final double strokeWidth;
  final double startAngle;
  final double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle;
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashGap,
  });

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final rect = Offset.zero & size;
    final path = Path()..addOval(rect.deflate(strokeWidth / 2));
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + dashLength, metric.length);
        final segment = metric.extractPath(distance, next);
        canvas.drawPath(segment, paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.dashGap != dashGap;
  }
}
