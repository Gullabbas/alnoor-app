import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/health_card_widget.dart';
import '../../../data/repositories/auth_repository.dart';

class HealthCardsScreen extends ConsumerStatefulWidget {
  const HealthCardsScreen({super.key});

  @override
  ConsumerState<HealthCardsScreen> createState() => _HealthCardsScreenState();
}

class _HealthCardsScreenState extends ConsumerState<HealthCardsScreen> {
  HealthCardTier _selectedTier = HealthCardTier.gold;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Al Noor Health Cards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tier Selector Pills
            Row(
              children: HealthCardTier.values.map((tier) {
                final isSelected = tier == _selectedTier;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(
                        child: Text(
                          tier.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.ink),
                          ),
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedTier = tier),
                      selectedColor: AppColors.brandRed,
                      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 3D Perspective Tilt Card
            HealthCardWidget(
              tier: _selectedTier,
              holderName: user?.fullName ?? 'Ahmed Raza',
              cardNumber: user?.healthCardNumber ?? '2557 0001 6257 7360',
              expiry: '12/28',
              points: user?.healthPoints ?? 1250,
            ),
            const SizedBox(height: 24),

            // Benefits Breakdown
            Text(
              'Benefits on ${_selectedTier.title}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            _benefitRow('50% Off on Screening Mammogram', isDark),
            _benefitRow('50% Off on Vitamin D 25-OH Testing', isDark),
            _benefitRow('35% Off on Executive Health Screening Packages', isDark),
            _benefitRow('25% Off on All Routine & Special Pathology Blood Tests', isDark),
            _benefitRow('20% Off on 128-Slice MDCT & Open MRI Scans', isDark),
            _benefitRow('15% Off on Consultant Doctor Telemedicine Consultations', isDark),
            _benefitRow('Free Priority Home Phlebotomy Sampling across Lahore', isDark),
            const SizedBox(height: 20),

            // Rewards & Points
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.brandCopper.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.loyalty_rounded, color: AppColors.brandCopper, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Accrued Points: ${user?.healthPoints ?? 1250} pts',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Every 100 points = PKR 100 redemption credit at checkout.',
                          style: TextStyle(fontSize: 11, color: AppColors.inkSoft),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefitRow(String text, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.brandRed, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
