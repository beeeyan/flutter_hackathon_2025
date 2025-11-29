## Firestore DB スキーマ定義

このアプリは合コンなどでメンバーを繋ぎ、制限時間内にアイコンをタップすることでユーザー同士のマッチングを実現するアプリです。  
タップ数がお互いに大きかった人同士がマッチングします。

### コレクション構成

```
users/{uid}                          # ユーザープロフィール
sessions/{sessionId}                 # マッチングセッション
sessions/{sessionId}/members/{uid}   # セッション参加メンバー
defaultIcons/{iconId}                # デフォルトアイコン画像一覧
```

### users コレクション

ユーザーのプロフィール情報を格納します。

**パス**: `users/{uid}`

```json
{
  "iconUrl": "https://.../avatar.png",      // プロフィール画像URL（デフォルトアイコンまたはアップロード画像）
  "iconType": "default",                    // "default" または "uploaded"
  "defaultIconId": "icon_001",              // デフォルトアイコン使用時のID（iconType="default"の場合）
  "nickname": "たろう",                       // ニックネーム
  "bio": "よろしく！",                        // 一言コメント（自己紹介）
  "createdAt": "<serverTimestamp>",         // 作成日時
  "updatedAt": "<serverTimestamp>"          // 更新日時
}
```

### sessions コレクション

マッチングイベントの情報を格納します。

**パス**: `sessions/{sessionId}`

```json
{
  "name": "11/29 青山カフェ会",         // セッション名（最初は指定不要）
  "hostUid": "uid_host",              // ホストのUID
  "qrCode": "SES-ABCD-1234",          // QRコード値
  "startAt": "<Timestamp>",           // 開始時刻（null で未開始）
  "endAt": "<Timestamp>",             // 終了時刻
  "status": "open|closed",            // セッション状態
  "createdAt": "<serverTimestamp>",   // 作成日時
  "updatedAt": "<serverTimestamp>"    // 更新日時
}
```

### sessions/{sessionId}/members サブコレクション

セッションに参加するメンバーの情報とタップ履歴を格納します。

**パス**: `sessions/{sessionId}/members/{uid}`

```json
{
  "uid": "authのuid",
  
  // ユーザー情報のコピー（セッション参加時またはプロフィール編集時に保存）
  "iconUrl": "https://.../avatar.png",
  "nickname": "たろう",
  "bio": "はじめまして！",
  
  "joinedAt": "<serverTimestamp>",     // 参加日時
  "lastActiveAt": "<serverTimestamp>", // 最終アクティブ時刻
  "isActive": true,                    // アクティブ状態
  "role": "member",                    // ロール（"host" または "member"）
  
  // タップ履歴：誰が自分をタップしたか
  "bySender": {
    "uid_AAA": 10,                     // Aさん → この人 へ 10タップ
    "uid_BBB": 5,                      // Bさん → この人 へ 5タップ
    "uid_CCC": 9                       // Cさん → この人 へ 9タップ
  }
}
```

### defaultIcons コレクション

アップロード機能がない初期段階で使用するデフォルトアイコン画像の一覧を管理します。

**パス**: `defaultIcons/{iconId}`

```json
{
  "url": "https://example.com/icons/avatar_01.png",  // アイコン画像URL
  "name": "アバター01",                               // アイコン名
  "category": "animal",                              // カテゴリ（animal, character, abstract など）
  "isActive": true,                                  // 利用可能かどうか
  "order": 1,                                        // 表示順序
  "createdAt": "<serverTimestamp>",                  // 作成日時
  "updatedAt": "<serverTimestamp>"                   // 更新日時
}
```

**使用例**:
```json
{
  "defaultIcons/icon_001": {
    "url": "https://example.com/icons/cat.png",
    "name": "ねこ",
    "category": "animal",
    "isActive": true,
    "order": 1
  },
  "defaultIcons/icon_002": {
    "url": "https://example.com/icons/dog.png", 
    "name": "いぬ",
    "category": "animal",
    "isActive": true,
    "order": 2
  },
  "defaultIcons/icon_003": {
    "url": "https://example.com/icons/smile.png",
    "name": "スマイル",
    "category": "character",
    "isActive": true,
    "order": 3
  }
}
```

### データフロー

1. **ユーザープロフィール追加**
   - `users/{uid}` にデータ追加
   - デフォルトアイコンの場合：`defaultIcons` コレクションから選択

2. **デフォルトアイコン管理**
   - `defaultIcons` コレクションからアイコン一覧を取得
   - カテゴリ別・順序別での表示が可能

3. **QRコード発行**
   - `sessions/{sessionId}` にデータ作成
   - `startAt`: `null`
   - `status`: `"closed"`

4. **QRコード読み込み**
   - `sessions/{sessionId}/members/{uid}` にデータ作成

5. **開始ボタン押下**
   - `sessions/{sessionId}` を更新
   - `startAt`: 開始時の時間
   - `status`: `"open"`

6. **アイコンタップ**
   - `sessions/{sessionId}/members/{targetUid}` の `bySender` データを更新
