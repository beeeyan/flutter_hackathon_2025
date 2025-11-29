## Firestore DB スキーマ定義

このアプリは合コンなどでメンバーを繋ぎ、制限時間内にアイコンをタップすることでユーザー同士のマッチングを実現するアプリです。  
タップ数がお互いに大きかった人同士がマッチングします。

### コレクション構成

```
users/{uid}                          # ユーザープロフィール
sessions/{sessionId}                 # マッチングセッション
sessions/{sessionId}/members/{uid}   # セッション参加メンバー
```

### users コレクション

ユーザーのプロフィール情報を格納します。

**パス**: `users/{uid}`

```json
{
  "iconUrl": "https://.../avatar.png",  // プロフィール画像URL
  "nickname": "たろう",                    // ニックネーム
  "bio": "よろしく！",                     // 一言コメント（自己紹介）
  "createdAt": "<serverTimestamp>",     // 作成日時
  "updatedAt": "<serverTimestamp>"      // 更新日時
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

### データフロー

1. **ユーザープロフィール追加**
   - `users/{uid}` にデータ追加

2. **QRコード発行**
   - `sessions/{sessionId}` にデータ作成
   - `startAt`: `null`
   - `status`: `"closed"`

3. **QRコード読み込み**
   - `sessions/{sessionId}/members/{uid}` にデータ作成

4. **開始ボタン押下**
   - `sessions/{sessionId}` を更新
   - `startAt`: 開始時の時間
   - `status`: `"open"`

5. **アイコンタップ**
   - `sessions/{sessionId}/members/{targetUid}` の `bySender` データを更新
