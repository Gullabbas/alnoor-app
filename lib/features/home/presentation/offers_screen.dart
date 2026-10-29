import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/repositories/catalog_repository.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = [
      {
        'code': 'NOOR10',
        'title': '10% Off on Any Diagnostic Test',
        'desc': 'Valid on all pathology and blood investigations. No minimum order limit.',
        'gradient': AppColors.primaryGradient,
      },
      {
        'code': 'WELCOME20',
        'title': '20% Welcome Home Sampling Discount',
        'desc': 'Save 20% on your first phlebotomist home sampling visit in Lahore.',
        'gradient': AppColors.goldCardGradient,
      },
      {
        'code': 'ALNOOR30',
        'title': '30% Off on Executive Health Profiles',
        'desc': 'Applicable on Executive Male, Female and Senior Citizen Wellness packages.',
        'gradient': AppColors.heroGradient,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Offers & Promo Vouchers')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: coupons.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, idx) {
          final c = coupons[idx];

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: c['gradient'] as LinearGradient,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        c['code'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.brandRed,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        ref.read(cartProvider.notifier).applyCoupon(c['code'] as String);
                        AppToast.show(
                          context,
                          title: 'Coupon Applied to Cart!',
                          message: '${c['code']} will be deducted at checkout',
                          type: ToastType.success,
                        );
                        context.push('/cart');
                      },
                      child: const Text('Apply in Cart', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  c['title'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  c['desc'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
