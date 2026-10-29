import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF231D1E) : const Color(0xFFEBE5DF),
      highlightColor: isDark ? const Color(0xFF332A2C) : const Color(0xFFF9F5F1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF231D1E) : const Color(0xFFEBE5DF),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
