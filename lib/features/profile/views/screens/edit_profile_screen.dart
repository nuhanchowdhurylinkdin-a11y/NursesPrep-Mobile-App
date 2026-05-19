import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/profile_controller.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final nameController =
        TextEditingController(text: controller.fullName);
    final emailController =
        TextEditingController(text: controller.email);

    final selectedLicenseId = (controller.licenseId).obs;
    final selectedLicenseName = (controller.licenseName).obs;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          centerTitle: true,
          title: Text(
            'Edit Profile',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F58BD),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              // Avatar
              Obx(() {
                final image = controller.profileImage.value;
                final url = controller.avatarUrl;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showImagePickerSheet(context),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 64.r,
                            backgroundColor: c.border,
                            backgroundImage: image != null
                                ? FileImage(image)
                                : (url.isNotEmpty
                                    ? NetworkImage(url)
                                    : null),
                            child: image == null && url.isEmpty
                                ? Icon(Iconsax.user,
                                    size: 56.sp,
                                    color: c.textHint)
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F58BD),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: c.cardBg, width: 2.w),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.camera_alt,
                                  size: 14.sp, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () => _showImagePickerSheet(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F58BD)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Change Photo',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F58BD),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 24.h),

              // Full Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: c.fieldBg,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: c.border),
                      ),
                      child: TextField(
                        controller: nameController,
                        style: getTextStyle(
                          fontSize: 16,
                          color: c.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Email Address (read-only)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: c.fieldBg,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: c.border),
                      ),
                      child: TextField(
                        controller: emailController,
                        readOnly: true,
                        style: getTextStyle(
                          fontSize: 16,
                          color: c.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Your email is used for login and exam certificate delivery.',
                      style: getTextStyle(
                        fontSize: 12,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Current License Status
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current License Status',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() => GestureDetector(
                          onTap: () => _showLicensePicker(
                            context,
                            selectedLicenseId,
                            selectedLicenseName,
                          ),
                          child: Container(
                            height: 56.h,
                            padding:
                                EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: c.fieldBg,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: c.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedLicenseName.value,
                                    style: getTextStyle(
                                      fontSize: 16,
                                      color: c.textPrimary,
                                    ),
                                  ),
                                ),
                                Icon(Iconsax.arrow_down_1,
                                    size: 20.sp,
                                    color: c.textSecondary),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Save button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(() => GestureDetector(
                      onTap: controller.isUpdating.value
                          ? null
                          : () async {
                              await controller.updateProfile(
                                name: nameController.text,
                                licenseOptionId: selectedLicenseId.value,
                              );
                              Get.back();
                            },
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: controller.isUpdating.value
                              ? const Color(0xFF0F58BD)
                                  .withValues(alpha: 0.5)
                              : const Color(0xFF0F58BD),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: controller.isUpdating.value
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )),
              ),
              SizedBox(height: 16.h),
              Obx(() {
                final updated = controller.profile.value?.updatedAt;
                final text = updated != null
                    ? 'Last updated on ${DateFormat('MMM dd, yyyy').format(updated)}'
                    : '';
                return Text(
                  text,
                  style: getTextStyle(
                    fontSize: 12,
                    color: c.textHint,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerSheet(BuildContext context) {
    final c = context.appColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Change Profile Photo',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF0F58BD).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.camera_alt,
                      size: 24.sp, color: const Color(0xFF0F58BD)),
                ),
                title: Text('Take Photo',
                    style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: c.textPrimary)),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF0F58BD).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Iconsax.gallery,
                      size: 24.sp, color: const Color(0xFF0F58BD)),
                ),
                title: Text('Choose from Gallery',
                    style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: c.textPrimary)),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLicensePicker(
    BuildContext context,
    RxString selectedId,
    RxString selectedName,
  ) {
    final c = context.appColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Obx(() {
            final options = controller.licenses;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Select License Type',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                if (options.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: const CircularProgressIndicator(
                      color: Color(0xFF0F58BD),
                    ),
                  )
                else
                  ...options.map((opt) => ListTile(
                        title: Text(opt.name,
                            style: getTextStyle(
                                fontSize: 16,
                                color: c.textPrimary)),
                        trailing: Obx(() => selectedId.value == opt.id
                            ? Icon(Icons.check_circle,
                                color: const Color(0xFF0F58BD),
                                size: 24.sp)
                            : const SizedBox.shrink()),
                        onTap: () {
                          selectedId.value = opt.id;
                          selectedName.value = opt.name;
                          Get.back();
                        },
                      )),
              ],
            );
          }),
        ),
      ),
    );
  }
}
