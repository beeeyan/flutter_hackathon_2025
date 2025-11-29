import 'package:flutter/material.dart';

import '../config/app_sizes.dart';
import '../config/theme/theme_extension.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.onPressed,
    this.leading,
    required this.text,
    this.height,
    this.textColor,
    this.backgroundColor,
  });

  final VoidCallback? onPressed;
  final Widget? leading;
  final String text;
  final double? height;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppSizes.s48,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF030213),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: textColor ?? Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              AppGaps.g8,
            ],
            Text(
              text,
              style: Theme.of(context).appTextStyles.textMain.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
