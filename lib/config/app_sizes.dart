import 'package:gap/gap.dart';

/// アプリで使用するサイズ定義をまとめたクラス
/// * paddingやiconサイズなどに利用
/// * 利用例
/// ```dart
/// Padding(
///   padding: const EdgeInsets.all(AppSizes.s16),
///   child: Icon(Icons.home, size: AppSizes.s24),
/// );
/// ```
class AppSizes {
  static const double s1 = 1;
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
  static const double s64 = 64;
}

/// アプリで使用するGap widgetのサイズ定義をまとめたクラス
/// * 主にレイアウトの余白確保に利用
/// * 利用例
/// ```dart
/// Column(
///  children: [
///     Text('Hello'),
///     AppGaps.g16,
///     Text('World'),
///   ],
/// );
/// ```
class AppGaps {
  static const Gap g4 = Gap(AppSizes.s4);
  static const Gap g8 = Gap(AppSizes.s8);
  static const Gap g16 = Gap(AppSizes.s16);
  static const Gap g24 = Gap(AppSizes.s24);
  static const Gap g32 = Gap(AppSizes.s32);
  static const Gap g48 = Gap(AppSizes.s48);
  static const Gap g64 = Gap(AppSizes.s64);
}
