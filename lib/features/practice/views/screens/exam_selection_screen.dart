import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/login_required_dialog.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/quiz_controller.dart';
import '../../model/exam_model.dart';

class ExamSelectionScreen extends GetView<QuizController> {
  const ExamSelectionScreen({super.key});

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
            'Select Exam',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        body: Obx(() {
          final isLoading = controller.isLoadingExams.value;
          final examList = controller.exams;

          if (isLoading) {
            return _buildSkeleton(context);
          }

          if (examList.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.document_text,
                      size: 48.sp, color: c.textHint),
                  SizedBox(height: 12.h),
                  Text(
                    'No exams available',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            itemCount: examList.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, index) => _buildExamCard(context, examList[index]),
          );
        }),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final c = context.appColors;
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: c.cardBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Bone.text(words: 4),
              SizedBox(height: 8.h),
              const Bone.multiText(lines: 2),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Bone(
                    height: 28.h,
                    width: 80.w,
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  SizedBox(width: 8.w),
                  Bone(
                    height: 28.h,
                    width: 80.w,
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  SizedBox(width: 8.w),
                  Bone(
                    height: 28.h,
                    width: 80.w,
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, ExamModel exam) {
    final c = context.appColors;
    return GestureDetector(
      onTap: () {
        if (StorageService.isGuest) {
          LoginRequiredDialog.show(
            message: 'Log in to take exams and view your detailed results.',
          );
          return;
        }
        controller.startExamFromModel(exam);
        Get.toNamed(AppRoute.getQuizScreen());
      },
      child: Container(
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
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Iconsax.document_text,
                      size: 20.sp, color: const Color(0xFF0F58BD)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    exam.title,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right,
                    size: 22.sp, color: c.textHint),
              ],
            ),
            if (exam.description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                exam.description,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: c.textSecondary,
                  lineHeight: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildInfoChip(
                  context: context,
                  icon: Iconsax.message_question,
                  label: '${exam.totalQuestions} Qs',
                ),
                SizedBox(width: 8.w),
                _buildInfoChip(
                  context: context,
                  icon: Iconsax.clock,
                  label: '${exam.timeLimit} min',
                ),
                SizedBox(width: 8.w),
                _buildInfoChip(
                  context: context,
                  icon: Iconsax.chart,
                  label: 'Pass: ${exam.passingScore}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required BuildContext context, required IconData icon, required String label}) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: c.tagBg,
        borderRadius: BorderRadius.circular(9999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: c.textSecondary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
