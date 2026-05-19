import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/login_required_dialog.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../home/controller/home_controller.dart';
import '../../controller/practice_controller.dart';
import '../../controller/quiz_controller.dart';

const _topicIcons = [
  Iconsax.heart,
  Iconsax.shield_tick,
  Iconsax.cpu,
  Iconsax.cup,
  Iconsax.wind,
  Iconsax.flash_1,
  Iconsax.drop,
  Iconsax.activity,
  Iconsax.microscope,
];

const _topicColors = [
  Color(0xFF0F58BD),
  Color(0xFF059669),
  Color(0xFF4F46E5),
  Color(0xFFEA580C),
  Color(0xFF0284C7),
  Color(0xFFDC2626),
  Color(0xFF9333EA),
  Color(0xFFD97706),
  Color(0xFF0891B2),
];

const _topicBgColors = [
  Color(0xFFEFF6FF),
  Color(0xFFECFDF5),
  Color(0xFFEEF2FF),
  Color(0xFFFFF7ED),
  Color(0xFFF0F9FF),
  Color(0xFFFEF2F2),
  Color(0xFFFAF5FF),
  Color(0xFFFFFBEB),
  Color(0xFFECFEFF),
];

class TopicSelectionScreen extends GetView<PracticeController> {
  const TopicSelectionScreen({super.key});

  void _startQuiz(String topicId) {
    if (StorageService.isGuest) {
      LoginRequiredDialog.show(
        message:
            'Log in to start a practice session and track your performance.',
      );
      return;
    }

    final homeController = Get.find<HomeController>();
    final quizController = Get.put(QuizController());
    final categoryId = controller.selectedCategoryId.value.isNotEmpty
        ? controller.selectedCategoryId.value
        : null;

    if (controller.isPracticeMode) {
      quizController.startSession(
        mode: 'practice',
        licenseType: homeController.licenseName.value,
        difficultyId: controller.selectedDifficultyId,
        categoryId: categoryId,
        topicId: topicId,
        questionCount: controller.questionCount.value,
        randomize: controller.randomize.value,
      );
      Get.toNamed(AppRoute.getQuizScreen());
    } else {
      quizController.fetchExams(
        licenseType: homeController.licenseName.value,
        categoryId: categoryId,
        topicId: topicId,
      );
      Get.toNamed(AppRoute.getExamSelectionScreen());
    }
  }

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
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          centerTitle: true,
          title: Text(
            'Select Topics',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          actions: [
            Obx(() => controller.selectedTopicIds.isNotEmpty
                ? GestureDetector(
                    onTap: () => controller.selectedTopicIds.clear(),
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Center(
                        child: Text(
                          'Clear',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F58BD),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
        body: Column(
          children: [
            Obx(() => Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    '${controller.selectedTopicIds.length} of ${controller.topics.length} topics selected',
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.textSecondary,
                    ),
                  ),
                )),
            Expanded(
              child: Obx(() => ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: controller.topics.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (_, index) {
                      final topic = controller.topics[index];
                      final color =
                          _topicColors[index % _topicColors.length];
                      final bgColor =
                          _topicBgColors[index % _topicBgColors.length];
                      final icon =
                          _topicIcons[index % _topicIcons.length];

                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: c.cardBg,
                          borderRadius: BorderRadius.circular(12.r),
                          border:
                              Border.all(color: c.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              alignment: Alignment.center,
                              child:
                                  Icon(icon, size: 20.sp, color: color),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                topic.topicName,
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: c.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _startQuiz(topic.id),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F58BD),
                                  borderRadius:
                                      BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  controller.isPracticeMode
                                      ? 'Start Quiz'
                                      : 'View Exams',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
