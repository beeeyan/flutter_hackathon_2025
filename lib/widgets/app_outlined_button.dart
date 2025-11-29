import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/app_sizes.dart';
import '../config/theme/theme_extension.dart';

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
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s24),
      child: SizedBox(
        width: double.infinity,
        height: height ?? 56.h,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? appColors.white,
            side: BorderSide(
              color: borderColor ?? appColors.textSecondary,
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
                style: appTextStyles.t18Medium.copyWith(
                  color: textColor ?? appColors.textMain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
