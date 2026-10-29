import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../demo/seed_data.dart';
import '../models/report_model.dart';

class ReportsRepository {
  List<ReportModel> getReportsForPatient(String patientId, {String? category, String? query}) {
    var list = SeedData.reports.where((r) => r.patientId == patientId || patientId == 'all').toList();
    if (category != null && category.isNotEmpty && category != 'All') {
      list = list.where((r) => r.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list.where((r) =>
          r.testName.toLowerCase().contains(q) ||
          r.caseNumber.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  ReportModel? getReportById(String id) {
    try {
      return SeedData.reports.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  // Trend data points for repeated tests
  List<Map<String, dynamic>> getTestTrends(String testType) {
    switch (testType.toLowerCase()) {
      case 'hba1c':
        return [
          {'date': 'Apr 2026', 'val': 6.3},
          {'date': 'Jun 2026', 'val': 6.1},
          {'date': 'Aug 2026', 'val': 6.0},
          {'date': 'Oct 2026', 'val': 5.9},
        ];
      case 'cholesterol':
        return [
          {'date': 'Apr 2026', 'val': 240.0},
          {'date': 'Jun 2026', 'val': 232.0},
          {'date': 'Aug 2026', 'val': 225.0},
          {'date': 'Oct 2026', 'val': 218.0},
        ];
      case 'vitamind':
      default:
        return [
          {'date': 'Apr 2026', 'val': 9.5},
          {'date': 'Jun 2026', 'val': 11.2},
          {'date': 'Aug 2026', 'val': 12.8},
          {'date': 'Oct 2026', 'val': 14.2},
        ];
    }
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) => ReportsRepository());
