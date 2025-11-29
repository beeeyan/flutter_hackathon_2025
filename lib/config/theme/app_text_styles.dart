import 'package:flutter/material.dart';

import '../../gen/fonts.gen.dart';

@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.header,
    required this.t10Medium,
    required this.t12Regular,
    required this.t12Medium,
    required this.t14Regular,
    required this.t14Medium,
    required this.t14Bold,
    required this.t16Regular,
    required this.t16Bold,
    required this.t18Medium,
    required this.t18Bold,
    required this.t20Bold,
    required this.t30Black,
    required this.t48Black,
  });

  final TextStyle header;
  final TextStyle t10Medium;
  final TextStyle t12Regular;
  final TextStyle t12Medium;
  final TextStyle t14Regular;
  final TextStyle t14Medium;
  final TextStyle t14Bold;
  final TextStyle t16Regular;
  final TextStyle t16Bold;
  final TextStyle t18Medium;
  final TextStyle t18Bold;
  final TextStyle t20Bold;
  final TextStyle t30Black;
  final TextStyle t48Black;

  @override
  AppTextStyles copyWith({
    TextStyle? header,
    TextStyle? t10Medium,
    TextStyle? t12Regular,
    TextStyle? t12Medium,
    TextStyle? t14Regular,
    TextStyle? t14Medium,
    TextStyle? t14Bold,
    TextStyle? t16Regular,
    TextStyle? t16Bold,
    TextStyle? t18Medium,
    TextStyle? t18Bold,
    TextStyle? t20Bold,
    TextStyle? t30Black,
    TextStyle? t48Black,
  }) {
    return AppTextStyles(
      header: header ?? this.header,
      t10Medium: t10Medium ?? this.t10Medium,
      t12Regular: t12Regular ?? this.t12Regular,
      t12Medium: t12Medium ?? this.t12Medium,
      t14Regular: t14Regular ?? this.t14Regular,
      t14Medium: t14Medium ?? this.t14Medium,
      t14Bold: t14Bold ?? this.t14Bold,
      t16Regular: t16Regular ?? this.t16Regular,
      t16Bold: t16Bold ?? this.t16Bold,
      t18Medium: t18Medium ?? this.t18Medium,
      t18Bold: t18Bold ?? this.t18Bold,
      t20Bold: t20Bold ?? this.t20Bold,
      t30Black: t30Black ?? this.t30Black,
      t48Black: t48Black ?? this.t48Black,
    );
  }

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other is! AppTextStyles) {
      return this;
    }
    return AppTextStyles(
      header: TextStyle.lerp(header, other.header, t)!,
      t10Medium: TextStyle.lerp(t10Medium, other.t10Medium, t)!,
      t12Regular: TextStyle.lerp(t12Regular, other.t12Regular, t)!,
      t12Medium: TextStyle.lerp(t12Medium, other.t12Medium, t)!,
      t14Regular: TextStyle.lerp(t14Regular, other.t14Regular, t)!,
      t14Medium: TextStyle.lerp(t14Medium, other.t14Medium, t)!,
      t14Bold: TextStyle.lerp(t14Bold, other.t14Bold, t)!,
      t16Regular: TextStyle.lerp(t16Regular, other.t16Regular, t)!,
      t16Bold: TextStyle.lerp(t16Bold, other.t16Bold, t)!,
      t18Medium: TextStyle.lerp(t18Medium, other.t18Medium, t)!,
      t18Bold: TextStyle.lerp(t18Bold, other.t18Bold, t)!,
      t20Bold: TextStyle.lerp(t20Bold, other.t20Bold, t)!,
      t30Black: TextStyle.lerp(t30Black, other.t30Black, t)!,
      t48Black: TextStyle.lerp(t48Black, other.t48Black, t)!,
    );
  }

  static const light = AppTextStyles(
    header: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    t10Medium: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    t12Regular: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    t12Medium: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    t14Regular: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    t14Medium: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    t14Bold: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    t16Regular: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    t16Bold: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    t18Medium: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    t18Bold: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    t20Bold: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    t30Black: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 30,
      fontWeight: FontWeight.w900,
    ),
    t48Black: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontSize: 48,
      fontWeight: FontWeight.w900,
    ),
  );
}
