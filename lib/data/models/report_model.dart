import '../../core/widgets/status_chip.dart';

class ReportParameter {
  final String name;
  final String value;
  final double? numericValue;
  final String unit;
  final String referenceRange;
  final double? minNormal;
  final double? maxNormal;
  final ClinicalStatus status;

  const ReportParameter({
    required this.name,
    required this.value,
    this.numericValue,
    required this.unit,
    required this.referenceRange,
    this.minNormal,
    this.maxNormal,
    required this.status,
  });
}

class ReportModel {
  final String id;
  final String caseNumber;
  final String patientId;
  final String patientName;
  final String testName;
  final String category; // Pathology, Radiology, Cardiology, Prescriptions, Invoices
  final DateTime date;
  final ClinicalStatus overallStatus;
  final String doctorRemarks;
  final String consultantName;
  final List<ReportParameter> parameters;
  final bool isRadiology;
  final String? radiologyFindings;
  final String? radiologyImpression;

  const ReportModel({
    required this.id,
    required this.caseNumber,
    required this.patientId,
    required this.patientName,
    required this.testName,
    required this.category,
    required this.date,
    required this.overallStatus,
    required this.doctorRemarks,
    this.consultantName = 'Prof. Dr. Safdar Ali Malik (Consultant Radiologist & Pathologist)',
    required this.parameters,
    this.isRadiology = false,
    this.radiologyFindings,
    this.radiologyImpression,
  });
}
