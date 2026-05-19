import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class AccuracyChartCard extends StatelessWidget {
  final double overallAccuracy;
  final double accuracyChange;
  final List<double> weeklyData;
  final List<String> weekDays;

  const AccuracyChartCard({
    super.key,
    required this.overallAccuracy,
    required this.accuracyChange,
    required this.weeklyData,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Accuracy',
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$overallAccuracy%',
                    style: getTextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
              // Change badge
              if (accuracyChange != 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: (accuracyChange > 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444))
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        accuracyChange > 0 ? Iconsax.trend_up : Iconsax.trend_down,
                        size: 14.sp,
                        color: accuracyChange > 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${accuracyChange > 0 ? '+' : ''}$accuracyChange%',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: accuracyChange > 0
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 24.h),
          // Line chart with area fill
          SizedBox(
            height: 176.h,
            child: weeklyData.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.textHint,
                      ),
                    ),
                  )
                : LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                clipData: const FlClipData.all(),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBorderRadius: BorderRadius.circular(8.r),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()}%',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28.h,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= weekDays.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            weekDays[index],
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: c.textHint,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      weeklyData.length,
                      (i) => FlSpot(i.toDouble(), weeklyData[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF3B82F6),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF3B82F6).withValues(alpha: 0.25),
                          const Color(0xFF3B82F6).withValues(alpha: 0.02),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
