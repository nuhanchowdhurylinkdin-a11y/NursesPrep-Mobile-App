import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/app_password_field.dart';
import '../../../../core/common/widgets/app_text_field.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/common/widgets/staggered_fade_in.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/auth_controller.dart';
import '../widgets/auth_bottom_link.dart';
import '../widgets/license_type_selector.dart';
import '../widgets/social_login_section.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: c.textPrimary),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: Text(
            'Create Your Account',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                // Header with icon
                StaggeredFadeIn(
                  index: 0,
                  stagger: const Duration(milliseconds: 60),
                  child: Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF136DEC).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: const Color(0xFF136DEC),
                      size: 40.sp,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                StaggeredFadeIn(
                  index: 1,
                  stagger: const Duration(milliseconds: 60),
                  child: Text(
                    'NursePrep Pro',
                    style: getTextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                StaggeredFadeIn(
                  index: 2,
                  stagger: const Duration(milliseconds: 60),
                  child: Text(
                    'Start your journey to becoming a licensed professional.',
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 16,
                      color: const Color(0xFF4C6C9A),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // Full Name
                StaggeredFadeIn(
                  index: 3,
                  stagger: const Duration(milliseconds: 60),
                  child: AppTextField(
                    label: 'Full Name',
                    hintText: 'e.g. Jane Doe',
                    controller: controller.signUpNameController,
                  ),
                ),
                SizedBox(height: 16.h),

                // Email
                StaggeredFadeIn(
                  index: 4,
                  stagger: const Duration(milliseconds: 60),
                  child: AppTextField(
                    label: 'Email Address',
                    hintText: 'email@nursing.com',
                    controller: controller.signUpEmailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 16.h),

                // Password
                StaggeredFadeIn(
                  index: 5,
                  stagger: const Duration(milliseconds: 60),
                  child: AppPasswordField(
                    label: 'Password',
                    hintText: 'At least 8 characters',
                    controller: controller.signUpPasswordController,
                    obscureText: controller.signUpObscure,
                  ),
                ),
                SizedBox(height: 16.h),

                // Confirm Password
                StaggeredFadeIn(
                  index: 6,
                  stagger: const Duration(milliseconds: 60),
                  child: AppPasswordField(
                    label: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    controller: controller.signUpConfirmPasswordController,
                    obscureText: controller.signUpConfirmObscure,
                  ),
                ),
                SizedBox(height: 24.h),

                // License type selector
                StaggeredFadeIn(
                  index: 7,
                  stagger: const Duration(milliseconds: 60),
                  child: LicenseTypeSelector(
                    selectedIndex: controller.selectedLicenseType,
                  ),
                ),
                SizedBox(height: 16.h),

                // Terms checkbox
                StaggeredFadeIn(
                  index: 8,
                  stagger: const Duration(milliseconds: 60),
                  child: Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Checkbox(
                          value: controller.agreeToTerms.value,
                          onChanged: (v) =>
                              controller.agreeToTerms.value = v ?? false,
                          activeColor: const Color(0xFF0F58BD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: getTextStyle(
                              fontSize: 12,
                              color: const Color(0xFF4C6C9A),
                            ),
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F58BD),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrl(
                                        Uri.parse(
                                            ApiConstants.termsUrl),
                                        mode: LaunchMode.externalApplication,
                                      ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F58BD),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrl(
                                        Uri.parse(
                                            ApiConstants.privacyUrl),
                                        mode: LaunchMode.externalApplication,
                                      ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                SizedBox(height: 24.h),

                // Create Account button
                StaggeredFadeIn(
                  index: 9,
                  stagger: const Duration(milliseconds: 60),
                  child: Obx(
                    () => PrimaryButton(
                      text: controller.isLoading.value
                          ? 'Creating Account...'
                          : 'Create Account',
                      onPressed: controller.isLoading.value
                          ? () {}
                          : controller.onSignUp,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Social login
                StaggeredFadeIn(
                  index: 10,
                  stagger: const Duration(milliseconds: 60),
                  child: SocialLoginSection(
                    onGoogleTap: () => controller.onGoogleLogin(requireTerms: true),
                    onAppleTap: () => controller.onAppleLogin(requireTerms: true),
                  ),
                ),
                SizedBox(height: 24.h),

                // Bottom link
                StaggeredFadeIn(
                  index: 11,
                  stagger: const Duration(milliseconds: 60),
                  child: AuthBottomLink(
                    text: 'Already have an account? ',
                    actionText: 'Log In',
                    onTap: controller.goToLogin,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
