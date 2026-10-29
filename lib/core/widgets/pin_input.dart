import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PinInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool obscure;
  final bool hasError;

  const PinInput({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.onChanged,
    this.obscure = true,
    this.hasError = false,
  });

  @override
  State<PinInput> createState() => PinInputState();
}

class PinInputState extends State<PinInput> with SingleTickerProviderStateMixin {
  String _code = '';
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant PinInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      shake();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void shake() {
    _shakeController.forward(from: 0.0).then((_) {
      clear();
    });
  }

  void appendDigit(String digit) {
    if (_code.length < widget.length) {
      setState(() {
        _code += digit;
      });
      widget.onChanged?.call(_code);
      if (_code.length == widget.length) {
        widget.onCompleted(_code);
      }
    }
  }

  void deleteDigit() {
    if (_code.isNotEmpty) {
      setState(() {
        _code = _code.substring(0, _code.length - 1);
      });
      widget.onChanged?.call(_code);
    }
  }

  void clear() {
    setState(() {
      _code = '';
    });
    widget.onChanged?.call(_code);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          final isFilled = index < _code.length;
          final isCurrent = index == _code.length;

          Color borderColor;
          if (widget.hasError) {
            borderColor = AppColors.danger;
          } else if (isCurrent) {
            borderColor = AppColors.brandRed;
          } else if (isFilled) {
            borderColor = AppColors.brandCopper;
          } else {
            borderColor = isDark ? AppColors.darkBorder : AppColors.border;
          }

          final bgColor = isDark
              ? (isFilled ? AppColors.darkSurfaceElevated : AppColors.darkSurface)
              : (isFilled ? AppColors.brandPeach.withValues(alpha: 0.3) : AppColors.surface);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 58,
            height: 64,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isCurrent || isFilled ? 2.0 : 1.2,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: AppColors.brandRed.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: isFilled
                ? (widget.obscure
                    ? Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: AppColors.brandRed,
                          shape: BoxShape.circle,
                        ),
                      )
                    : Text(
                        _code[index],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkText : AppColors.ink,
                        ),
                      ))
                : (isCurrent
                    ? Container(
                        width: 2,
                        height: 22,
                        color: AppColors.brandRed,
                      )
                    : null),
          );
        }),
      ),
    );
  }
}
