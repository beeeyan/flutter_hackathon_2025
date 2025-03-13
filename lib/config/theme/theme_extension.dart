import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

extension ThemeDataExtension on ThemeData {
  AppColors get appColors => extension<AppColors>()!;
  AppTextStyles get appTextStyles => extension<AppTextStyles>()!;
}
