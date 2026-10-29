import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/repositories/auth_repository.dart';

class MyHealthScreen extends ConsumerStatefulWidget {
  const MyHealthScreen({super.key});

  @override
  ConsumerState<MyHealthScreen> createState() => _MyHealthScreenState();
}

class _MyHealthScreenState extends ConsumerState<MyHealthScreen> {
  // Current vitals state
  int _bpSystolic = 120;
  int _bpDiastolic = 80;
  int _bloodSugar = 104;
  double _bmi = 23.4;
  double _weight = 74.0;

  void _showAddReadingModal() {
    final sysCtrl = TextEditingController(text: '$_bpSystolic');
    final diaCtrl = TextEditingController(text: '$_bpDiastolic');
    final sugarCtrl = TextEditingController(text: '$_bloodSugar');
    final weightCtrl = TextEditingController(text: '$_weight');

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
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                'Log Health Vitals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sysCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'BP Systolic (mmHg)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: diaCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'BP Diastolic (mmHg)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sugarCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Fasting Glucose (mg/dL)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: weightCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Save Readings',
                onPressed: () {
                  setState(() {
                    _bpSystolic = int.tryParse(sysCtrl.text) ?? _bpSystolic;
                    _bpDiastolic = int.tryParse(diaCtrl.text) ?? _bpDiastolic;
                    _bloodSugar = int.tryParse(sugarCtrl.text) ?? _bloodSugar;
                    _weight = double.tryParse(weightCtrl.text) ?? _weight;
                    _bmi = double.parse((_weight / (1.75 * 1.75)).toStringAsFixed(1));
                  });
                  Navigator.of(ctx).pop();
                  AppToast.show(context, title: 'Vitals Saved', message: 'Health indicators updated successfully', type: ToastType.success);
                },
              ),
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
    final auth = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patient = auth.activeProfile ?? auth.user?.defaultProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Health Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Reading',
            onPressed: _showAddReadingModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Health Score Hero
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
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '88',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overall Health Score',
                          style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Good Metabolic Balance',
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Patient: ${patient?.fullName ?? "Ahmed Raza"} • Verified Oct 2026',
                          style: const TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4 Vital Rings Grid
            const Text('Essential Health Vitals', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                _VitalCard(
                  title: 'Blood Pressure',
                  value: '$_bpSystolic/$_bpDiastolic',
                  unit: 'mmHg',
                  status: 'Optimal',
                  statusColor: AppColors.success,
                  icon: Icons.speed_rounded,
                  isDark: isDark,
                ),
                _VitalCard(
                  title: 'Blood Glucose',
                  value: '$_bloodSugar',
                  unit: 'mg/dL',
                  status: 'Borderline',
                  statusColor: AppColors.warning,
                  icon: Icons.water_drop_rounded,
                  isDark: isDark,
                ),
                _VitalCard(
                  title: 'Body Mass Index',
                  value: '$_bmi',
                  unit: 'kg/m²',
                  status: 'Normal Weight',
                  statusColor: AppColors.success,
                  icon: Icons.accessibility_new_rounded,
                  isDark: isDark,
                ),
                _VitalCard(
                  title: 'Body Weight',
                  value: '$_weight',
                  unit: 'kg',
                  status: 'Stable',
                  statusColor: AppColors.success,
                  icon: Icons.scale_rounded,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Health Cards Hub Banner
            GestureDetector(
              onTap: () => context.push('/health-cards'),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.goldCardGradient,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.white, size: 36),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Al Noor Health Card Perks',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Up to 35% discount on all tests & scans. View Card >',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Medication Reminders
            const Text('Medication & Daily Reminders', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            _ReminderCard(
              title: 'Vitamin D3 Drops (200,000 IU)',
              time: 'Sunday • 10:00 AM (Monthly)',
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _ReminderCard(
              title: 'Metformin 500mg',
              time: 'Daily • After Dinner (8:30 PM)',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String status;
  final Color statusColor;
  final IconData icon;
  final bool isDark;

  const _VitalCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.inkSoft)),
              Icon(icon, size: 18, color: AppColors.brandCopper),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(fontSize: 10, color: AppColors.inkLighter, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final String title;
  final String time;
  final bool isDark;

  const _ReminderCard({required this.title, required this.time, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.brandPeach.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active_rounded, color: AppColors.brandRed, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                Text(time, style: const TextStyle(fontSize: 11, color: AppColors.inkSoft)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
