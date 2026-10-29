import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onBiometricPressed;
  final bool showBiometric;

  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    this.onBiometricPressed,
    this.showBiometric = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(context, ['1', '2', '3'], ['', 'ABC', 'DEF']),
        const SizedBox(height: 12),
        _buildRow(context, ['4', '5', '6'], ['GHI', 'JKL', 'MNO']),
        const SizedBox(height: 12),
        _buildRow(context, ['7', '8', '9'], ['PQRS', 'TUV', 'WXYZ']),
        const SizedBox(height: 12),
        _buildBottomRow(context),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> digits, List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        return _KeypadButton(
          digit: digits[i],
          subtext: letters[i],
          onTap: () => onDigitPressed(digits[i]),
        );
      }),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (showBiometric && onBiometricPressed != null)
          _IconButton(
            icon: Icons.fingerprint_rounded,
            color: AppColors.brandCopper,
            onTap: onBiometricPressed!,
          )
        else
          const SizedBox(width: 72, height: 72),
        _KeypadButton(
          digit: '0',
          subtext: '+',
          onTap: () => onDigitPressed('0'),
        ),
        _IconButton(
          icon: Icons.backspace_outlined,
          color: AppColors.inkSoft,
          onTap: onDeletePressed,
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String digit;
  final String subtext;
  final VoidCallback onTap;

  const _KeypadButton({
    required this.digit,
    required this.subtext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              digit,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkText : AppColors.ink,
              ),
            ),
            if (subtext.isNotEmpty)
              Text(
                subtext,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: isDark ? AppColors.darkTextSoft : AppColors.inkLighter,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(36),
      child: SizedBox(
        width: 72,
        height: 72,
        child: Center(
          child: Icon(icon, size: 28, color: color),
        ),
      ),
    );
  }
}
