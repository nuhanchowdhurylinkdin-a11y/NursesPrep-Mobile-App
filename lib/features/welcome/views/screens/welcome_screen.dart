import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/common/widgets/primary_outlined_button.dart';
import '../../../../core/common/widgets/staggered_fade_in.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/welcome_controller.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});

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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                StaggeredFadeIn(
                  index: 0,
                  stagger: const Duration(milliseconds: 70),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: const Color(0xFF136DEC),
                          size: 30.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'NursePrep Pro',
                          style: getTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero image
                StaggeredFadeIn(
                  index: 1,
                  stagger: const Duration(milliseconds: 70),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.asset(
                      'assets/images/onboarding/welcome.png',
                      width: 370.w,
                      height: 336.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Title
                StaggeredFadeIn(
                  index: 2,
                  stagger: const Duration(milliseconds: 70),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Excellence in Nursing Exam Prep',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Subtitle
                StaggeredFadeIn(
                  index: 3,
                  stagger: const Duration(milliseconds: 70),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      'Master the NCLEX and specialized certifications with our expert-led platform. Trusted by 50,000+ nurses worldwide.',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 16,
                        color: const Color(0xFF4F7396),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // View as Guest button
                StaggeredFadeIn(
                  index: 4,
                  stagger: const Duration(milliseconds: 70),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: PrimaryButton(
                      text: 'View as Guest',
                      onPressed: controller.onViewAsGuest,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // Create Account button
                StaggeredFadeIn(
                  index: 5,
                  stagger: const Duration(milliseconds: 70),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: PrimaryOutlinedButton(
                      text: 'Create Account',
                      onPressed: controller.onCreateAccount,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Already have an account?
                StaggeredFadeIn(
                  index: 6,
                  stagger: const Duration(milliseconds: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4F7396),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.onLogin,
                        child: Text(
                          'Log In',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF136DEC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Trust badges
                StaggeredFadeIn(
                  index: 7,
                  stagger: const Duration(milliseconds: 70),
                  child: Opacity(
                    opacity: 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _trustBadge(Icons.verified_user, 'Certified'),
                        _trustBadge(Icons.school, 'Expert Content'),
                        _trustBadge(Icons.security, 'HIPAA Compliant'),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trustBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4F7396), size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          style: getTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4F7396),
          ),
        ),
      ],
    );
  }
}
