import 'package:flutter/material.dart';

// MEMO(abe-tk): サンプルとして`textMain`を用意しているが削除してOK

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.textMain,
  });

  final Color textMain;

  @override
  AppColors copyWith({
    Color? textMain,
  }) {
    return AppColors(
      textMain: textMain ?? this.textMain,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      textMain: Color.lerp(textMain, other.textMain, t)!,
    );
  }

  static const light = AppColors(
    textMain: Color(0xFF1C1C1C),
  );
}
