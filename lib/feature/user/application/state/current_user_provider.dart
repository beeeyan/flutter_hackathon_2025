import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/users.dart';
import '../../infra/user_repository.dart';

/// 現在のユーザー情報を取得するFutureProvider
final currentUserProvider = FutureProvider<Users?>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  final user = await userRepository.getUser();
  return user;
});
