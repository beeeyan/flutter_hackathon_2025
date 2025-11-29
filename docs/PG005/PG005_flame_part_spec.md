# Flame/Forge2D 詳細設計書 (PG005)

## 1. ゲームワールド設定 (E03: 物理演算ワールド)

`Forge2DGame` を継承したメインクラスです。

| 項目                | 設定値 / ロジック    | 備考                                                                                                        |
| ------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------- |
| **クラス名**        | `MyakuGame`          | `extends Forge2DGame` with `TapDetector`                                                                    |
| **重力 (Gravity)**  | `Vector2(0, 30.0)`   | 下方向への重力。<br>少し重めに設定し、ボールが早く積み重なるようにする。                                    |
| **ズーム (Zoom)**   | `10.0` 〜 `20.0`     | 物理演算の「メートル」と画面ピクセルの比率。<br>ボールの大きさに合わせて調整。                              |
| **壁 (Boundaries)** | `createBoundaries()` | 画面の `Left`, `Right`, `Bottom` に `BodyType.static` の壁を設置。<br>※Top は壁なし（上から降らせるため）。 |
| **背景**            | `Color(0x00000000)`  | 透明 (`Colors.transparent`) に設定し、Flutter 側の背景色を活かす。                                          |

### 公開メソッド (Flutter UI からの操作用)

- **`addMembers(List<User> users)`**: ゲーム開始時、参加者ボールをスポーンさせる。
- **`updateMemberSize(String targetUid, int tapCount)`**: 特定のボールを巨大化させる。
- **`stopInteraction()`**: タイムアップ時、タップ入力を無効化するフラグを立てる。

---

## 2. 参加者ボール (E04: 参加者ボール)

物理演算の主体となるオブジェクトです。

| 項目              | 設定値 / ロジック                                                                        | 備考                                                             |
| ----------------- | ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **クラス名**      | `MemberBody`                                                                             | `extends BodyComponent`                                          |
| **形状 (Shape)**  | `CircleShape`                                                                            | 真円。                                                           |
| **基本サイズ**    | 半径 `3.0` (メートル換算)                                                                | 初期状態の大きさ。                                               |
| **画像 (Sprite)** | ユーザーのアバター画像                                                                   | `CircleComponent` 等で画像を丸くクリップして Body に追従させる。 |
| **物理属性**      | **密度 (Density):** `1.0`<br>**摩擦 (Friction):** `0.3`<br>**反発 (Restitution):** `0.4` | ツルツルしすぎず、跳ねすぎない、「ゴムまり」程度の質感。         |
| **保有データ**    | `final String uid;`<br>`final String name;`                                              | どのユーザーのボールかを識別するため。                           |

### 巨大化ロジック (`updateMemberSize` 内の処理)

物理演算のボディサイズを変更するため、Fixture（形状定義）を再生成します。

1.  **目標サイズの計算:** `newRadius = baseRadius + (tapCount * 0.1)` (上限設定推奨)
2.  **Fixture の再生成:**
    - 現在の `body.fixtures` をクリア。
    - 新しい半径 (`newRadius`) を持った `FixtureDef` を作成。
    - `body.createFixture(newFixtureDef)` を実行。
    - ※サイズが大きくなることで、物理エンジンが自動的に周囲のボールを押しのけます。

---

## 3. エフェクト (E05: タップエフェクト)

タップした瞬間のフィードバックです。物理演算には影響を与えない純粋な描画コンポーネントです。

| 項目         | 設定値 / ロジック                                                                                        | 備考                                 |
| ------------ | -------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| **クラス名** | `PulseEffect`                                                                                            | `extends PositionComponent`          |
| **見た目**   | ハートアイコン または 波紋の円                                                                           | 画像(Sprite) または `Canvas` 描画。  |
| **挙動**     | 1. タップ位置に出現<br>2. スケール `0.5` → `1.5`<br>3. 不透明度 `1.0` → `0.0`<br>4. `removeFromParent()` | 0.5 秒程度のアニメーション後に消滅。 |

---

## 4. インタラクションフロー

`MyakuGame` クラス内の `onTapDown` メソッドの実装ロジックです。

```dart
@override
void onTapDown(TapDownInfo info) {
  if (isTimeUp) return; // タイムアップ後は無視

  // 1. タップ位置にあるBodyを探す
  // info.eventPosition.game でワールド座標が取得可能
  final tappedBodies = world.queryPoint(info.eventPosition.game);

  // 2. Bodyが見つかり、かつそれが MemberBody である場合
  // queryPointは複数のBodyを返す可能性があるため、最初の一つを取得
  if (tappedBodies.isNotEmpty) {
     final body = tappedBodies.first;

     if (body.userData is MemberBody) {
        final target = body.userData as MemberBody;

        // 3. 外部(Flutter側)に通知 -> Riverpod等で状態更新
        onTapUserCallback?.call(target.uid);

        // 4. 視覚的フィードバック
        // 軽く上にはねさせる (ApplyLinearImpulse)
        // Vector2(0, -10) などの上向きベクトルを与える
        target.body.applyLinearImpulse(Vector2(0, -10));

        // 5. エフェクト出現
        add(PulseEffect(position: info.eventPosition.game));
     }
  }
}
```

---

## 実装時の注意点 (ハッカソン用 Tips)

1. 画像のロード (Network Image):

   - Flame 標準の images.load は Asset 読み込みが得意ですが、Network 画像の場合は工夫が必要です。
   - http パッケージ等で画像データを Uint8List として取得し、decodeImageFromList で ui.Image に変換してから Sprite 化するヘルパー関数を用意するとスムーズです。

2. 座標系の違い:  
   Flutter UI (Widget) の座標と、Flame (Game) の座標は異なります。
   UI オーバーレイを表示する際は game.convertWorldToScreen(position) などが必要になる場合がありますが、今回は「タップ判定は Flame 内で完結」「UI は前面に固定配置」なので、座標変換は意識しなくて OK です。
