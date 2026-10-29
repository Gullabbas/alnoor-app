import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/demo/seed_data.dart';

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  void _call(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[\s\-]'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[\s\+\-]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMap(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final branches = SeedData.branches;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches & Collection Centers'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: branches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, idx) {
          final b = branches[idx];

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: b.isMainBranch ? AppColors.brandCopper : (isDark ? AppColors.darkBorder : AppColors.border),
                width: b.isMainBranch ? 2.0 : 1.0,
              ),
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
                    Expanded(
                      child: Text(
                        b.name,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ),
                    if (b.isMainBranch)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.brandPeach.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'MAIN CAMPUS',
                          style: TextStyle(color: AppColors.brandRed, fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  b.address,
                  style: const TextStyle(fontSize: 12, color: AppColors.inkSoft, height: 1.3),
                ),
                const SizedBox(height: 8),

                // Live Open / Closed Status
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: b.isOpenNow ? AppColors.success : AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      b.isOpenNow ? 'Open Now' : 'Closed',
                      style: TextStyle(
                        color: b.isOpenNow ? AppColors.success : AppColors.danger,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' • ${b.openHours}',
                      style: const TextStyle(fontSize: 11, color: AppColors.inkLighter),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Services Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: b.services.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(s, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                ),
                const Divider(height: 24),

                // Action Buttons: Call, WhatsApp, Directions
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _call(b.uan),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.brandPeach.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone_rounded, size: 14, color: AppColors.brandRed),
                              SizedBox(width: 4),
                              Text(
                                'Call UAN',
                                style: TextStyle(color: AppColors.brandRed, fontWeight: FontWeight.w700, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => _openWhatsApp(b.mobile),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_rounded, size: 14, color: AppColors.success),
                              SizedBox(width: 4),
                              Text(
                                'WhatsApp',
                                style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => _openMap(b.latitude, b.longitude),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.brandCopper.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_rounded, size: 14, color: AppColors.brandCopper),
                              SizedBox(width: 4),
                              Text(
                                'Directions',
                                style: TextStyle(color: AppColors.brandCopper, fontWeight: FontWeight.w700, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
