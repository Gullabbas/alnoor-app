import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/demo/seed_data.dart';
import '../../../data/models/doctor_model.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  String _selectedSpecialty = 'All';

  final List<String> _specialties = [
    'All',
    'Radiology',
    'Pathology',
    'Cardiology',
    'Neurology',
    'Psychology',
    'Physiotherapy',
  ];

  void _showBookConsultation(DoctorModel doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        String type = 'Video Call';

        return StatefulBuilder(
          builder: (ctx, setModalState) => Container(
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
                    Text(
                      'Consult with ${doc.name}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      doc.specialty,
                      style: const TextStyle(fontSize: 12, color: AppColors.brandRed, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Qualifications: ${doc.qualifications}\nFee: PKR ${doc.fee} • Availability: ${doc.availability}',
                      style: const TextStyle(fontSize: 12, color: AppColors.inkSoft, height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    const Text('Consultation Mode:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Video Call', 'Voice Call', 'In-App Chat'].map((m) {
                        final isSel = type == m;
                        return ChoiceChip(
                          label: Text(m),
                          selected: isSel,
                          onSelected: (_) => setModalState(() => type = m),
                          selectedColor: AppColors.brandRed,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : (isDark ? AppColors.darkText : AppColors.ink),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Book $type • PKR ${doc.fee}',
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.push('/consultation/${doc.id}');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    var doctors = SeedData.doctors;
    if (_selectedSpecialty != 'All') {
      doctors = doctors.where((d) => d.specialty.toLowerCase().contains(_selectedSpecialty.toLowerCase())).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultant Specialists'),
      ),
      body: Column(
        children: [
          // Specialty Filter
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              itemCount: _specialties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final s = _specialties[i];
                final isSelected = s == _selectedSpecialty;
                return ChoiceChip(
                  label: Text(s),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedSpecialty = s),
                  selectedColor: AppColors.brandRed,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.ink),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, idx) {
                final doc = doctors[idx];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: AppColors.brandPeach,
                            child: const Icon(Icons.person, color: AppColors.brandRed, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                const SizedBox(height: 2),
                                Text(doc.specialty, style: const TextStyle(color: AppColors.brandRed, fontSize: 12, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(doc.qualifications, style: const TextStyle(fontSize: 11, color: AppColors.inkSoft)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                    Text(' ${doc.rating} (${doc.reviewsCount} reviews) • ${doc.experienceYears} yrs exp', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fee: PKR ${doc.fee}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.brandRed)),
                              Text(doc.availability, style: const TextStyle(fontSize: 10, color: AppColors.inkSoft)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _showBookConsultation(doc),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandRed,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Consult Now'),
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
