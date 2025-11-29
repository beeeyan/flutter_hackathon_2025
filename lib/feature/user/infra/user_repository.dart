import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../auth/application/state/auth_state.dart';
import '../domain/users.dart';

/// ユーザーリポジトリを提供するプロバイダー
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  return UserRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
    uid: uid,
  );
});

/// Firestore のユーザーリポジトリ
class UserRepository {
  UserRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    String? uid,
  }) : _firestore = firestore,
       _storage = storage,
       _uid = uid;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String? _uid;
  static const _uuid = Uuid();

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

  /// 画像を選択してアップロードする
  /// 戻り値: アップロードされた画像のURL
  Future<String?> pickAndUploadIcon() async {
    final picker = ImagePicker();

    // 画像を選択（ギャラリーから）
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // 画像品質を85%に設定（ファイルサイズを抑える）
    );

    if (image == null) {
      return null;
    }

    // ファイル名を生成（UUIDでユニークに）
    final uniqueId = _uuid.v4();
    final fileName = 'profile_images/$uniqueId.jpg';

    // ファイルをアップロード
    final ref = _storage.ref().child(fileName);
    final file = File(image.path);
    await ref.putFile(file);

    // ダウンロードURLを取得
    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }
}
