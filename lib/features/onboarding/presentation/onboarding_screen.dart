import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Trusted Diagnostic Partner',
      'titleUrdu': 'قابل اعتماد تشخیصی شراکت دار',
      'desc': 'Founded in 1983 by Prof. Dr. Safdar Ali Malik (Tamgha-e-Imtiaz). Over 40 years of precision, high-resolution radiology, and ISO-certified laboratory excellence.',
      'icon': Icons.verified_user_rounded,
      'badge': 'Since 1983 • 1500+ Tests',
    },
    {
      'title': 'Convenient Home Sampling',
      'titleUrdu': 'گھر کی دہلیز پر بااعتماد سیمپلنگ',
      'desc': 'Book blood and urine tests from the comfort of your home. Professional certified phlebotomists with real-time temperature-controlled cold chains.',
      'icon': Icons.moped_rounded,
      'badge': 'Free above PKR 3,000',
    },
    {
      'title': 'Instant Digital Reports',
      'titleUrdu': 'فوری اور محفوظ ڈیجیٹل رپورٹس',
      'desc': 'Access your complete laboratory history, parameter charts, and consultant-signed digital PDF reports anytime, anywhere on your mobile device.',
      'icon': Icons.assignment_turned_in_rounded,
      'badge': 'Historical Trends & Analytics',
    },
    {
      'title': 'Specialists & Live Support',
      'titleUrdu': 'ماہر کنسلٹنٹس اور فوری معاونت',
      'desc': 'Consult leading radiologists, pathologists, and cardiologists via telemedicine. Connect with 8 specialized live support agents 24/7.',
      'icon': Icons.support_agent_rounded,
      'badge': 'Open 9 AM – Midnight',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/branding/logo-alnoor.png',
                    height: 36,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.medical_services_rounded,
                      color: AppColors.brandRed,
                      size: 28,
                    ),
                  ),
                  if (!isLast)
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 3D Visual Hero Bubble
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.brandRedBright.withValues(alpha: 0.15),
                                AppColors.brandCopper.withValues(alpha: 0.05),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.brandCopper.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.brandRed.withValues(alpha: 0.15),
                                blurRadius: 40,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.brandRed.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                slide['icon'] as IconData,
                                color: Colors.white,
                                size: 52,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Badge Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.brandPeach.withValues(alpha: isDark ? 0.2 : 0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.brandCopper.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            slide['badge'] as String,
                            style: const TextStyle(
                              color: AppColors.brandRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Title
                        Text(
                          slide['title'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.h1(
                            false,
                            color: isDark ? AppColors.darkText : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Description
                        Text(
                          slide['desc'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.body(
                            false,
                            color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Row(
                    children: List.generate(_slides.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.brandRed : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Next / Get Started Button
                  AppButton(
                    text: isLast ? 'Get Started' : 'Next',
                    width: isLast ? 160 : 120,
                    height: 48,
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
