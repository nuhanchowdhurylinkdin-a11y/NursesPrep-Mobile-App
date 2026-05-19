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
import '../widgets/auth_header.dart';
import '../widgets/social_login_section.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

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
            'Login',
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
                StaggeredFadeIn(
                  index: 0,
                  stagger: const Duration(milliseconds: 70),
                  child: const AuthHeader(
                    title: 'Welcome Back',
                    subtitle:
                        'Please enter your credentials to access your study materials and exam prep resources.',
                    showIcon: true,
                  ),
                ),
                SizedBox(height: 32.h),

                // Email
                StaggeredFadeIn(
                  index: 1,
                  stagger: const Duration(milliseconds: 70),
                  child: AppTextField(
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    controller: controller.loginEmailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 16.h),

                // Password
                StaggeredFadeIn(
                  index: 2,
                  stagger: const Duration(milliseconds: 70),
                  child: AppPasswordField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: controller.loginPasswordController,
                    obscureText: controller.loginObscure,
                    labelTrailing: GestureDetector(
                      onTap: controller.onForgotPassword,
                      child: Text(
                        'Forgot password?',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F58BD),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Sign In button
                StaggeredFadeIn(
                  index: 3,
                  stagger: const Duration(milliseconds: 70),
                  child: Obx(
                    () => PrimaryButton(
                      text: controller.isLoading.value
                          ? 'Signing In...'
                          : 'Sign In',
                      onPressed: controller.isLoading.value
                          ? () {}
                          : controller.onLogin,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // Social login
                StaggeredFadeIn(
                  index: 4,
                  stagger: const Duration(milliseconds: 70),
                  child: SocialLoginSection(
                    onGoogleTap: controller.onGoogleLogin,
                    onAppleTap: controller.onAppleLogin,
                  ),
                ),
                SizedBox(height: 32.h),

                // Bottom link
                StaggeredFadeIn(
                  index: 5,
                  stagger: const Duration(milliseconds: 70),
                  child: AuthBottomLink(
                    text: "Don't have an account? ",
                    actionText: 'Create one',
                    onTap: controller.goToSignUp,
                  ),
                ),
                SizedBox(height: 12.h),

                // Terms & Privacy
                StaggeredFadeIn(
                  index: 6,
                  stagger: const Duration(milliseconds: 70),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: getTextStyle(
                        fontSize: 11,
                        color: const Color(0xFF4C6C9A),
                      ),
                      children: [
                        const TextSpan(
                            text: 'By signing in, you agree to our '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: getTextStyle(
                            fontSize: 11,
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
                            fontSize: 11,
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
