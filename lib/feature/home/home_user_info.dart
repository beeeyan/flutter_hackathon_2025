import 'package:flutter/material.dart';

class HomeUserInfo extends StatelessWidget {
  const HomeUserInfo({
    super.key,
    required this.iconUrl,
    required this.nickname,
    required this.bio,
  });
  final String iconUrl;
  final String nickname;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.1),
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          // プロフィール画像
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            backgroundImage: iconUrl.isNotEmpty
                ? NetworkImage(iconUrl)
                : null,
            child: iconUrl.isEmpty
                ? Icon(
              Icons.person,
              size: 30,
              color: Colors.grey[600],
            )
                : null,
          ),
          const SizedBox(width: 16),
          // ユーザー情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ニックネーム
                Text(
                  nickname,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                // ひとこと
                Text(
                  bio,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
