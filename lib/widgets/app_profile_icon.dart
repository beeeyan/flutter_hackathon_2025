import 'package:flutter/material.dart';

/// プロフィール画像を表示するウィジェット
class AppProfileIcon extends StatelessWidget {
  const AppProfileIcon({
    super.key,
    required this.imageUrl,
    required this.size,
  });

  /// 画像のURL
  final String imageUrl;

  /// 画像のサイズ（幅と高さ）
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
