import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/numeric_keypad.dart';
import '../../../core/widgets/pin_input.dart';
import '../../../data/repositories/auth_repository.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final GlobalKey<PinInputState> _pinKey = GlobalKey<PinInputState>();
  bool _hasError = false;

  void _onPinCompleted(String pin) async {
    setState(() => _hasError = false);
    final success = await ref.read(authProvider.notifier).verifyPin(pin);
    if (success && mounted) {
      final user = ref.read(authProvider).user;
      if (user != null && user.familyProfiles.length > 1) {
        context.go('/profile-select');
      } else {
        context.go('/home');
      }
    } else if (mounted) {
      setState(() => _hasError = true);
      _pinKey.currentState?.shake();
    }
  }

  void _showBiometricSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BiometricSimulationSheet(
        onSuccess: () {
          Navigator.of(ctx).pop();
          _onPinCompleted('1234');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;
    final name = user?.fullName ?? 'Patient';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Welcome Back, $name',
                      textAlign: TextAlign.center,
                      style: AppTypography.h1(false, color: isDark ? AppColors.darkText : AppColors.ink),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your 4-digit security PIN to unlock',
                      style: AppTypography.body(false, color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.brandPeach.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Universal PIN: 1234',
                        style: TextStyle(
                          color: AppColors.brandRed,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    PinInput(
                      key: _pinKey,
                      length: 4,
                      obscure: true,
                      hasError: _hasError,
                      onCompleted: _onPinCompleted,
                    ),

                    if (_hasError) ...[
                      const SizedBox(height: 14),
                      const Text(
                        'Incorrect PIN. Enter 1234',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    TextButton(
                      onPressed: () {
                        context.push('/otp');
                      },
                      child: const Text(
                        'Forgot PIN?',
                        style: TextStyle(
                          color: AppColors.brandRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: isDark ? AppColors.darkCanvas : AppColors.canvas,
              child: NumericKeypad(
                showBiometric: true,
                onBiometricPressed: _showBiometricSheet,
                onDigitPressed: (d) => _pinKey.currentState?.appendDigit(d),
                onDeletePressed: () => _pinKey.currentState?.deleteDigit(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BiometricSimulationSheet extends StatefulWidget {
  final VoidCallback onSuccess;

  const _BiometricSimulationSheet({required this.onSuccess});

  @override
  State<_BiometricSimulationSheet> createState() => _BiometricSimulationSheetState();
}

class _BiometricSimulationSheetState extends State<_BiometricSimulationSheet> {
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() => _verified = true);
        Future.delayed(const Duration(milliseconds: 500), widget.onSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F181A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _verified
                  ? AppColors.successLight
                  : AppColors.brandPeach.withValues(alpha: 0.3),
              border: Border.all(
                color: _verified ? AppColors.success : AppColors.brandCopper,
                width: 2,
              ),
            ),
            child: Icon(
              _verified ? Icons.check_rounded : Icons.fingerprint_rounded,
              color: _verified ? AppColors.success : AppColors.brandRed,
              size: 42,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _verified ? 'Identity Verified' : 'Confirm Face ID / Fingerprint',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _verified
                ? 'Logging into your Al Noor diagnostic account...'
                : 'Touch sensor or glance at camera',
            style: const TextStyle(fontSize: 13, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
