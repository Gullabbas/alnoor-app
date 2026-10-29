import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/catalog_repository.dart';

class PackageDetailScreen extends ConsumerWidget {
  final String packageId;

  const PackageDetailScreen({super.key, required this.packageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogRepo = ref.watch(catalogRepositoryProvider);
    final pkg = catalogRepo.getPackageById(packageId);
    final cart = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (pkg == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Package Not Found')),
        body: const Center(child: Text('Package details could not be found.')),
      );
    }

    final isInCart = cart.containsItem(pkg.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(pkg.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              AppToast.show(context, title: 'Share Link Copied', message: 'alnoordiagnostic.com/packages/${pkg.id}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandRed.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'SAVE ${pkg.discountPercent}% TODAY',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pkg.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pkg.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'PKR ${pkg.discountedPrice}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'PKR ${pkg.originalPrice}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fasting & Preparation Callout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.brandCopper, size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pkg.fastingRequired ? '10–12 Hours Fasting Required' : 'No Fasting Required',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pkg.fastingRequired
                              ? 'Water is permitted. Morning home sampling between 6:30 AM – 10:00 AM recommended.'
                              : 'Can be scheduled at any preferred hour between 9:00 AM and Midnight.',
                          style: const TextStyle(fontSize: 11, color: AppColors.inkSoft),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Included Tests Section
            const Text(
              'Included Diagnostic Tests',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            ...pkg.includedTestIds.map((testId) {
              final test = catalogRepo.getTestById(testId);
              final testName = test?.name ?? testId;
              final category = test?.category ?? 'Laboratory';
              final price = test?.price ?? 1500;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.brandRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(testName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text(category, style: const TextStyle(fontSize: 11, color: AppColors.inkSoft)),
                        ],
                      ),
                    ),
                    Text(
                      'PKR $price',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.inkLighter,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 28),

            // Action Buttons
            AppButton(
              text: isInCart ? 'View in Cart' : 'Add to Cart — PKR ${pkg.discountedPrice}',
              onPressed: () {
                if (isInCart) {
                  context.push('/cart');
                } else {
                  ref.read(cartProvider.notifier).addItem(
                        OrderItem(
                          id: pkg.id,
                          name: pkg.name,
                          price: pkg.discountedPrice,
                          isPackage: true,
                        ),
                      );
                  AppToast.show(
                    context,
                    title: 'Package Added to Cart',
                    message: pkg.name,
                    type: ToastType.success,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
