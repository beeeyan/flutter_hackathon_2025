# PG005 投票メイン画面 実装方針書

## 1. 概要

PG005（投票メイン画面）を、Flame/Forge2D 物理演算を用いたインタラクティブな投票画面として実装する。
参加者のアバターがボールとして上から落下し、タップすることで巨大化・バウンドする仕組みを、Firestore リアルタイム同期と連携して構築する。

---

## 2. 設定値

| 項目             | 値                        | 備考                                   |
| ---------------- | ------------------------- | -------------------------------------- |
| 投票時間         | 60 秒                     | クライアントサイドでカウントダウン     |
| 持ち点上限       | 100 回                    | 1 タップ = 1 ポイント消費              |
| 重力             | `Vector2(0, 30.0)`        | 下方向。ボールが早く積み重なるよう重め |
| ボール基本半径   | 3.0（メートル換算）       | Forge2D 内の物理単位                   |
| ズーム           | 10.0 〜 20.0              | 画面サイズに応じて調整                 |
| 送信キュー閾値   | 20 回 or 1 秒経過         | Firestore への書き込み頻度を抑制       |
| ボール巨大化係数 | `newRadius = base + 0.1n` | n = 被投票数。上限設定推奨             |

---

## 3. ファイル構成

### 既存ファイル（再利用）

```
lib/feature/session/domain/
├── session.dart                        # Sessionモデル (Freezed) ※既存
└── member.dart                         # Memberモデル (Freezed) ※既存
```

### 新規作成ファイル

```
lib/feature/voting/
├── voting_page.dart                    # メインページ（GameWidget + Overlay UI）
├── application/
│   └── state/
│       ├── voting_state.dart           # タイマー・持ち点・送信キュー状態
│       └── voting_provider.dart        # 各種Provider定義（モックデータ含む）
└── presentation/
    └── game/
        ├── myaku_game.dart             # Forge2DGame継承クラス
        ├── member_body.dart            # 参加者ボール (BodyComponent)
        ├── pulse_effect.dart           # タップエフェクト
        └── image_loader.dart           # ネットワーク画像ローダー
```

### 別実装者が担当中（本実装では作成しない）

```
lib/feature/voting/infra/
└── voting_repository.dart              # Firestoreアクセス ※別担当
```

---

## 4. 各ファイルの責務

### 4.1 `voting_page.dart`

- `GameWidget` を `Stack` の最背面に配置
- Flutter UI（タイマー E01、持ち点 E02、終了オーバーレイ E06〜E09）を `Positioned` でオーバーレイ
- `HookConsumerWidget` を使用し、Riverpod Provider を購読
- タイマー 0 秒到達時に終了オーバーレイを表示、Host/Guest で表示を分岐

### 4.2 `application/state/voting_state.dart`

Freezed を使用した状態クラス：

```dart
@freezed
class VotingState with _$VotingState {
  const factory VotingState({
    @Default(60) int remainingSeconds,      // 残り時間
    @Default(100) int remainingPoints,      // 残り持ち点
    @Default(false) bool isTimeUp,          // タイムアップフラグ
    @Default({}) Map<String, int> sendQueue, // 送信待ちキュー {targetUid: count}
  }) = _VotingState;
}
```

### 4.3 `application/state/voting_provider.dart`

| Provider 名                | 種別           | 責務                                           | モック対応                 |
| -------------------------- | -------------- | ---------------------------------------------- | -------------------------- |
| `votingStateProvider`      | StateNotifier  | VotingState の管理（タイマー、持ち点、キュー） | -                          |
| `sessionStreamProvider`    | StreamProvider | `sessions/{sessionId}` のリアルタイム監視      | モック Session 返却        |
| `membersStreamProvider`    | StreamProvider | `members` サブコレクションのリアルタイム監視   | モック Member リスト返却   |
| `myMemberStreamProvider`   | StreamProvider | 自分の `members/{myUid}` の被投票数監視        | モック Member 返却         |
| `currentSessionIdProvider` | StateProvider  | 現在参加中のセッション ID                      | 固定値 `'mock-session-id'` |

#### モックデータ例

```dart
// TODO: infra層完成後に実際のFirestoreストリームに差し替え
final sessionStreamProvider = StreamProvider<Session>((ref) {
  // モック: 固定のSessionを返す
  return Stream.value(Session(
    id: 'mock-session-id',
    name: 'テストセッション',
    hostUid: 'mock-host-uid',
    qrCode: 'SES-TEST-1234',
    status: 'active',
    joinedAt: DateTime.now(),
    lastActiveAt: DateTime.now(),
  ));
});

final membersStreamProvider = StreamProvider<List<Member>>((ref) {
  // モック: テスト用メンバーリストを返す
  return Stream.value([
    Member(
      uid: 'user-1',
      iconUrl: 'https://i.pravatar.cc/150?img=1',
      nickname: 'たろう',
      bio: 'よろしく！',
      joinedAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    ),
    Member(
      uid: 'user-2',
      iconUrl: 'https://i.pravatar.cc/150?img=2',
      nickname: 'はなこ',
      bio: 'こんにちは',
      joinedAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    ),
    // ... 他のテストメンバー
  ]);
});
```

