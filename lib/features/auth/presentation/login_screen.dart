import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    final raw = _phoneController.text.trim();
    if (raw.isEmpty) {
      setState(() => _errorText = 'Please enter your mobile phone number');
      return;
    }
    final clean = raw.replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^(03\d{9}|\+923\d{9}|3\d{9})$').hasMatch(clean)) {
      setState(() => _errorText = 'Enter valid Pakistan phone (e.g. 0300 1234567)');
      return;
    }

    setState(() => _errorText = null);
    final success = await ref.read(authProvider.notifier).login(clean);
    if (success && mounted) {
      context.push('/otp');
    }
  }

  void _fillDemoPhone(String phone) {
    _phoneController.text = phone;
    setState(() => _errorText = null);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Al Noor Logo
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandRed.withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/branding/logo-alnoor.png',
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.medical_services_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Welcome to Al Noor',
                textAlign: TextAlign.center,
                style: AppTypography.h1(false, color: isDark ? AppColors.darkText : AppColors.ink),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your phone number to access reports, book home sampling, and view health records.',
                textAlign: TextAlign.center,
                style: AppTypography.body(false, color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft),
              ),
              const SizedBox(height: 32),

              // Phone Number Field
              AppTextField(
                label: 'Phone Number',
                hint: '0300 1234567',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_iphone_rounded, color: AppColors.brandRed, size: 20),
                validator: (val) => _errorText,
              ),
              const SizedBox(height: 20),

              // Login Button
              AppButton(
                text: 'Login',
                isLoading: authState.isLoading,
                onPressed: _onLogin,
              ),
              const SizedBox(height: 14),

              // Continue as Guest Button
              AppButton(
                text: 'Continue as Guest',
                variant: AppButtonVariant.ghost,
                onPressed: () {
                  ref.read(authProvider.notifier).continueAsGuest();
                  context.go('/home');
                },
              ),
              const SizedBox(height: 36),

              // Demo Accounts Quick Selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bolt_rounded, color: AppColors.brandCopper, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'One-Tap Demo Logins',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brandRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Select an account below to pre-fill test data:',
                      style: TextStyle(fontSize: 11, color: AppColors.inkSoft),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _demoChip('0300 1234567', 'Ahmed (Main User)'),
                        _demoChip('0321 7654321', 'Ayesha (Female)'),
                        _demoChip('0333 1112223', 'Usman (Corporate)'),
                        _demoChip('0345 0000000', 'New Account (Fresh)'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _demoChip(String phone, String name) {
    return ActionChip(
      onPressed: () => _fillDemoPhone(phone),
      backgroundColor: AppColors.brandPeach.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.brandCopper, width: 0.8),
      ),
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          Text(
            phone,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.brandRed,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
