import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/auth_controller.dart';
import '../widgets/auth_header.dart';

class OtpScreen extends GetView<AuthController> {
  const OtpScreen({super.key});

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
            'Verify Code',
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
                  Icons.mark_email_read_outlined,
                  color: const Color(0xFF136DEC),
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                const AuthHeader(
                  title: 'Check Your Email',
                  subtitle:
                      'We sent a 6-digit verification code to your email address. Enter it below to continue.',
                ),
                SizedBox(height: 8.h),
                // Show email
                Obx(
                  () => Text(
                    controller.otpEmail.value,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF136DEC),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // OTP field
                OtpTextField(
                  numberOfFields: 6,
                  filled: true,
                  fillColor: c.fieldBg,
                  borderColor: c.border,
                  focusedBorderColor: const Color(0xFF136DEC),
                  borderRadius: BorderRadius.circular(12.r),
                  fieldWidth: 48.w,
                  showFieldAsBox: true,
                  textStyle: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                  onSubmit: (value) {
                    controller.otpController.text = value;
                  },
                ),
                SizedBox(height: 16.h),

                // Timer
                Obx(
                  () => Text(
                    'Code expires in ${controller.formattedTimer}',
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: controller.timerSeconds.value <= 30
                          ? const Color(0xFFF44336)
                          : const Color(0xFF4C6C9A),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Verify button
                Obx(
                  () => PrimaryButton(
                    text: controller.isLoading.value
                        ? 'Verifying...'
                        : 'Verify Code',
                    onPressed: controller.isLoading.value
                        ? () {}
                        : controller.onVerifyOtp,
                  ),
                ),
                SizedBox(height: 24.h),

                // Resend
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: getTextStyle(
                          fontSize: 14,
                          color: const Color(0xFF4C6C9A),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.canResend.value
                            ? controller.onResendOtp
                            : null,
                        child: Text(
                          'Resend',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: controller.canResend.value
                                ? const Color(0xFF136DEC)
                                : c.textHint,
                          ),
                        ),
                      ),
                    ],
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
