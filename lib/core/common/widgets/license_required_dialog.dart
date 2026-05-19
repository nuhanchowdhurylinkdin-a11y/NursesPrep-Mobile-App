import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/profile/controller/profile_controller.dart';
import '../../../routes/app_routes.dart';
import '../../services/storage_service.dart';
import '../../utils/theme/app_colors_extension.dart';
import '../styles/global_text_style.dart';

class LicenseRequiredDialog {
  LicenseRequiredDialog._();

  static bool get _hasLicense {
    if (StorageService.isGuest) return true;
    final profile = Get.find<ProfileController>();
    return profile.licenseId.isNotEmpty;
  }

  static bool checkAndProceed() {
    if (_hasLicense) return true;
    show();
    return false;
  }

  static Future<void> show() {
    return Get.dialog(
      Builder(builder: (context) {
        final c = context.appColors;
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 32.h),
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Iconsax.warning_2,
                    size: 36.sp,
                    color: const Color(0xFFFFA726),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'License Type Required',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Please update your license type in your profile before accessing this feature.',
                    style: getTextStyle(
                      fontSize: 14,
                      color: c.textBody,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoute.getEditProfileScreen());
                        },
                        child: Container(
                          width: double.infinity,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F58BD),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Update Profile',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: double.infinity,
                          height: 48.h,
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: double.infinity,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726).withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12.r)),
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      }),
      barrierColor: Colors.black.withValues(alpha: 0.3),
    );
  }
}
