import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/services/network_caller.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isLoading = false.obs;

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
            'Delete Account',
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
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Iconsax.warning_2,
                    size: 36.sp,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Are you sure?',
                  style: getTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'This action is permanent and cannot be undone.',
                  style: getTextStyle(
                    fontSize: 14,
                    color: c.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),

                // Warning cards
                _WarningItem(
                  icon: Iconsax.document_text,
                  text:
                      'All your study progress, exam history, and saved data will be permanently deleted.',
                ),
                SizedBox(height: 12.h),
                _WarningItem(
                  icon: Iconsax.card,
                  text:
                      'Your active subscription will be cancelled immediately with no refund.',
                ),
                SizedBox(height: 12.h),
                _WarningItem(
                  icon: Iconsax.user_remove,
                  text:
                      'Your account cannot be recovered once deleted. You will need to create a new account to use NursePrep Pro.',
                ),

                const Spacer(),

                // Delete button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () => _confirmDelete(context, isLoading),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        elevation: 0,
                      ),
                      child: Text(
                        isLoading.value ? 'Deleting...' : 'Delete My Account',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
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
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, RxBool isLoading) {
    final c = context.appColors;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: c.cardBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.trash,
                  size: 28.sp,
                  color: const Color(0xFFDC2626),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Final Confirmation',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'This will permanently delete your account and all associated data. This cannot be undone.',
                style: getTextStyle(
                  fontSize: 14,
                  color: c.textBody,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () async {
                  Get.back(); // close dialog
                  isLoading.value = true;
                  try {
                    final response = await NetworkCaller().deleteRequest(
                      ApiConstants.deleteAccount,
                    );
                    if (response.isSuccess) {
                      await StorageService.logoutUser();
                      final message =
                          response.responseData['data']?['message'] ??
                              response.responseData['message'] ??
                              'Account deleted successfully';
                      AppHelperFunctions.showSuccessSnackBar(message);
                      Get.offAllNamed(AppRoute.getWelcomeScreen());
                    } else {
                      AppHelperFunctions.showErrorSnackBar(
                        response.errorMessage,
                      );
                    }
                  } catch (e) {
                    AppHelperFunctions.showErrorSnackBar(
                      'Failed to delete account',
                    );
                  } finally {
                    isLoading.value = false;
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Yes, Delete',
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
      ),
    );
  }
}

class _WarningItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _WarningItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1515) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? const Color(0xFF5C2020) : const Color(0xFFFECACA),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: const Color(0xFFDC2626)),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: getTextStyle(
                fontSize: 13,
                color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
