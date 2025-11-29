import 'package:flutter/material.dart';

import '../config/app_sizes.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height,
  });

  final VoidCallback? onPressed;
  final String text;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppSizes.s48,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
