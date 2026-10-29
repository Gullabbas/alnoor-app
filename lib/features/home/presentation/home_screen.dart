import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/hero_card_3d.dart';
import '../../../data/demo/seed_data.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../../data/repositories/reports_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _heroCarouselController = PageController();
  int _heroIndex = 0;

  @override
  void dispose() {
    _heroCarouselController.dispose();
    super.dispose();
  }

  void _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/923081139009');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showProfileSwitchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final auth = ref.watch(authProvider);
        final profiles = auth.user?.familyProfiles ?? [];
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1719) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                    'Switch Active Patient Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  ...profiles.map((p) {
                    final isSelected = p.id == auth.activeProfileId;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: isSelected ? AppColors.brandRed : AppColors.brandPeach,
                        child: Text(
                          p.initials,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.brandRed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(p.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${p.relation} • ${p.age} yrs • ID: ${p.patientId}'),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.brandRed)
                          : null,
                      onTap: () {
                        ref.read(authProvider.notifier).switchActiveProfile(p.id);
                        Navigator.of(ctx).pop();
                      },
                    );
                  }),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final activeProfile = authState.activeProfile ?? authState.user?.defaultProfile;
    final patientName = activeProfile?.fullName ?? authState.user?.fullName ?? 'Patient';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final ordersState = ref.watch(ordersProvider);
    final activeOrder = ordersState.upcomingOrders.isNotEmpty ? ordersState.upcomingOrders.first : null;

    final recentReports = ref.watch(reportsRepositoryProvider).getReportsForPatient(activeProfile?.patientId ?? 'all');
    final recentReport = recentReports.isNotEmpty ? recentReports.first : null;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Personalized Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Avatar + Profile Switcher
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showProfileSwitchSheet(context),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.brandRed.withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    activeProfile?.initials ?? 'AR',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Hi, $patientName',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: isDark ? AppColors.darkText : AppColors.ink,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.arrow_drop_down, color: AppColors.brandRed, size: 20),
                                        ],
                                      ),
                                      const Text(
                                        'Have a healthy day 👋',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Action Buttons: WhatsApp & Notifications
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: _openWhatsApp,
                              icon: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_rounded,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                              ),
                              tooltip: 'WhatsApp Live Chat',
                            ),
                            IconButton(
                              onPressed: () => context.push('/notifications'),
                              icon: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceMuted,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications_none_rounded,
                                      color: isDark ? AppColors.darkText : AppColors.ink,
                                      size: 20,
                                    ),
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      width: 9,
                                      height: 9,
                                      decoration: const BoxDecoration(
                                        color: AppColors.brandRed,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              tooltip: 'Notifications',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. Hero 3D Promotional Carousel
                  SizedBox(
                    height: 175,
                    child: PageView(
                      controller: _heroCarouselController,
                      onPageChanged: (i) => setState(() => _heroIndex = i),
                      children: [
                        _buildHeroSlide(
                          title: 'Free Home Sampling',
                          subtitle: 'On all orders above PKR 3,000 across Lahore. Certified phlebotomists at your door.',
                          badge: 'HOT OFFER',
                          gradient: AppColors.heroGradient,
                          cta: 'Book Now',
                          icon: Icons.local_hospital_rounded,
                          onTap: () => context.push('/book-sampling'),
                        ),
                        _buildHeroSlide(
                          title: 'Executive Health Month',
                          subtitle: 'Comprehensive 18-Test Profile with Save 38% discount. Full LFT, RFT, Lipids & HbA1c.',
                          badge: 'SAVE 38%',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB8242A), Color(0xFF8B1217)],
                          ),
                          cta: 'View Package',
                          icon: Icons.health_and_safety_rounded,
                          onTap: () => context.push('/package-detail/pkg_exec_fasting'),
                        ),
                        _buildHeroSlide(
                          title: '128-Slice MDCT & Open MRI',
                          subtitle: 'High precision cardiac CT angiography & neuro imaging. Three decades of diagnostic trust.',
                          badge: '40+ YEARS EXCELLENCE',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF261D20), Color(0xFF130E10)],
                          ),
                          cta: 'Explore Radiology',
                          icon: Icons.document_scanner_rounded,
                          onTap: () => context.push('/radiology-booking'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Carousel dots
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _heroIndex == i ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _heroIndex == i ? AppColors.brandRed : AppColors.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Quick Services (Home Sampling Hero Card + 3 Grid Tiles)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Services',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 14),

                        // Home Sampling 3D Hero Card
                        HeroCard3D(
                          height: 130,
                          onTap: () => context.push('/book-sampling'),
                          child: Container(
                            height: 130,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brandRed.withValues(alpha: 0.3),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'AT YOUR DOORSTEP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'Book Home Sampling',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Healthcare comes home with convenient sampling',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: Colors.white12,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.moped_rounded,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 3 Quick Action Photo Tiles: View Reports, Talk to Doctor, My Health
                        Row(
                          children: [
                            Expanded(
                              child: _QuickTile(
                                icon: Icons.assignment_turned_in_rounded,
                                title: 'View Reports',
                                color: AppColors.brandCopper,
                                onTap: () => context.go('/documents'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _QuickTile(
                                icon: Icons.medical_services_rounded,
                                title: 'Talk to Doctor',
                                color: AppColors.brandRed,
                                onTap: () => context.push('/doctors'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _QuickTile(
                                icon: Icons.favorite_rounded,
                                title: 'My Health',
                                color: AppColors.brandRose,
                                onTap: () => context.push('/my-health'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 4. Live Tracking Card (If active order exists)
                  if (activeOrder != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () => context.push('/order/${activeOrder.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.brandCopper.withValues(alpha: 0.6)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.brandCopper.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Phlebotomist En Route',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            color: isDark ? AppColors.darkText : AppColors.ink,
                                          ),
                                        ),
                                        Text(
                                          'ETA ${activeOrder.etaMinutes} mins',
                                          style: const TextStyle(
                                            color: AppColors.brandRed,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rider: ${activeOrder.rider?.name ?? "Tariq Mehmood"} • Tap to track live on map',
                                      style: const TextStyle(fontSize: 11, color: AppColors.inkSoft),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.brandRed),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // 5. Other Diagnostic Services Grid (3D icons)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Other Services',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            TextButton(
                              onPressed: () => context.push('/tests'),
                              child: const Text(
                                'View All',
                                style: TextStyle(color: AppColors.brandRed, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.82,
                          children: [
                            _ServiceGridItem(
                              icon: Icons.biotech_rounded,
                              label: 'All Tests',
                              onTap: () => context.push('/tests'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.inventory_2_rounded,
                              label: 'Health Packages',
                              onTap: () => context.push('/packages'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.document_scanner_rounded,
                              label: 'Radiology',
                              onTap: () => context.push('/radiology-booking'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.monitor_heart_rounded,
                              label: 'Cardiac Care',
                              onTap: () => context.push('/radiology-booking'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.psychology_rounded,
                              label: 'EEG & Neuro',
                              onTap: () => context.push('/radiology-booking'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.fitness_center_rounded,
                              label: 'Physiotherapy',
                              onTap: () => context.push('/doctors'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.self_improvement_rounded,
                              label: 'Psychology',
                              onTap: () => context.push('/doctors'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.credit_card_rounded,
                              label: 'Health Cards',
                              onTap: () => context.push('/health-cards'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.business_center_rounded,
                              label: 'Corporate',
                              onTap: () => context.push('/packages'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.public_rounded,
                              label: 'Embassy Care',
                              onTap: () => context.push('/packages'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.medical_information_rounded,
                              label: 'Home Nursing',
                              onTap: () => context.push('/live-chat'),
                            ),
                            _ServiceGridItem(
                              icon: Icons.location_on_rounded,
                              label: 'Branches',
                              onTap: () => context.push('/branches'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 6. Recent Report Card (if exists)
                  if (recentReport != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Report',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                              TextButton(
                                onPressed: () => context.go('/documents'),
                                child: const Text('All Reports', style: TextStyle(color: AppColors.brandRed)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => context.push('/report/${recentReport.id}'),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : AppColors.surface,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.brandPeach.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.brandRed),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recentReport.testName,
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          'Case ${recentReport.caseNumber} • ${recentReport.date.day}/${recentReport.date.month}/${recentReport.date.year}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.inkSoft),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded, color: AppColors.inkSoft),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // 7. Why Choose Al Noor (9 Reasons Animated Carousel)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Why Choose Al Noor',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '9 Reasons to Trust Lahore\'s Leading Diagnostic Institution',
                          style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
                        ),
                        const SizedBox(height: 14),

                        SizedBox(
                          height: 130,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: SeedData.nineReasons.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, idx) {
                              final item = SeedData.nineReasons[idx];
                              return Container(
                                width: 230,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isDark ? AppColors.darkBorder : AppColors.border,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.brandPeach.withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.star_rounded, color: AppColors.brandRed, size: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item['title']!,
                                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['desc']!,
                                      style: const TextStyle(fontSize: 11, color: AppColors.inkSoft, height: 1.4),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 8. Health Tips Carousel
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daily Health Tips',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 110,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: SeedData.healthTips.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final tip = SeedData.healthTips[index];
                              return Container(
                                width: 260,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isDark ? AppColors.darkBorder : AppColors.border,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.lightbulb_rounded, color: AppColors.brandCopper, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            tip['title']!,
                                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      tip['tip']!,
                                      style: const TextStyle(fontSize: 11, color: AppColors.inkSoft, height: 1.3),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Floating "Talk to AI" Assistant Orb
            Positioned(
              right: 20,
              bottom: 90,
              child: GestureDetector(
                onTap: () => context.push('/ai-assistant'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandRed.withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Talk to AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSlide({
    required String title,
    required String subtitle,
    required String badge,
    required LinearGradient gradient,
    required String cta,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: HeroCard3D(
        height: 175,
        onTap: onTap,
        child: Container(
          height: 175,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Icon(icon, color: Colors.white70, size: 28),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cta,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkText : AppColors.ink,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceGridItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandRed.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.brandRed,
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.ink,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
