import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/global_text_style.dart';

class PrimaryOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const PrimaryOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF136DEC).withValues(alpha: 0.1),
          side: BorderSide(
            color: const Color(0xFF136DEC).withValues(alpha: 0.1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF136DEC),
          ),
        ),
      ),
    );
  }
}
