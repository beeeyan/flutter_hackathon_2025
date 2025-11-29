import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.textMain,
    required this.textSecondary,
    required this.formFill,
    required this.containerFill,
    required this.yellow,
    required this.pink,
    required this.black,
    required this.white,
  });

  final Color textMain;
  final Color textSecondary;
  final Color formFill;
  final Color containerFill;
  final Color yellow;
  final Color pink;
  final Color black;
  final Color white;

  @override
  AppColors copyWith({
    Color? textMain,
    Color? textSecondary,
    Color? formFill,
    Color? containerFill,
    Color? yellow,
    Color? pink,
    Color? black,
    Color? white,
  }) {
    return AppColors(
      textMain: textMain ?? this.textMain,
      textSecondary: textSecondary ?? this.textSecondary,
      formFill: formFill ?? this.formFill,
      containerFill: containerFill ?? this.containerFill,
      yellow: yellow ?? this.yellow,
      pink: pink ?? this.pink,
      black: black ?? this.black,
      white: white ?? this.white,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      textMain: Color.lerp(textMain, other.textMain, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      formFill: Color.lerp(formFill, other.formFill, t)!,
      containerFill: Color.lerp(containerFill, other.containerFill, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      black: Color.lerp(black, other.black, t)!,
      white: Color.lerp(white, other.white, t)!,
    );
  }

  static const light = AppColors(
    textMain: Color(0xFF0A0A0A),
    textSecondary: Color(0xFF717182),
    formFill: Color(0xFFF3F3F5),
    containerFill: Color(0xFF030213),
    yellow: Color(0xFFFDC700),
    pink: Color(0xFFF44336),
    black: Color(0xFF030213),
    white: Color(0xFFFFFFFF),
  );
}