### 4.4 既存モデル（`lib/feature/session/domain/`）

#### `session.dart`（既存・変更不要）

```dart
@freezed
abstract class Session with _$Session {
  const factory Session({
    String? id,              // FirestoreドキュメントのID
    String? name,
    required String hostUid,
    required String qrCode,
    @Default('waiting') String status,  // 'waiting' | 'active' | 'result'
    @TimestampConverter() required DateTime joinedAt,
    @TimestampConverter() required DateTime lastActiveAt,
  }) = _Session;
}
```

#### `member.dart`（既存・変更不要）

```dart
@freezed
abstract class Member with _$Member {
  const factory Member({
    required String uid,
    required String iconUrl,
    required String nickname,
    required String bio,
    @TimestampConverter() required DateTime joinedAt,
    @TimestampConverter() required DateTime lastActiveAt,
    @Default(true) bool isActive,
    @Default('member') String role,        // 'host' | 'member'
    @Default({}) Map<String, int> bySender, // 被投票: {senderUid: count}
    @Default({}) Map<String, int> sended,   // 投票済: {targetUid: count}
  }) = _Member;
}
```

### 4.5 `infra/voting_repository.dart`（別担当 - 本実装では作成しない）

> ⚠️ 以下は別の実装者が担当中。完成後、Provider 層のモックを実装に差し替える。

| メソッド                                 | 処理内容                                       |
| ---------------------------------------- | ---------------------------------------------- |
| `streamSession(sessionId)`               | セッションドキュメントの Stream を返す         |
| `streamMembers(sessionId)`               | メンバーコレクションの Stream を返す           |
| `streamMyMember(sessionId, myUid)`       | 自分のメンバードキュメントの Stream を返す     |
| `incrementVotes(sessionId, votes)`       | バッチ処理で複数ターゲットの `bySender` を更新 |
| `updateSessionStatus(sessionId, status)` | セッションの `status` フィールドを更新         |

#### 統合時の差し替え箇所

```dart
// Before (モック)
final sessionStreamProvider = StreamProvider<Session>((ref) {
  return Stream.value(mockSession);
});

// After (実装)
final sessionStreamProvider = StreamProvider<Session>((ref) {
  final sessionId = ref.watch(currentSessionIdProvider);
  final repository = ref.watch(votingRepositoryProvider);
  return repository.streamSession(sessionId);
});
```

### 4.6 `presentation/game/myaku_game.dart`

`Forge2DGame` を継承したメインゲームクラス：

```dart
class MyakuGame extends Forge2DGame with TapCallbacks {
  MyakuGame() : super(gravity: Vector2(0, 30.0), zoom: 15.0);

  bool isTimeUp = false;
  Function(String uid)? onTapUserCallback;

  // 公開メソッド
  Future<void> addMembers(List<Member> members);
  void updateMemberSize(String targetUid, int tapCount);
  void stopInteraction();
}
```

- `onLoad()`: 壁（Left, Right, Bottom）を生成
- `onTapDown()`: タップ位置のボディを検出 → コールバック → エフェクト追加

### 4.7 `presentation/game/member_body.dart`

`BodyComponent` を継承した参加者ボール：

```dart
class MemberBody extends BodyComponent {
  final String uid;
  final String name;
  final Sprite? avatarSprite;

  static const double baseRadius = 3.0;
  double currentRadius = baseRadius;

  // サイズ更新メソッド
  void updateSize(int tapCount);
}
```

- 物理属性: 密度 1.0、摩擦 0.3、反発 0.4
- `render()`: アバター画像を円形にクリップして描画

### 4.8 `presentation/game/pulse_effect.dart`

タップ時の視覚フィードバック：

```dart
class PulseEffect extends PositionComponent with HasGameRef {
  // スケール 0.5 → 1.5、不透明度 1.0 → 0.0 のアニメーション
  // 0.5秒後に removeFromParent()
}
```

### 4.9 `presentation/game/image_loader.dart`

ネットワーク画像を `ui.Image` に変換するヘルパー：

```dart
class NetworkImageLoader {
  final Dio _dio;
  final Map<String, ui.Image> _cache = {};

  Future<ui.Image?> loadImage(String url);
}
```

- `dio` で画像を `Uint8List` として取得
- `decodeImageFromList` で `ui.Image` に変換
- メモリキャッシュで重複リクエストを防止

---

## 5. データフロー

### 5.1 画面初期化 (A01)

