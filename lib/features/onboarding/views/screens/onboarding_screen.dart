import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/onboarding_controller.dart';
import '../widgets/analytics_card.dart';
import '../widgets/feature_item_tile.dart';
import '../widgets/mock_question_card.dart';
import '../widgets/page_indicator.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar with Skip
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: controller.skip,
                    child: Text(
                      'Skip',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4C6C9A),
                      ),
                    ),
                  ),
                ),
              ),
              // PageView
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(context, index);
                  },
                ),
              ),
              // Bottom section
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    children: [
                      PageIndicator(
                        count: controller.pages.length,
                        currentIndex: controller.currentPage.value,
                      ),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: PrimaryButton(
                          text: controller.currentPage.value ==
                                  controller.pages.length - 1
                              ? 'Get Started'
                              : 'Continue',
                          onPressed: controller.nextPage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, int index) {
    final c = context.appColors;
    final page = controller.pages[index];
    return SingleChildScrollView(
      child: Column(
        children: [
          // Page-specific top content
          if (index == 0) _buildPageOneTop(),
          if (index == 1) const MockQuestionCard(),
          if (index == 2) const AnalyticsCard(),

          SizedBox(height: 24.h),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              page.title,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: index == 2 ? 30 : 28,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 16,
                color: c.textBody,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Feature items
          ...page.features.map(
            (feature) => FeatureItemTile(item: feature),
          ),
        ],
      ),
    );
  }

  Widget _buildPageOneTop() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.asset(
        'assets/images/onboarding/onboarding_1.png',
        width: double.infinity,
        height: 280.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
