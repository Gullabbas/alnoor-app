import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileSelectionScreen extends ConsumerStatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  ConsumerState<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends ConsumerState<ProfileSelectionScreen> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authProvider);
    _selectedId = auth.activeProfileId ?? auth.user?.defaultProfileId ?? '';
  }

  void _onProceed() {
    ref.read(authProvider.notifier).switchActiveProfile(_selectedId);
    context.go('/home');
  }

  void _showAddMemberModal() {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    String relation = 'Spouse';
    String gender = 'Female';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1719) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                  top: 24,
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Add Family Member',
                  style: AppTypography.h2(false, color: isDark ? AppColors.darkText : AppColors.ink),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ageCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Age (Years)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: relation,
                        decoration: const InputDecoration(
                          labelText: 'Relation',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Spouse', 'Child', 'Parent', 'Sibling', 'Other']
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (v) => setModalState(() => relation = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: 'Add Member',
                  onPressed: () {
                    if (nameCtrl.text.trim().isNotEmpty) {
                      final age = int.tryParse(ageCtrl.text) ?? 25;
                      ref.read(authProvider.notifier).addFamilyProfile(
                            fullName: nameCtrl.text.trim(),
                            relation: relation,
                            age: age,
                            gender: gender,
                          );
                      Navigator.of(ctx).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profiles = user?.familyProfiles ?? [];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Default Profile Selection',
                style: AppTypography.h1(false, color: isDark ? AppColors.darkText : AppColors.ink),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose who you are booking or viewing reports for. You can easily switch profiles anytime.',
                style: AppTypography.body(false, color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView.separated(
                  itemCount: profiles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    final isSelected = profile.id == _selectedId;

                    return _ProfileCard(
                      profile: profile,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedId = profile.id),
                    );
                  },
                ),
              ),

              OutlinedButton.icon(
                onPressed: _showAddMemberModal,
                icon: const Icon(Icons.add_rounded, color: AppColors.brandRed),
                label: const Text(
                  'Add Another Family Profile',
                  style: TextStyle(
                    color: AppColors.brandRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.brandCopper),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),

              AppButton(
                text: 'Continue to Al Noor',
                onPressed: _onProceed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final FamilyProfile profile;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.profile,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandRed.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Avatar with initials
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppColors.primaryGradient
                    : LinearGradient(
                        colors: [
                          AppColors.brandCopper.withValues(alpha: 0.3),
                          AppColors.brandPeach.withValues(alpha: 0.3),
                        ],
                      ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                profile.initials,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.brandRed,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Profile info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          profile.fullName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkText : AppColors.ink,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.brandPeach.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          profile.relation,
                          style: const TextStyle(
                            color: AppColors.brandRed,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Patient ID: ${profile.patientId}  •  ${profile.age} years  •  ${profile.gender}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),

            // Selection radio check
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.brandRed : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.brandRed : AppColors.inkLighter,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