```
VotingPage.build()
    │
    ├─► sessionStreamProvider.watch() ─► Firestoreからセッション監視開始
    │
    ├─► membersStreamProvider.watch() ─► Firestoreからメンバー一覧取得
    │                                      │
    │                                      └─► MyakuGame.addMembers() でボール生成
    │
    ├─► myMemberStreamProvider.watch() ─► 自分への投票数監視
    │
    └─► votingStateProvider (timer) ─► 60秒カウントダウン開始
```

### 5.2 タップ〜投票反映 (A02, A03, A04)

```
ユーザータップ
    │
    ▼
MyakuGame.onTapDown()
    │
    ├─► 持ち点チェック (remainingPoints > 0)
    │
    ├─► MemberBody 検出
    │
    ├─► onTapUserCallback(targetUid) ─► VotingStateNotifier
    │       │
    │       ├─► remainingPoints--
    │       │
    │       └─► sendQueue[targetUid]++
    │
    ├─► body.applyLinearImpulse(Vector2(0, -10)) ─► ボールがはねる
    │
    └─► add(PulseEffect()) ─► エフェクト表示

═══════════════════════════════════════════════════════════════

[バックグラウンド: 20回蓄積 or 1秒経過]
    │
    ▼
VotingStateNotifier._flushQueue()
    │
    └─► VotingRepository.incrementVotes(sessionId, sendQueue)
            │
            └─► Firestore: members/{targetUid}/bySender/{myUid} += count

═══════════════════════════════════════════════════════════════

[Firestore更新検知: myMemberStreamProvider]
    │
    ▼
Member.bySender 変更検知
    │
    └─► MyakuGame.updateMemberSize(senderUid, count)
            │
            └─► MemberBody.updateSize() ─► Fixture再生成 ─► ボール巨大化
```

### 5.3 タイムアップ〜結果遷移 (A05, A06, A07)

```
Timer 0秒到達
    │
    ▼
VotingStateNotifier
    │
    ├─► isTimeUp = true
    │
    ├─► MyakuGame.stopInteraction() ─► タップ無効化
    │
    └─► 残りキューをフラッシュ

═══════════════════════════════════════════════════════════════

VotingPage.build() [isTimeUp == true]
    │
    ├─► 終了オーバーレイ (E06, E07) 表示
    │
    └─► role == 'host' ?
            ├─► [結果を見る] ボタン (E08) 表示
            │       │
            │       └─► onPressed: updateSessionStatus('result')
            │
            └─► 待機メッセージ (E09) 表示

═══════════════════════════════════════════════════════════════

[Firestore更新検知: sessionStreamProvider]
    │
    ▼
session.status == 'result'
    │
    └─► ResultPageRoute().go(context) ─► 全員一斉に PG006 へ遷移
```

---

## 6. 実装順序

| Step | 内容                                                      | 依存関係     |
| ---- | --------------------------------------------------------- | ------------ |
| 1    | `application/state/voting_state.dart` 作成                | なし         |
| 2    | `application/state/voting_provider.dart` 作成（モック版） | Step 1       |
| 3    | `presentation/game/image_loader.dart` 作成                | なし         |
| 4    | `presentation/game/member_body.dart` 作成                 | Step 3       |
| 5    | `presentation/game/pulse_effect.dart` 作成                | なし         |
| 6    | `presentation/game/myaku_game.dart` 作成                  | Step 4, 5    |
| 7    | `voting_page.dart` 統合                                   | Step 2, 6    |
| 8    | 動作確認・調整                                            | Step 7       |
| -    | ※ infra 層完成後、Provider 層のモックを差し替え           | 別担当完了後 |

※ `Session` / `Member` モデルは `lib/feature/session/domain/` の既存ファイルを使用
※ `infra/voting_repository.dart` は別担当者が実装中

---

## 7. 注意事項

### 7.1 Flame と Flutter の座標系

- Flame (Forge2D) は物理演算用のメートル単位座標系を使用
- Flutter UI は画面ピクセル座標系を使用
- 今回は「タップ判定は Flame 内で完結」「UI は前面に固定配置」のため、座標変換は不要

### 7.2 ネットワーク画像の非同期ロード

- `MemberBody` 生成時、画像ロードは非同期で行う
- 画像ロード完了前はプレースホルダー（グレー円）を表示
- ロード完了後に Sprite を差し替え

### 7.3 Firestore 書き込み頻度

- 連打 UI のため、1 タップごとの書き込みは避ける
- 送信キューを設け、20 回蓄積 or 1 秒経過でバッチ書き込み
- タイムアップ時は残りキューを即座にフラッシュ

### 7.4 Host/Guest 判定

- `Member.role` フィールドで判定
- Host: セッション作成者、`role == 'host'`
- Guest: 参加者、`role == 'member'`
