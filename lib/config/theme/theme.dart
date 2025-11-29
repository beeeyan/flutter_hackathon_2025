import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

ThemeData lightTheme() {
  final theme = ThemeData();

  const appColors = AppColors.light;
  const appTextStyles = AppTextStyles.light;

  return theme.copyWith(
    extensions: {appColors, appTextStyles},
    scaffoldBackgroundColor: appColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: appColors.white,
      titleTextStyle: appTextStyles.header.copyWith(
        color: appColors.textMain,
      ),
    ),
  );
}
