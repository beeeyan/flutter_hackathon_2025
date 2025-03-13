import 'package:flutter/material.dart';

import '../../gen/fonts.gen.dart';

// MEMO(abe-tk): サンプルとして`textMain`を用意しているが削除してOK

@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({required this.textMain});

  final TextStyle textMain;

  @override
  AppTextStyles copyWith({TextStyle? textMain}) {
    return AppTextStyles(textMain: textMain ?? this.textMain);
  }

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other is! AppTextStyles) {
      return this;
    }
    return AppTextStyles(
      textMain: TextStyle.lerp(textMain, other.textMain, t)!,
    );
  }

  // [fontSize, lineHeight, letterSpacing]はscreenUtilで指定することを想定しているため、
  // themeでAppTextStylesをcopyWithしたものをextensionsに定義して利用する。
  // colorがAppColorsに依存している場合はcontextを利用できないため利用箇所でcopyWithする。
  static const light = AppTextStyles(
    textMain: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontWeight: FontWeight.w500,
    ),
  );
}
