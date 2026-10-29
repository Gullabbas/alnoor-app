import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/reports_repository.dart';

class TrendsScreen extends ConsumerStatefulWidget {
  final String initialTest;

  const TrendsScreen({super.key, this.initialTest = 'hba1c'});

  @override
  ConsumerState<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends ConsumerState<TrendsScreen> {
  late String _currentTest;

  @override
  void initState() {
    super.initState();
    _currentTest = widget.initialTest;
  }

  @override
  Widget build(BuildContext context) {
    final reportsRepo = ref.watch(reportsRepositoryProvider);
    final data = reportsRepo.getTestTrends(_currentTest);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spots = data.asMap().entries.map((e) {
      final val = (e.value['val'] as num).toDouble();
      return FlSpot(e.key.toDouble(), val);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Health Trends'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _testChip('hba1c', 'HbA1c (Blood Sugar %)', isDark),
                  const SizedBox(width: 8),
                  _testChip('cholesterol', 'Lipid / Cholesterol (mg/dL)', isDark),
                  const SizedBox(width: 8),
                  _testChip('vitamind', 'Vitamin D 25-OH (ng/mL)', isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Chart Container
            Container(
              height: 280,
              padding: const EdgeInsets.fromLTRB(16, 24, 20, 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: isDark ? Colors.white10 : Colors.black12,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, _) {
                          final idx = val.toInt();
                          if (idx >= 0 && idx < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                data[idx]['date'] as String,
                                style: const TextStyle(fontSize: 10, color: AppColors.inkSoft),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.brandRed,
                      barWidth: 3.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 5,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: AppColors.brandRed,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.brandRed.withValues(alpha: 0.25),
                            AppColors.brandRed.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Reading History Table
            const Text(
              'Sequential Test Logs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            ...data.reversed.map((d) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(d['date'] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(
                      '${d['val']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: AppColors.brandRed,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _testChip(String id, String label, bool isDark) {
    final isSelected = _currentTest == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _currentTest = id),
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
  }
}
