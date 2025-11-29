import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/state/auth_state.dart';
import '../domain/users.dart';

/// ユーザーリポジトリを提供するプロバイダー
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  return UserRepository(firestore: FirebaseFirestore.instance, uid: uid);
});

/// Firestore のユーザーリポジトリ
class UserRepository {
  UserRepository({required FirebaseFirestore firestore, String? uid})
    : _firestore = firestore,
      _uid = uid;

  final FirebaseFirestore _firestore;
  final String? _uid;

  /// ユーザーコレクションへの参照
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// ユーザードキュメントを作成
  Future<void> createUser({
    required String iconUrl,
    required String nickname,
    required String bio,
  }) async {
    final user = Users(
      iconUrl: iconUrl,
      nickname: nickname,
      bio: bio,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _usersCollection.doc(_uid).set(user.toJson());
  }

  /// ユーザードキュメントを取得する
  Future<Users?> getUser() async {
    final userDoc = await _usersCollection.doc(_uid).get();
    return userDoc.data() != null ? Users.fromJson(userDoc.data()!) : null;
  }

  /// ユーザードキュメントが存在するかチェックする
  Future<bool> userExists() async {
    final userDoc = await _usersCollection.doc(_uid).get();
    return userDoc.exists;
  }
}
