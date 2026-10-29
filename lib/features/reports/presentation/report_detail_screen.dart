import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/report_model.dart';
import '../../../data/repositories/reports_repository.dart';

class ReportDetailScreen extends ConsumerWidget {
  final String reportId;

  const ReportDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsRepo = ref.watch(reportsRepositoryProvider);
    final report = reportsRepo.getReportById(reportId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Report Details')),
        body: const Center(child: Text('Report not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(report.caseNumber),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              AppToast.show(context, title: 'Report Link Copied', message: 'alnoordiagnostic.com/reports/${report.caseNumber}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              AppToast.show(context, title: 'Downloading PDF', message: '${report.testName}.pdf saved to downloads', type: ToastType.success);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient & Case Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
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
                      Text(
                        report.testName,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      StatusChip(status: report.overallStatus),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Patient: ${report.patientName} (${report.patientId})', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('Collected & Analyzed: ${DateFormat("dd MMM yyyy • hh:mm a").format(report.date)}', style: const TextStyle(fontSize: 11, color: AppColors.inkSoft)),
                  Text('Laboratory: Al Noor Central Pathology & Imaging, Shadman, Lahore', style: const TextStyle(fontSize: 11, color: AppColors.inkSoft)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // If Radiology Report: Show Findings & Impression
            if (report.isRadiology) ...[
              const Text('Diagnostic Imaging Findings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.radiologyFindings ?? 'Normal acoustic survey.',
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                    const Divider(height: 24),
                    const Text('IMPRESSION', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.brandRed)),
                    const SizedBox(height: 4),
                    Text(
                      report.radiologyImpression ?? 'Unremarkable.',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // If Pathology Lab Report: Parameters Table
            if (report.parameters.isNotEmpty) ...[
              const Text('Clinical Parameters & Reference Ranges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              ...report.parameters.map((p) => _ParameterTile(param: p, isDark: isDark)),
              const SizedBox(height: 24),
            ],

            // Doctor Remarks & Consultant Signature
            const Text('Consultant Verification & Remarks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.brandCopper.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: AppColors.brandCopper, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          report.consultantName,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report.doctorRemarks,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.inkSoft),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.brandPeach.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Digitally Signed & Validated • Al Noor LIS System',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.brandRed),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Download & Share Actions
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Download PDF Report',
                    icon: Icons.picture_as_pdf_rounded,
                    onPressed: () {
                      AppToast.show(context, title: 'PDF Report Saved', message: 'Saved to device downloads', type: ToastType.success);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => context.push('/live-chat'),
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.brandPeach.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.support_agent_rounded, color: AppColors.brandRed),
                  ),
                  tooltip: 'Ask an Agent about this report',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ParameterTile extends StatelessWidget {
  final ReportParameter param;
  final bool isDark;

  const _ParameterTile({required this.param, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color valColor;
    switch (param.status) {
      case ClinicalStatus.normal:
        valColor = AppColors.success;
        break;
      case ClinicalStatus.borderline:
        valColor = AppColors.warning;
        break;
      case ClinicalStatus.abnormal:
        valColor = AppColors.danger;
        break;
      case ClinicalStatus.pending:
        valColor = AppColors.info;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(param.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              StatusChip(status: param.status),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: param.value,
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: valColor),
                    ),
                    if (param.unit.isNotEmpty)
                      TextSpan(
                        text: ' ${param.unit}',
                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft),
                      ),
                  ],
                ),
              ),
              Text(
                'Ref: ${param.referenceRange}',
                style: const TextStyle(fontSize: 11, color: AppColors.inkSoft),
              ),
            ],
          ),

          // Visual Range Indicator Bar (if numeric)
          if (param.numericValue != null && param.minNormal != null && param.maxNormal != null) ...[
            const SizedBox(height: 10),
            _RangeBar(
              val: param.numericValue!,
              min: param.minNormal!,
              max: param.maxNormal!,
              status: param.status,
            ),
          ],
        ],
      ),
    );
  }
}

class _RangeBar extends StatelessWidget {
  final double val;
  final double min;
  final double max;
  final ClinicalStatus status;

  const _RangeBar({required this.val, required this.min, required this.max, required this.status});

  @override
  Widget build(BuildContext context) {
    // Calculate ratio clamped between 0.05 and 0.95
    final spread = (max - min) * 1.5;
    final start = min - (spread * 0.25);
    final ratio = ((val - start) / spread).clamp(0.05, 0.95);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Background track
            Container(
              height: 6,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.warningLight,
                    AppColors.successLight,
                    AppColors.dangerLight,
                  ],
                ),
              ),
            ),
            // Positioned Indicator
            Positioned(
              left: constraints.maxWidth * ratio - 4,
              child: Container(
                width: 10,
                height: 14,
                decoration: BoxDecoration(
                  color: status == ClinicalStatus.normal ? AppColors.success : (status == ClinicalStatus.borderline ? AppColors.warning : AppColors.danger),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
