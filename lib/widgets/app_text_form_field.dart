import 'package:flutter/material.dart';

import '../config/theme/theme_extension.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.minHeight,
  });

  final TextEditingController controller;
  final String? hintText;
  final int? maxLines;
  final int? maxLength;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );

    return SizedBox(
      height: minHeight,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: appTextStyles.t16Regular.copyWith(
            color: appColors.textSecondary,
          ),
          filled: true,
          fillColor: appColors.formFill,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
        ),
      ),
    );
  }
}
