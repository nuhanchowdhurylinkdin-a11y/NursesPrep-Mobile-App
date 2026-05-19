import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/staggered_fade_in.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../../../profile/controller/profile_controller.dart';
import '../../controller/practice_controller.dart';

class ModeSelectionScreen extends GetView<PracticeController> {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final navController = Get.find<MainNavController>();

    final c = context.appColors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start Session',
              style: getTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            Text(
              'NursePrep Pro',
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F58BD),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Obx(() {
              final url = profileController.avatarUrl;
              return CircleAvatar(
                radius: 20.r,
                backgroundColor: c.border,
                backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
                child: url.isEmpty
                    ? Icon(Iconsax.user,
                        size: 20.sp, color: c.textHint)
                    : null,
              );
            }),
          ),
        ],
      ),
      body: Obx(() {
        final animate = navController.currentIndex.value == 2;
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                StaggeredFadeIn(
                  index: 0,
                  enabled: animate,
                  child: Text(
                    'Choose Your Mode',
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                StaggeredFadeIn(
                  index: 1,
                  enabled: animate,
                  child: Text(
                    'Select how you want to study today',
                    style: getTextStyle(
                      fontSize: 14,
                      color: c.textSecondary,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                // Practice Mode Card
                StaggeredFadeIn(
                  index: 2,
                  enabled: animate,
                  child: _ModeCard(
                    icon: Iconsax.book_1,
                    iconColor: const Color(0xFF0F58BD),
                    iconBgColor:
                        const Color(0xFF0F58BD).withValues(alpha: 0.1),
                    title: 'Practice Mode',
                    subtitle:
                        'Study at your own pace with customizable difficulty levels and randomization options.',
                    features: const [
                      'Select categories & topics',
                      'Choose difficulty level',
                      'Enable randomization',
                      'Choose up to 150 questions per session',
                    ],
                    onTap: () {
                      controller.setMode(PracticeMode.practice);
                      Get.toNamed(AppRoute.getPracticeSetupScreen());
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                // Exam Mode Card
                StaggeredFadeIn(
                  index: 3,
                  enabled: animate,
                  child: _ModeCard(
                    icon: Iconsax.document_text,
                    iconColor: const Color(0xFF059669),
                    iconBgColor:
                        const Color(0xFF059669).withValues(alpha: 0.1),
                    title: 'Exam Mode',
                    subtitle:
                        'Simulate real exam conditions. Questions are randomized with mixed difficulty.',
                    features: const [
                      'Select categories & topics',
                      'Timed exam conditions',
                    ],
                    onTap: () {
                      controller.setMode(PracticeMode.exam);
                      Get.toNamed(AppRoute.getPracticeSetupScreen());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final List<String> features;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 24.sp, color: iconColor),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                Icon(Iconsax.arrow_right_3,
                    size: 20.sp, color: c.textHint),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              subtitle,
              style: getTextStyle(
                fontSize: 13,
                color: c.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            ...features.map((f) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16.sp, color: const Color(0xFF10B981)),
                      SizedBox(width: 8.w),
                      Text(
                        f,
                        style: getTextStyle(
                          fontSize: 13,
                          color: c.textBody,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
