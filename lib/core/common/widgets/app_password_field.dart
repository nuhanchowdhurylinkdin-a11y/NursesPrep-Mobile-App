import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../styles/global_text_style.dart';
import '../../utils/theme/app_colors_extension.dart';

class AppPasswordField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final RxBool obscureText;
  final Widget? labelTrailing;
  final String? Function(String?)? validator;

  const AppPasswordField({
    super.key,
    required this.label,
    required this.hintText,
    required this.obscureText,
    this.controller,
    this.labelTrailing,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
              ),
            ),
            ?labelTrailing,
          ],
        ),
        SizedBox(height: 8.h),
        Obx(
          () => TextFormField(
            controller: controller,
            obscureText: obscureText.value,
            validator: validator,
            style: getTextStyle(
              fontSize: 16,
              color: c.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: getTextStyle(
                fontSize: 16,
                color: c.textHint,
              ),
              filled: true,
              fillColor: c.fieldBg,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 16.h,
              ),
              suffixIcon: GestureDetector(
                onTap: () => obscureText.toggle(),
                child: Icon(
                  obscureText.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: c.textSecondary,
                  size: 24.sp,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: c.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: c.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF136DEC)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFF44336)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
