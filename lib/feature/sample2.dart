import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class Sample2Page extends StatelessWidget {
  const Sample2Page({super.key});

  static const name = 'sample2';
  static const path = '/sample2';

  @override
  Widget build(BuildContext context) {
    return const Center(child: Icon(Symbols.abc));
  }
}
