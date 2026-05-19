import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../model/performance_details_model.dart';

const _statusColors = {
  'needs_attention': Color(0xFFF43F5E),
  'moderate': Color(0xFFF59E0B),
  'strong': Color(0xFF10B981),
};

const _statusIcons = {
  'needs_attention': Iconsax.warning_2,
  'moderate': Iconsax.chart,
  'strong': Iconsax.shield_tick,
};

class TopicMasterySection extends StatelessWidget {
  final List<TopicMasteryItem> topics;

  const TopicMasterySection({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      children: [
        // Header
        Text(
          'Topic Mastery',
          style: getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        // Topic cards
        ...topics.map((topic) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _TopicCard(topic: topic),
            )),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  final TopicMasteryItem topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final topicColor =
        _statusColors[topic.status] ?? const Color(0xFF3B82F6);
    final topicIcon =
        _statusIcons[topic.status] ?? Iconsax.book;
    final percent = topic.accuracyRate.round();

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
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: topicColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(topicIcon, size: 24.sp, color: topicColor),
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Text(
                        topic.topicName,
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '$percent%',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: topicColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: topic.accuracyRate / 100,
              minHeight: 10.h,
              backgroundColor: c.tagBg,
              valueColor: AlwaysStoppedAnimation<Color>(topicColor),
            ),
          ),
          SizedBox(height: 8.h),
          // Insight
          if (topic.insight.isNotEmpty)
            Text(
              topic.insight,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: c.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
