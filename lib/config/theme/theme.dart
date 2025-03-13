import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

ThemeData lightTheme() {
  /*
   MD3のColorSchemeを利用する場合はthemeを下記例のように設定する。
   ColorScheme class：https://api.flutter.dev/flutter/material/ColorScheme-class.html

   例）
   final theme = ThemeData.from(
     useMaterial3: true,
     colorScheme: AppColorSchemes.lightColorScheme,
   );
   */
  final theme = ThemeData();

  final appTextStyles = AppTextStyles.light.copyWith(
    textMain: AppTextStyles.light.textMain.copyWith(
      fontSize: 13.h,
      height: 15 / 13,
      letterSpacing: 13.h * 0.1,
    ),
  );

  return theme.copyWith(
    extensions: {AppColors.light, appTextStyles},

    /*
     MD3のTextThemeを利用する場合はtextThemeを下記例のように設定する。
     利用箇所ではextension利用時とは異なり、
     「style: Theme.of(context).textTheme.labelLarge,」のように指定する。
     TextTheme class：https://api.flutter.dev/flutter/material/TextTheme-class.html

     例）
     textTheme: theme.textTheme.copyWith(
       labelLarge: appTextStyles.textMain
         .copyWith(fontSize: 14, height: 1.5, letterSpacing: 14 * 0.1)
         .apply(fontFamily: FontFamily.notoSansJP),
       ),
     */
  );
}
