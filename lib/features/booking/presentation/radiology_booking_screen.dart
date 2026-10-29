import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/demo/seed_data.dart';

class RadiologyBookingScreen extends StatefulWidget {
  const RadiologyBookingScreen({super.key});

  @override
  State<RadiologyBookingScreen> createState() => _RadiologyBookingScreenState();
}

class _RadiologyBookingScreenState extends State<RadiologyBookingScreen> {
  String _selectedScan = '128-Slice MDCT Chest';
  int _price = 13500;
  String _selectedBranch = 'Main Complex (Shadman)';
  final DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final String _selectedSlot = '10:00 AM – 11:00 AM';

  final List<Map<String, dynamic>> _scans = [
    {
      'name': '128-Slice MDCT Chest',
      'price': 13500,
      'prep': '4 hours fasting. Bring recent serum creatinine report if IV contrast is indicated.',
    },
    {
      'name': 'High-Resolution Open MRI Brain',
      'price': 14500,
      'prep': 'Remove all metal jewelry and hairpins. Inform staff if you have cardiac pacemaker.',
    },
    {
      'name': 'Ultrasound Whole Abdomen (Color Doppler)',
      'price': 3800,
      'prep': '6 hours fasting for liver/gallbladder. Full urinary bladder required.',
    },
    {
      'name': '3D / 4D Pregnancy Anomaly Scan',
      'price': 6500,
      'prep': 'Routine maternal scan. Moderate bladder fullness recommended.',
    },
    {
      'name': 'Digital Mammography (Bilateral)',
      'price': 6800,
      'prep': 'Do not apply talcum powder, lotions or perfumes under arms or on breasts.',
    },
    {
      'name': 'DEXA Bone Mineral Density Scan',
      'price': 6200,
      'prep': 'Avoid calcium tablets for 24 hours prior to scan.',
    },
    {
      'name': 'OPG Dental Panoramic & 3D CBCT',
      'price': 3200,
      'prep': 'Remove dentures, nose rings, and earrings.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentPrep = _scans.firstWhere((s) => s['name'] == _selectedScan)['prep'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Radiology & Imaging Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Imaging Modality', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            ..._scans.map((s) {
              final isSel = s['name'] == _selectedScan;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSel ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
                    width: isSel ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  onTap: () => setState(() {
                    _selectedScan = s['name'] as String;
                    _price = s['price'] as int;
                  }),
                  leading: const Icon(Icons.document_scanner_rounded, color: AppColors.brandRed),
                  title: Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  trailing: Text('PKR ${s['price']}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandRed)),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Preparation Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF261D20) : const Color(0xFFFBF2EC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.brandCopper),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.brandRed, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Preparation Instructions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(currentPrep, style: const TextStyle(fontSize: 12, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Branch Selector
            const Text('Select Al Noor Branch', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              initialValue: _selectedBranch,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              items: SeedData.branches
                  .map((b) => DropdownMenuItem(value: b.name, child: Text(b.name, style: const TextStyle(fontSize: 13))))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranch = v!),
            ),
            const SizedBox(height: 20),

            // Date & Slot Selection
            const Text('Appointment Slot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                    child: Text(
                      DateFormat('EEE, dd MMM yyyy').format(_selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                    child: Text(
                      _selectedSlot,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            AppButton(
              text: 'Confirm Scan Appointment — PKR $_price',
              onPressed: () {
                AppToast.show(
                  context,
                  title: 'Radiology Scan Scheduled!',
                  message: '$_selectedScan confirmed at $_selectedBranch',
                  type: ToastType.success,
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
