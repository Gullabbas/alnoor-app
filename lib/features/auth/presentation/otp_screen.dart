import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/numeric_keypad.dart';
import '../../../core/widgets/pin_input.dart';
import '../../../data/repositories/auth_repository.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final GlobalKey<PinInputState> _pinKey = GlobalKey<PinInputState>();
  bool _hasError = false;
  int _timerSeconds = 30;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _timerSeconds = 30);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _onVerify(String code) async {
    setState(() => _hasError = false);
    final success = await ref.read(authProvider.notifier).verifyOtp(code);
    if (success && mounted) {
      context.push('/pin');
    } else if (mounted) {
      setState(() => _hasError = true);
      _pinKey.currentState?.shake();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phone = authState.user?.phone ?? '0300 1234567';

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
                      'Verify Your Number',
                      style: AppTypography.h1(false, color: isDark ? AppColors.darkText : AppColors.ink),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'Enter the 4-digit code sent to\n'),
                          TextSpan(
                            text: phone,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkText : AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.brandPeach.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Demo OTP: 1234',
                        style: TextStyle(
                          color: AppColors.brandRed,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Pin Input Boxes
                    PinInput(
                      key: _pinKey,
                      length: 4,
                      obscure: false,
                      hasError: _hasError,
                      onCompleted: _onVerify,
                    ),

                    if (_hasError) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Incorrect code. Please enter 1234',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Resend Timer
                    if (_timerSeconds > 0)
                      Text(
                        'Resend code in ${_timerSeconds}s',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
                          fontSize: 13,
                        ),
                      )
                    else
                      TextButton(
                        onPressed: _startTimer,
                        child: const Text(
                          'Resend Code',
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

            // On-screen numeric keypad for effortless mobile/desktop testing
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: isDark ? AppColors.darkCanvas : AppColors.canvas,
              child: NumericKeypad(
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
