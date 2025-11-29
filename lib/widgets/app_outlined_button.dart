import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/app_sizes.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.onPressed,
    this.leading,
    required this.text,
    this.height,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });

  final VoidCallback? onPressed;
  final Widget? leading;
  final String text;
  final double? height;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s24),
      child: SizedBox(
        width: double.infinity,
        height: height ?? 56.h,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.white,
            side: BorderSide(
              color: borderColor ?? const Color(0xFFE0E0E0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: 8.w),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? const Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
