import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/app_password_field.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/auth_controller.dart';
import '../widgets/auth_header.dart';

class SetNewPasswordScreen extends GetView<AuthController> {
  const SetNewPasswordScreen({super.key});

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
            'Set New Password',
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
                  Icons.lock_open,
                  color: const Color(0xFF136DEC),
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                const AuthHeader(
                  title: 'Create New Password',
                  subtitle:
                      'Your new password must be different from the previously used password.',
                ),
                SizedBox(height: 32.h),

                // New password
                AppPasswordField(
                  label: 'New Password',
                  hintText: 'At least 8 characters',
                  controller: controller.setNewPasswordController,
                  obscureText: controller.setNewPasswordObscure,
                ),
                SizedBox(height: 16.h),

                // Confirm password
                AppPasswordField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter new password',
                  controller: controller.setConfirmPasswordController,
                  obscureText: controller.setConfirmPasswordObscure,
                ),
                SizedBox(height: 32.h),

                // Reset button
                Obx(
                  () => PrimaryButton(
                    text: controller.isLoading.value
                        ? 'Resetting...'
                        : 'Reset Password',
                    onPressed: controller.isLoading.value
                        ? () {}
                        : controller.onSetNewPassword,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
