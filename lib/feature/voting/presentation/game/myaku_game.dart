import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';

import '../../../session/domain/member.dart';
import 'image_loader.dart';
import 'member_body.dart';
import 'pulse_effect.dart';

/// 投票画面のメインゲームクラス
class MyakuGame extends Forge2DGame with TapCallbacks {
  MyakuGame()
    : super(
        gravity: Vector2(0, 0.5),
        zoom: 15,
      );

  /// タイムアップフラグ
  bool isTimeUp = false;

  /// ユーザータップ時のコールバック
  void Function(String uid)? onTapUserCallback;

  /// 画像ローダー
  final NetworkImageLoader _imageLoader = NetworkImageLoader();

  /// メンバーボディのマップ {uid: MemberBody}
  final Map<String, MemberBody> _memberBodies = {};

  /// ランダム生成器
  final _random = Random();

  /// ズーム値
  static const double gameZoom = 15;

  /// ソフトバウンダリの上限Y座標
  double _softBoundaryY = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ソフトバウンダリのY座標を設定（画面上端より少し下）
    final worldHeight = size.y / gameZoom;
    _softBoundaryY = -worldHeight / 2 + MemberBody.baseRadius * 2;

    // 壁を生成（左、右、下、上）
    await _createBoundaries();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // ソフトバウンダリ: 上に行きすぎたボールを押し戻す
    for (final memberBody in _memberBodies.values) {
      final pos = memberBody.body.position;
      if (pos.y < _softBoundaryY) {
        // 上に行くほど強い下向きの力を適用
        final overAmount = _softBoundaryY - pos.y;
        final pushForce = overAmount * 50;
        memberBody.body.applyForce(Vector2(0, pushForce));
      }
    }
  }

  /// 壁を生成
  Future<void> _createBoundaries() async {
    final screenSize = size;
    final worldWidth = screenSize.x / gameZoom;
    final worldHeight = screenSize.y / gameZoom;

    // 上壁（安全のため）
    await world.add(
      _WallBody(
        start: Vector2(-worldWidth / 2, -worldHeight / 2),
        end: Vector2(worldWidth / 2, -worldHeight / 2),
      ),
    );

    // 左壁
    await world.add(
      _WallBody(
        start: Vector2(-worldWidth / 2, -worldHeight / 2),
        end: Vector2(-worldWidth / 2, worldHeight / 2),
      ),
    );

    // 右壁
    await world.add(
      _WallBody(
        start: Vector2(worldWidth / 2, -worldHeight / 2),
        end: Vector2(worldWidth / 2, worldHeight / 2),
      ),
    );

    // 下壁
    await world.add(
      _WallBody(
        start: Vector2(-worldWidth / 2, worldHeight / 2),
        end: Vector2(worldWidth / 2, worldHeight / 2),
      ),
    );
  }

  /// メンバーをゲームに追加
  Future<void> addMembers(List<Member> members) async {
    final screenSize = size;
    final worldWidth = screenSize.x / gameZoom;

    // ボールの配置に使う幅（両端にマージン）
    final usableWidth = worldWidth - MemberBody.baseRadius * 4;

    for (var i = 0; i < members.length; i++) {
      final member = members[i];

      // 横方向は均等に配置し、少しランダムなオフセットを加える
      final baseX = -usableWidth / 2 + (i % 5 + 0.5) * (usableWidth / 5);
      final randomOffset = (_random.nextDouble() - 0.5) * MemberBody.baseRadius;
      final x = baseX + randomOffset;

      // 縦方向は画面中央付近から配置
      final row = i ~/ 5;
      final y =
          (row * MemberBody.baseRadius * 2.5) +
          (_random.nextDouble() - 0.5) * 2;

      final memberBody = MemberBody(
        uid: member.uid,
        nickname: member.nickname,
        initialPosition: Vector2(x, y),
      );

      await world.add(memberBody);
      _memberBodies[member.uid] = memberBody;

      // 非同期で画像をロード
      _loadMemberAvatar(member.uid, member.iconUrl);
    }
  }

  /// メンバーのアバター画像をロード
  Future<void> _loadMemberAvatar(String uid, String iconUrl) async {
    final image = await _imageLoader.loadImage(iconUrl);
    if (image != null && _memberBodies.containsKey(uid)) {
      _memberBodies[uid]!.setAvatarImage(image);
    }
  }

  /// 特定メンバーのサイズを更新
  void updateMemberSize(String targetUid, int tapCount) {
    final memberBody = _memberBodies[targetUid];
    if (memberBody != null) {
      memberBody.updateSize(tapCount);
    }
  }

  /// すべてのメンバーのサイズを一括更新（bySenderマップから）
  void updateAllMemberSizes(Map<String, int> bySender) {
    for (final entry in bySender.entries) {
      updateMemberSize(entry.key, entry.value);
    }
  }

  /// インタラクションを停止
  void stopInteraction() {
    isTimeUp = true;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (isTimeUp) return;

    // タップ位置をワールド座標に変換
    final worldPosition = screenToWorld(event.localPosition);

    // タップ位置にあるボディを探す
    MemberBody? tappedMember;

    for (final memberBody in _memberBodies.values) {
      final distance = memberBody.body.position.distanceTo(worldPosition);
      if (distance <= memberBody.currentRadius) {
        tappedMember = memberBody;
        break;
      }
    }

    if (tappedMember != null) {
      // コールバックを呼び出し
      onTapUserCallback?.call(tappedMember.uid);

      // ボールに上向きの衝撃を与える
      tappedMember.body.applyLinearImpulse(Vector2(0, -15));

      // エフェクトを追加
      world.add(
        PulseEffect(position: worldPosition),
      );

      debugPrint('Tapped: ${tappedMember.nickname} (${tappedMember.uid})');
    }
  }

  /// メンバーボディを取得
  MemberBody? getMemberBody(String uid) {
    return _memberBodies[uid];
  }

  /// すべてのメンバーボディを取得
  List<MemberBody> getAllMemberBodies() {
    return _memberBodies.values.toList();
  }
}

/// 壁（静的ボディ）
class _WallBody extends BodyComponent {
  _WallBody({
    required this.start,
    required this.end,
  });

  final Vector2 start;
  final Vector2 end;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2.zero(),
    );

    final body = world.createBody(bodyDef);

    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(
      shape,
      friction: 0.3,
    );

    body.createFixture(fixtureDef);

    return body;
  }
}
