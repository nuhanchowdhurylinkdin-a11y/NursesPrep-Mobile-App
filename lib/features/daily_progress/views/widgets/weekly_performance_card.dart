import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class WeeklyPerformanceCard extends StatelessWidget {
  final int totalQuestions;
  final String changeText;
  final List<double> weeklyData;
  final List<String> weekDays;

  const WeeklyPerformanceCard({
    super.key,
    required this.totalQuestions,
    required this.changeText,
    required this.weeklyData,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final maxVal = weeklyData.isEmpty
        ? 10.0
        : weeklyData.reduce((a, b) => a > b ? a : b);
    final isPositiveChange = changeText.startsWith('+');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Performance',
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Last 7 Days Activity',
                      style: getTextStyle(
                        fontSize: 14,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$totalQuestions',
                    style: getTextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  Text(
                    changeText,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isPositiveChange
                          ? const Color(0xFF07883B)
                          : c.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Bar chart
          SizedBox(
            height: 160.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal + 10,
                minY: 0,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24.h,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= weekDays.length) {
                          return const SizedBox.shrink();
                        }
                        final isToday = index == weekDays.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            weekDays[index],
                            style: getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isToday
                                  ? const Color(0xFF0F58BD)
                                  : c.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(weeklyData.length, (index) {
                  final isToday = index == weeklyData.length - 1;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: weeklyData[index],
                        width: 28.w,
                        borderRadius: BorderRadius.circular(4.r),
                        color: isToday
                            ? const Color(0xFF0F58BD)
                            : const Color(0xFF0F58BD).withValues(alpha: 0.2),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
