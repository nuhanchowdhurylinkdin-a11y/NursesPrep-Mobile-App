import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/progress_trend_controller.dart';
import '../../model/progress_trend_model.dart';

class ProgressTrendScreen extends GetView<ProgressTrendController> {
  const ProgressTrendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              size: 22.sp,
              color: c.textPrimary,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Progress Trends',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        body: Obx(() {
          final isLoading = controller.isLoading.value;
          final data = controller.data.value;

          return RefreshIndicator(
            onRefresh: controller.fetchTrends,
            color: const Color(0xFF0F58BD),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Obx(() => _TimeFilterTabs(
                        selectedIndex: controller.selectedTimeFilter.value,
                        onChanged: controller.selectTimeFilter,
                      )),
                  SizedBox(height: 12.h),
                  Obx(() => _ModeFilterChips(
                        selectedIndex: controller.selectedModeIndex,
                        onChanged: controller.selectMode,
                      )),
                  SizedBox(height: 16.h),
                  if (isLoading || data == null)
                    const _LoadingBody()
                  else
                    _LoadedBody(data: data),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Loading skeleton ────────────────────────────────────────────────
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Bone(
                  width: double.infinity,
                  height: 86.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Bone(
                  width: double.infinity,
                  height: 86.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Bone(
            width: double.infinity,
            height: 298.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(height: 24.h),
          Bone.text(words: 2, fontSize: 18.sp),
          SizedBox(height: 12.h),
          Bone(
            width: double.infinity,
            height: 240.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(height: 16.h),
          ...List.generate(
            2,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Bone(
                width: double.infinity,
                height: 66.h,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loaded body ─────────────────────────────────────────────────────
class _LoadedBody extends StatelessWidget {
  final ProgressTrendModel data;

  const _LoadedBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Avg Accuracy',
                value: '${data.avgAccuracy.toStringAsFixed(1)}%',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _PredictiveCard(predictive: data.predictiveScore),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _AccuracyChartCard(trendPoints: data.trendPoints),
        SizedBox(height: 24.h),
        Text(
          'Clinical Growth Insight',
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        _InsightCard(insight: data.clinicalGrowthInsight),
        SizedBox(height: 16.h),
        if (data.milestones.isEmpty)
          _buildEmptyMilestones(context)
        else
          ...data.milestones.map(
            (m) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _MilestoneTile(milestone: m),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyMilestones(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.medal_star,
            size: 36.sp,
            color: c.textHint,
          ),
          SizedBox(height: 8.h),
          Text(
            'No milestones yet',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Time filter tabs ────────────────────────────────────────────────
class _TimeFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _TimeFilterTabs({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tabs = ProgressTrendController.tabLabels;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: c.border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = selectedIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: isActive ? c.cardBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? const Color(0xFF0F58BD)
                        : c.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Mode filter chips ──────────────────────────────────────────────
class _ModeFilterChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _ModeFilterChips({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final labels = ProgressTrendController.modeLabels;
    return Row(
      children: List.generate(labels.length, (i) {
        final isActive = selectedIndex == i;
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: GestureDetector(
            onTap: () => onChanged(i),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF0F58BD) : c.cardBg,
                borderRadius: BorderRadius.circular(9999),
                border: isActive
                    ? null
                    : Border.all(color: c.border),
              ),
              child: Text(
                labels[i],
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? Colors.white
                      : c.textSecondary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Stat card ───────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: getTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Predictive score card ───────────────────────────────────────────
class _PredictiveCard extends StatelessWidget {
  final PredictiveScore predictive;

  const _PredictiveCard({required this.predictive});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final levelColor = _colorForLevel(predictive.level);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Predictive Score',
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  predictive.label,
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6.w),
              if (predictive.level.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    predictive.level,
                    style: getTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: levelColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _colorForLevel(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return const Color(0xFF07883B);
      case 'medium':
        return const Color(0xFFB45309);
      case 'low':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF0F58BD);
    }
  }
}

// ─── Accuracy chart card ─────────────────────────────────────────────
class _AccuracyChartCard extends StatelessWidget {
  final List<TrendPoint> trendPoints;

  const _AccuracyChartCard({required this.trendPoints});

  /// Aggregate trend points by date → average accuracy per day, sorted.
  List<MapEntry<DateTime, double>> _aggregateByDate() {
    final map = <String, List<double>>{};
    for (final p in trendPoints) {
      if (p.date.isEmpty) continue;
      map.putIfAbsent(p.date, () => []).add(p.accuracy);
    }
    final entries = map.entries
        .map((e) {
          final avg =
              e.value.reduce((a, b) => a + b) / e.value.length;
          return MapEntry(DateTime.tryParse(e.key), avg);
        })
        .where((e) => e.key != null)
        .map((e) => MapEntry(e.key!, e.value))
        .toList();
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final aggregated = _aggregateByDate();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Accuracy Trend (%)',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Daily performance metric',
                    style: getTextStyle(
                      fontSize: 12,
                      color: c.textHint,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F58BD),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Current',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: c.textBody,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 200.h,
            child: aggregated.isEmpty
                ? Center(
                    child: Text(
                      'No trend data yet',
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: c.textHint,
                      ),
                    ),
                  )
                : _buildChart(context, aggregated),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<MapEntry<DateTime, double>> aggregated) {
    final c = context.appColors;
    final dateFormat = DateFormat('MMM dd');
    final spots = <FlSpot>[];
    for (int i = 0; i < aggregated.length; i++) {
      spots.add(FlSpot(i.toDouble(), aggregated[i].value));
    }

    // Pick up to 4 x-axis label positions.
    final labelPositions = <int>{};
    if (aggregated.length <= 4) {
      labelPositions.addAll(List.generate(aggregated.length, (i) => i));
    } else {
      final step = (aggregated.length - 1) / 3;
      for (int i = 0; i < 4; i++) {
        labelPositions.add((i * step).round());
      }
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: c.tagBg,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (!labelPositions.contains(index)) {
                  return const SizedBox.shrink();
                }
                if (index < 0 || index >= aggregated.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    dateFormat.format(aggregated[index].key),
                    style: getTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: c.textHint,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (aggregated.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.25,
            color: const Color(0xFF0F58BD),
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3.5,
                  color: const Color(0xFF0F58BD),
                  strokeWidth: 2,
                  strokeColor: c.cardBg,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0F58BD).withValues(alpha: 0.15),
                  const Color(0xFF0F58BD).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

// ─── Insight card ────────────────────────────────────────────────────
class _InsightCard extends StatelessWidget {
  final ClinicalGrowthInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F58BD),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Iconsax.lamp_charge,
                  size: 24.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Diagnostic Report',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            insight.narrative.isNotEmpty
                ? insight.narrative
                : 'Not enough data yet to generate a diagnostic report.',
            style: getTextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              lineHeight: 1.55,
            ),
          ),
          if (insight.strongestArea.isNotEmpty ||
              insight.weakestArea.isNotEmpty) ...[
            SizedBox(height: 16.h),
            if (insight.strongestArea.isNotEmpty)
              _buildInsightRow(
                icon: Iconsax.arrow_up_3,
                label: 'Strongest',
                value: insight.strongestArea,
              ),
            if (insight.strongestArea.isNotEmpty &&
                insight.weakestArea.isNotEmpty)
              SizedBox(height: 8.h),
            if (insight.weakestArea.isNotEmpty)
              _buildInsightRow(
                icon: Iconsax.arrow_down,
                label: 'Weakest',
                value: insight.weakestArea,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: Colors.white),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: getTextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Milestone tile ──────────────────────────────────────────────────
class _MilestoneTile extends StatelessWidget {
  final Milestone milestone;

  const _MilestoneTile({required this.milestone});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isExam = milestone.mode.toLowerCase() == 'exam';
    final iconColor =
        isExam ? const Color(0xFF0F58BD) : const Color(0xFF07883B);
    final iconData = isExam ? Iconsax.document_text : Iconsax.tick_circle;
    final dateText = milestone.completedAt != null
        ? DateFormat('MMM dd').format(milestone.completedAt!)
        : '';
    final subtitle = milestone.scorePercentage > 0
        ? 'Score: ${milestone.scorePercentage.toStringAsFixed(0)}%'
        : (isExam ? 'Mock Exam' : 'Practice Session');

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(iconData, size: 22.sp, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: getTextStyle(
                    fontSize: 12,
                    color: c.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (dateText.isNotEmpty)
            Text(
              dateText,
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: c.textHint,
              ),
            ),
        ],
      ),
    );
  }
}
