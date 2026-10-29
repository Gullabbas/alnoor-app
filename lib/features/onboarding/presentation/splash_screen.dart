import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Timer? _navTimer;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.25, end: 0.65).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _navTimer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C0E),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient gradient 1: Top Burgundy medical glow
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 1.1,
                  colors: [
                    Color(0xFF3D1418),
                    Color(0xFF1A0D10),
                    Color(0xFF0F0C0E),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // Background ambient gradient 2: Bottom subtle gold radiance
          Positioned(
            bottom: -80,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) => Container(
                width: 320,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.brandGold.withValues(alpha: 0.12 * _glowAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Centered Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Animated 3D Floating Medallion Emblem
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulsing Outer Ambient Glow
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.brandRed.withValues(alpha: _glowAnimation.value * 0.5),
                                      AppColors.brandGold.withValues(alpha: _glowAnimation.value * 0.25),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              // Outer Gold Ring
                              Container(
                                width: 136,
                                height: 136,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFF3E5AB),
                                      Color(0xFFD4AF37),
                                      Color(0xFF996515),
                                      Color(0xFFF3E5AB),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      blurRadius: 24,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: AppColors.brandRed.withValues(alpha: 0.35),
                                      blurRadius: 30,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(3.5),
                                // Pristine Pearl White Card inside
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(18),
                                  child: Image.asset(
                                    'assets/branding/logo-alnoor.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.local_hospital_rounded,
                                      color: AppColors.brandRed,
                                      size: 54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Al Noor Brand Titles
                    const Text(
                      'AL NOOR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4.0,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Metallic Gold Pill for Sub-Brand
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.brandCopper.withValues(alpha: 0.25),
                            AppColors.brandGold.withValues(alpha: 0.35),
                            AppColors.brandCopper.withValues(alpha: 0.25),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.brandGold.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'DIAGNOSTIC CENTRE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF3E5AB),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Centered Authentic Urdu Tagline
                    Text(
                      'بہترین تشخیص، صحت مند زندگی',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppTypography.h2(
                        true,
                        color: Colors.white.withValues(alpha: 0.95),
                      ).copyWith(
                        fontSize: 20,
                        shadows: const [
                          Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // English Subtitle
                    Text(
                      'Better Diagnosis, Healthier Life',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Animated Sleek Progress Pulse Bar
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        return Container(
                          width: 120,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Align(
                            alignment: Alignment(-1.0 + (2.0 * _pulseController.value), 0.0),
                            child: Container(
                              width: 44,
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.brandGold,
                                    Colors.white,
                                    AppColors.brandGold,
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.brandGold.withValues(alpha: 0.8),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom ISO trust badge
          Positioned(
            bottom: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: AppColors.brandGold,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Four Decades of Clinical Trust • ISO 15189',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
