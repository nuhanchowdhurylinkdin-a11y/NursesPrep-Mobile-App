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

class ChangePasswordScreen extends GetView<AuthController> {
  const ChangePasswordScreen({super.key});

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
            'Change Password',
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
                  Icons.shield_outlined,
                  color: const Color(0xFF136DEC),
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                const AuthHeader(
                  title: 'Update Password',
                  subtitle:
                      'For your security, please enter your current password and choose a new one.',
                ),
                SizedBox(height: 32.h),

                // Current password
                AppPasswordField(
                  label: 'Current Password',
                  hintText: 'Enter current password',
                  controller: controller.currentPasswordController,
                  obscureText: controller.currentPasswordObscure,
                ),
                SizedBox(height: 16.h),

                // New password
                AppPasswordField(
                  label: 'New Password',
                  hintText: 'At least 8 characters',
                  controller: controller.newPasswordController,
                  obscureText: controller.newPasswordObscure,
                ),
                SizedBox(height: 16.h),

                // Confirm password
                AppPasswordField(
                  label: 'Confirm New Password',
                  hintText: 'Re-enter new password',
                  controller: controller.confirmPasswordController,
                  obscureText: controller.confirmPasswordObscure,
                ),
                SizedBox(height: 32.h),

                // Update button
                Obx(() => PrimaryButton(
                      text: controller.isLoading.value
                          ? 'Updating...'
                          : 'Update Password',
                      onPressed: controller.isLoading.value
                          ? () {}
                          : controller.onChangePassword,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
