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
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
    return SizedBox(
      height: height ?? AppSizes.s48,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? appColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: textColor ?? appColors.white,
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
              style: appTextStyles.t18Medium.copyWith(
                color: textColor ?? appColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
