import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/orders_repository.dart';

class OrderSuccessScreen extends ConsumerWidget {
  final String orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final order = orders.getById(orderId) ?? (orders.orders.isNotEmpty ? orders.orders.first : null);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bookingNo = order?.bookingNumber ?? 'ANDC-2026-9481';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Animated Success Icon
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Your home sampling appointment has been scheduled with Al Noor Diagnostic Centre.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Booking Card with QR
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'BOOKING NUMBER',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkTextSoft : AppColors.inkLighter, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bookingNo,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brandRed,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: QrImageView(
                        data: bookingNo,
                        version: QrVersions.auto,
                        size: 130,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Phlebotomist: Tariq Mehmood • ETA 18 mins',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.ink),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Track Rider Button
              AppButton(
                text: 'Track Phlebotomist on Live Map',
                onPressed: () {
                  if (order != null) {
                    context.push('/order/${order.id}');
                  } else {
                    context.go('/orders');
                  }
                },
              ),
              const SizedBox(height: 12),

              // Return Home Button
              AppButton(
                text: 'Return to Home',
                variant: AppButtonVariant.ghost,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
