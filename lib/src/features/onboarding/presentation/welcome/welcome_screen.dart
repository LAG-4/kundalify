import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_primary_button.dart';
import '../../../../core/widgets/cosmic_scaffold.dart';
import '../../../../core/widgets/glass_circle.dart';
import '../../../../core/widgets/gradient_text.dart';
import '../../../../core/widgets/lucide_icon.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _floatController;
  late final AnimationController _ringsController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _ringsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    _ringsController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize = size.width < 360
        ? 46.0
        : size.width < 480
        ? 54.0
        : 64.0;

    final fade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(fade);

    return CosmicScaffold(
      decorations: <Widget>[
        // Ambient stars
        Positioned(
          top: 80,
          left: 40,
          child: _PulsingSvgIcon(
            controller: _pulseController,
            phase: 0.0,
            opacity: 0.50,
            icon: const LucideIcon(
              icon: LucideAsset.star,
              size: 16,
              color: AppColors.mysticGold,
            ),
          ),
        ),
        Positioned(
          top: 160,
          right: 80,
          child: _PulsingSvgIcon(
            controller: _pulseController,
            phase: 0.20,
            opacity: 0.30,
            icon: const LucideIcon(
              icon: LucideAsset.star,
              size: 24,
              color: AppColors.mysticPurple,
            ),
          ),
        ),
        Positioned(
          bottom: 128,
          left: size.width * 0.25,
          child: _PulsingSvgIcon(
            controller: _pulseController,
            phase: 0.12,
            opacity: 0.40,
            icon: const LucideIcon(
              icon: LucideAsset.star,
              size: 12,
              color: Colors.white,
            ),
          ),
        ),

        // Spinning rings
        Center(
          child: _SpinningRing(
            controller: _ringsController,
            size: 600,
            borderColor: Colors.white.withValues(alpha: 0.05),
            reverse: false,
            phase: 0.0,
          ),
        ),
        Center(
          child: _SpinningRing(
            controller: _ringsController,
            size: 400,
            borderColor: Colors.white.withValues(alpha: 0.10),
            reverse: true,
            phase: 0.10,
          ),
        ),
      ],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final dy = Tween<double>(begin: 0, end: -10).evaluate(
                            CurvedAnimation(
                              parent: _floatController,
                              curve: Curves.easeInOut,
                            ),
                          );
                          return Transform.translate(
                            offset: Offset(0, dy),
                            child: child,
                          );
                        },
                        child: GlassCircle(
                          padding: const EdgeInsets.all(12),
                          blurSigma: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          borderColor: Colors.white.withValues(alpha: 0.10),
                          child: const LucideIcon(
                            icon: LucideAsset.sparkles,
                            size: 32,
                            color: AppColors.mysticGold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GradientText(
                        'Cosmic Kundali',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        gradient: const LinearGradient(
                          colors: <Color>[
                            AppColors.mysticGold,
                            AppColors.vedicCream,
                            AppColors.mysticGold,
                          ],
                        ),
                        style: GoogleFonts.cinzel(
                          fontSize: headingSize,
                          height: 0.98,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.8,
                          shadows: <Shadow>[
                            Shadow(
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                              color: Colors.black.withValues(alpha: 0.25),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Discover Your Cosmic Blueprint',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          height: 1.3,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.4,
                          color: AppColors.slate300,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 1,
                        width: 96,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.30),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Unlock the wisdom of the stars with our precision-crafted North Indian birth chart generator. Blending ancient Vedic tradition with modern elegance.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          height: 1.6,
                          fontWeight: FontWeight.w300,
                          color: AppColors.slate400,
                        ),
                      ),
                      const SizedBox(height: 32),
                      DefaultTextStyle(
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                          color: Colors.white,
                        ),
                        child: CosmicPrimaryButton(
                          label: 'Get Started',
                          onPressed: widget.onStart,
                          trailing: const LucideIcon(
                            icon: LucideAsset.arrowRight,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpinningRing extends StatelessWidget {
  const _SpinningRing({
    required this.controller,
    required this.size,
    required this.borderColor,
    required this.reverse,
    required this.phase,
  });

  final Animation<double> controller;
  final double size;
  final Color borderColor;
  final bool reverse;
  final double phase;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
      ),
      builder: (context, child) {
        final turns = (controller.value + phase) % 1.0;
        final direction = reverse ? -1.0 : 1.0;
        return Transform.rotate(
          angle: 2 * math.pi * turns * direction,
          child: child,
        );
      },
    );
  }
}

class _PulsingSvgIcon extends StatelessWidget {
  const _PulsingSvgIcon({
    required this.controller,
    required this.icon,
    required this.opacity,
    required this.phase,
  });

  final Animation<double> controller;
  final Widget icon;
  final double opacity;
  final double phase;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: icon,
      builder: (context, child) {
        final t = (controller.value + phase) % 1.0;
        final pulse = 0.5 + 0.5 * math.sin(2 * math.pi * t);
        final o = opacity * (0.65 + 0.35 * pulse);
        return Opacity(opacity: o.clamp(0, 1), child: child);
      },
    );
  }
}
