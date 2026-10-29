import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final int maxLines;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.autofocus = false,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _errorText;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
      if (!_focusNode.hasFocus && widget.validator != null) {
        _validate();
      }
    });

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _validate() {
    if (widget.validator != null) {
      final text = widget.controller?.text ?? '';
      final err = widget.validator!(text);
      if (err != _errorText) {
        setState(() => _errorText = err);
        if (err != null) {
          _shakeController.forward(from: 0.0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasError = _errorText != null;

    Color borderColor;
    if (hasError) {
      borderColor = AppColors.danger;
    } else if (_isFocused) {
      borderColor = AppColors.brandRed;
    } else {
      borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    }

    final bgColor = isDark
        ? (_isFocused ? AppColors.darkSurfaceElevated : AppColors.darkSurface)
        : (_isFocused ? Colors.white : AppColors.surface);

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: _isFocused ? 1.8 : 1.2),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.brandRed.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              style: AppTypography.title(
                isUrdu,
                color: isDark ? AppColors.darkText : AppColors.ink,
              ),
              onChanged: (val) {
                if (_errorText != null) {
                  _validate();
                }
                widget.onChanged?.call(val);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: widget.label,
                labelStyle: TextStyle(
                  color: hasError
                      ? AppColors.danger
                      : (_isFocused ? AppColors.brandRed : AppColors.inkSoft),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextSoft : AppColors.inkLighter,
                  fontSize: 14,
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _errorText!,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
