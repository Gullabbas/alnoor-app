import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/device_frame.dart';
import '../../../data/repositories/auth_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showFeedbackModal(BuildContext context) {
    int rating = 5;
    final feedbackCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Rate Your Experience'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How satisfied are you with Al Noor Diagnostic Centre?'),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setDialogState(() => rating = i + 1),
                  );
                }),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: feedbackCtrl,
                decoration: const InputDecoration(
                  hintText: 'What can we improve?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandRed),
              onPressed: () {
                Navigator.of(ctx).pop();
                AppToast.show(context, title: 'Feedback Submitted', message: 'Thank you for helping us improve!', type: ToastType.success);
              },
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutAlNoor(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              'assets/branding/logo-alnoor.png',
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.local_hospital_rounded, color: AppColors.brandRed),
            ),
            const SizedBox(width: 8),
            const Text('About Al Noor'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Al Noor Diagnostic Centre (ANDC)',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            SizedBox(height: 6),
            Text(
              'Founded in 1983 by Prof. Dr. Safdar Ali Malik (Tamgha-e-Imtiaz) in Shadman, Lahore. Over 40 years of diagnostic excellence offering 1500+ pathology, molecular, neuro, cardiac, and full-spectrum 128-slice MDCT & MRI imaging under one roof.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            SizedBox(height: 12),
            Text('• ISO Certified Laboratory Standards', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            Text('• Non-Stop Service 9:00 AM – Midnight', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            Text('• UAN: +92 42 111 939 939', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            Text('• Mobile: +92 308 113 9009', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final activeProfile = auth.activeProfile ?? user?.defaultProfile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final desktopTheme = ref.watch(desktopThemeToggleProvider);
    final desktopLocale = ref.watch(desktopLocaleToggleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.brandPeach,
                    child: Text(
                      activeProfile?.initials ?? 'AR',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandRed, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeProfile?.fullName ?? user?.fullName ?? 'Patient',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.phone ?? '0300 1234567',
                          style: const TextStyle(fontSize: 12, color: AppColors.inkSoft, fontFamily: 'monospace'),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${activeProfile?.patientId ?? "ALN-9739698"}',
                          style: const TextStyle(fontSize: 11, color: AppColors.brandRed, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.brandRed),
                    onPressed: () => context.push('/edit-profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Family Profiles Hub
            _settingTile(
              icon: Icons.people_outline_rounded,
              title: 'Family Profiles (${user?.familyProfiles.length ?? 1})',
              subtitle: 'Manage dependants & switch patient',
              onTap: () => context.push('/profile-select'),
              isDark: isDark,
            ),

            // Health Cards
            _settingTile(
              icon: Icons.credit_card_rounded,
              title: 'Al Noor Health Cards',
              subtitle: '${user?.healthCardTier ?? "Gold"} Member • ${user?.healthPoints ?? 1250} pts',
              onTap: () => context.push('/health-cards'),
              isDark: isDark,
            ),

            // Offers & Vouchers
            _settingTile(
              icon: Icons.local_offer_outlined,
              title: 'Offers & Coupons',
              subtitle: 'Discount vouchers and seasonal packages',
              onTap: () => context.push('/offers'),
              isDark: isDark,
            ),

            // Branches & Locations
            _settingTile(
              icon: Icons.location_on_outlined,
              title: 'Branches & Timing',
              subtitle: 'Main Shadman & Lahore collection centers',
              onTap: () => context.push('/branches'),
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // Preferences Section
            const Text('App Preferences', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            // Dark Mode Toggle
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: SwitchListTile(
                title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                subtitle: Text(isDark ? 'Dark Theme Active' : 'Light Theme Active', style: const TextStyle(fontSize: 11)),
                value: desktopTheme == ThemeMode.dark,
                activeThumbColor: AppColors.brandRed,
                onChanged: (val) {
                  ref.read(desktopThemeToggleProvider.notifier).setMode(val ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),

            // Language Switcher Tile
            _settingTile(
              icon: Icons.translate_rounded,
              title: 'Language / زبان',
              subtitle: desktopLocale.languageCode == 'en' ? 'English (Current)' : 'اردو (فعال)',
              onTap: () {
                final newLoc = desktopLocale.languageCode == 'en' ? const Locale('ur') : const Locale('en');
                ref.read(desktopLocaleToggleProvider.notifier).setLocale(newLoc);
                AppToast.show(
                  context,
                  title: newLoc.languageCode == 'ur' ? 'اردو زبان منتخب کی گئی' : 'English Selected',
                  type: ToastType.info,
                );
              },
              isDark: isDark,
            ),

            // Biometric Unlock Toggle
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: SwitchListTile(
                title: const Text('Biometric / Face ID Unlock', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                subtitle: const Text('Fast biometric login on start', style: TextStyle(fontSize: 11)),
                value: user?.biometricEnabled ?? false,
                activeThumbColor: AppColors.brandRed,
                onChanged: (val) {
                  ref.read(authProvider.notifier).toggleBiometric(val);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Support & Feedback
            const Text('Support & Feedback', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            _settingTile(
              icon: Icons.support_agent_rounded,
              title: 'Live Chat Support',
              subtitle: 'Connect with 8 specialized agents 24/7',
              onTap: () => context.push('/live-chat'),
              isDark: isDark,
            ),

            _settingTile(
              icon: Icons.star_rate_rounded,
              title: 'Rate Your Experience',
              subtitle: 'Help us improve our hospital & homecare services',
              onTap: () => _showFeedbackModal(context),
              isDark: isDark,
            ),

            _settingTile(
              icon: Icons.info_outline_rounded,
              title: 'About Al Noor Diagnostic Centre',
              subtitle: 'Since 1983 • Prof. Dr. Safdar Ali Malik',
              onTap: () => _showAboutAlNoor(context),
              isDark: isDark,
            ),
            const SizedBox(height: 28),

            // Reset Demo Data Button
            AppButton(
              text: 'Reset Demo Data to Factory Seed',
              variant: AppButtonVariant.outline,
              icon: Icons.refresh_rounded,
              onPressed: () async {
                await ref.read(authProvider.notifier).resetDemoData();
                if (!context.mounted) return;
                AppToast.show(
                  context,
                  title: 'Demo Data Restored!',
                  message: 'Clean factory seed loaded for Ahmed Raza',
                  type: ToastType.success,
                );
              },
            ),
            const SizedBox(height: 14),

            // Logout Button
            AppButton(
              text: 'Logout',
              variant: AppButtonVariant.danger,
              icon: Icons.logout_rounded,
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
            const SizedBox(height: 20),

            // App Version Badge
            const Center(
              child: Text(
                'Al Noor Mobile v1.0.0 (Build 2026.10)\nEngineered with Flutter Clean Architecture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.inkLighter, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.brandPeach.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.brandRed, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.inkLighter),
      ),
    );
  }
}
