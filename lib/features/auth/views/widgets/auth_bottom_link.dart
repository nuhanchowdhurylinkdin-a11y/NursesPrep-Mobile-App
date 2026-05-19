import 'package:flutter/material.dart';

import '../../../../core/common/styles/global_text_style.dart';

class AuthBottomLink extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const AuthBottomLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: getTextStyle(
            fontSize: 16,
            color: const Color(0xFF4C6C9A),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F58BD),
            ),
          ),
        ),
      ],
    );
  }
}
