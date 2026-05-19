import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/app_text_field.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/auth_controller.dart';
import '../widgets/auth_bottom_link.dart';
import '../widgets/auth_header.dart';

class ResetPasswordScreen extends GetView<AuthController> {
  const ResetPasswordScreen({super.key});

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
            'Reset Password',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 32.h),
                Icon(
                  Icons.lock_reset,
                  color: const Color(0xFF136DEC),
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                const AuthHeader(
                  title: 'Forgot Password?',
                  subtitle:
                      "No worries! Enter the email address associated with your account and we'll send you a verification code.",
                ),
                SizedBox(height: 40.h),

                // Email
                AppTextField(
                  label: 'Email Address',
                  hintText: 'Enter your email',
                  controller: controller.resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Color(0xFF4C6C9A),
                  ),
                ),
                SizedBox(height: 32.h),

                // Send Reset Link
                Obx(
                  () => PrimaryButton(
                    text: controller.isLoading.value
                        ? 'Sending...'
                        : 'Send Verification Code',
                    onPressed: controller.isLoading.value
                        ? () {}
                        : controller.onSendResetLink,
                  ),
                ),
                const Spacer(),
                AuthBottomLink(
                  text: 'Remember your password? ',
                  actionText: 'Log In',
                  onTap: controller.goToLogin,
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
