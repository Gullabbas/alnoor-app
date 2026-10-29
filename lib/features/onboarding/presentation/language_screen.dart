import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String _selectedLang = 'en';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandRed.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.translate_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Choose Your Language\nاپنی زبان منتخب کریں',
                textAlign: TextAlign.center,
                style: AppTypography.h1(false, color: isDark ? AppColors.darkText : AppColors.ink),
              ),
              const SizedBox(height: 12),
              Text(
                'You can update your language anytime in Settings\nآپ ترتیبات میں کسی بھی وقت زبان تبدیل کر سکتے ہیں',
                textAlign: TextAlign.center,
                style: AppTypography.body(false, color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft),
              ),
              const SizedBox(height: 40),

              // English Card
              _LanguageCard(
                title: 'English',
                subtitle: 'Better Diagnosis, Healthier Life',
                isSelected: _selectedLang == 'en',
                onTap: () => setState(() => _selectedLang = 'en'),
              ),
              const SizedBox(height: 16),

              // Urdu Card
              _LanguageCard(
                title: 'اردو',
                subtitle: 'بہترین تشخیص، صحت مند زندگی',
                isSelected: _selectedLang == 'ur',
                isUrdu: true,
                onTap: () => setState(() => _selectedLang = 'ur'),
              ),

              const Spacer(flex: 2),

              AppButton(
                text: _selectedLang == 'ur' ? 'آگے بڑھیں' : 'Continue',
                onPressed: () {
                  context.go('/onboarding');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isUrdu;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.isUrdu = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandRed.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isUrdu
                      ? AppTypography.h2(true, color: isDark ? AppColors.darkText : AppColors.ink)
                      : AppTypography.h2(false, color: isDark ? AppColors.darkText : AppColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.caption(
                    isUrdu,
                    color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
                  ),
                ),
              ],
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.brandRed : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.brandRed : AppColors.inkLighter,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
