import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/report_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/reports_repository.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _categories = [
    'All',
    'Pathology',
    'Radiology',
    'Cardiology',
    'Prescriptions',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final activePatient = auth.activeProfile ?? auth.user?.defaultProfile;
    final patientId = activePatient?.patientId ?? 'all';

    final reportsRepo = ref.watch(reportsRepositoryProvider);
    final reports = reportsRepo.getReportsForPatient(
      patientId,
      category: _selectedCategory,
      query: _searchQuery,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents & Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart_rounded),
            tooltip: 'View Trends',
            onPressed: () => context.push('/trends/hba1c'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (q) => setState(() => _searchQuery = q),
              decoration: InputDecoration(
                hintText: 'Search by test name, case no (e.g. 71016)...',
                hintStyle: TextStyle(color: isDark ? AppColors.darkTextSoft : AppColors.inkLighter, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.brandRed),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
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

          // Category Chips Filter
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                  selectedColor: AppColors.brandRed,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.ink),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Reports List
          Expanded(
            child: reports.isEmpty
                ? EmptyState(
                    icon: Icons.assignment_outlined,
                    title: 'No Documents Found',
                    message: 'No reports match your selected criteria.',
                    actionText: 'Book New Test',
                    onAction: () => context.push('/book-sampling'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final report = reports[idx];
                      return _ReportAccordionCard(report: report, isDark: isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ReportAccordionCard extends StatelessWidget {
  final ReportModel report;
  final bool isDark;

  const _ReportAccordionCard({required this.report, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.brandPeach.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            report.isRadiology ? Icons.document_scanner_rounded : Icons.biotech_rounded,
            color: AppColors.brandRed,
          ),
        ),
        title: Text(
          report.testName,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
            Text(
              'Case: ${report.caseNumber} • ${DateFormat("dd MMM yyyy").format(report.date)}',
              style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft),
            ),
            const SizedBox(height: 6),
            StatusChip(status: report.overallStatus),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text(
                  'Consultant: ${report.consultantName}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.inkSoft),
                ),
                const SizedBox(height: 6),
                Text(
                  report.doctorRemarks,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.brandRed),
                      label: const Text(
                        'View Full Verified Report',
                        style: TextStyle(color: AppColors.brandRed, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () => context.push('/report/${report.id}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
