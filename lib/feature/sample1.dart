import 'package:flutter/material.dart';

import '../config/theme/theme_extension.dart';

class Sample1Page extends StatelessWidget {
  const Sample1Page({super.key});

  static const name = 'sample1';
  static const path = '/sample1';

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
    return Center(
      child: Text(
        'Sample 1',
        style: appTextStyles.textMain.copyWith(color: appColors.textMain),
      ),
    );
  }
}
