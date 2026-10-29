import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/test_model.dart';
import '../../../data/repositories/catalog_repository.dart';

class PackagesScreen extends ConsumerStatefulWidget {
  const PackagesScreen({super.key});

  @override
  ConsumerState<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends ConsumerState<PackagesScreen> {
  String _searchQuery = '';

  void _showCompareSheet(PackageModel p1, PackageModel p2) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1719) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Compare Health Packages',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _compareColumn(p1, isDark),
                        ),
                        const SizedBox(width: 14),
                        Container(width: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _compareColumn(p2, isDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _compareColumn(PackageModel p, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.name,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          maxLines: 2,
        ),
        const SizedBox(height: 4),
        Text(
          'PKR ${p.discountedPrice}',
          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandRed, fontSize: 15),
        ),
        Text(
          'PKR ${p.originalPrice}',
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: AppColors.inkLighter,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 10),
        const Text('Highlights:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
        ...p.highlights.map((h) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 12, color: AppColors.success),
                  const SizedBox(width: 4),
                  Expanded(child: Text(h, style: const TextStyle(fontSize: 10))),
                ],
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogRepo = ref.watch(catalogRepositoryProvider);
    final packages = catalogRepo.getPackages(query: _searchQuery);
    final cart = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Packages'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.push('/cart'),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.brandRed,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: TextField(
              onChanged: (q) => setState(() => _searchQuery = q),
              decoration: InputDecoration(
                hintText: 'Search packages (Executive, Diabetes, Cardiac...)',
                hintStyle: TextStyle(color: isDark ? AppColors.darkTextSoft : AppColors.inkLighter, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.brandRed),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: packages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final pkg = packages[idx];
                final isInCart = cart.containsItem(pkg.id);

                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
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
                              color: AppColors.brandRed.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Save ${pkg.discountPercent}%',
                              style: const TextStyle(
                                color: AppColors.brandRed,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          if (packages.length > 1)
                            GestureDetector(
                              onTap: () => _showCompareSheet(pkg, packages[(idx + 1) % packages.length]),
                              child: const Row(
                                children: [
                                  Icon(Icons.compare_arrows_rounded, size: 16, color: AppColors.brandCopper),
                                  SizedBox(width: 4),
                                  Text(
                                    'Compare',
                                    style: TextStyle(
                                      color: AppColors.brandCopper,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pkg.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pkg.description,
                        style: const TextStyle(fontSize: 12, color: AppColors.inkSoft, height: 1.3),
                      ),
                      const SizedBox(height: 12),

                      // Highlights
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: pkg.highlights.map((h) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.brandPeach.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              h,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Pricing & Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PKR ${pkg.discountedPrice}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.brandRed,
                                ),
                              ),
                              Text(
                                'PKR ${pkg.originalPrice}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inkLighter,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () => context.push('/package-detail/${pkg.id}'),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.brandCopper),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                                child: const Text(
                                  'Details',
                                  style: TextStyle(color: AppColors.brandRed, fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  if (isInCart) {
                                    ref.read(cartProvider.notifier).removeItem(pkg.id);
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
                                      title: 'Package Added',
                                      message: pkg.name,
                                      type: ToastType.success,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isInCart ? AppColors.inkSoft : AppColors.brandRed,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                                child: Text(
                                  isInCart ? 'Remove' : 'Add to Cart',
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
