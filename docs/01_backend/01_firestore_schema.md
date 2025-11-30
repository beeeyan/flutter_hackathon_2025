## Firestore DB スキーマ定義

このアプリは合コンなどでメンバーを繋ぎ、制限時間内にアイコンをタップすることでユーザー同士のマッチングを実現するアプリです。  
タップ数がお互いに大きかった人同士がマッチングします。

### コレクション構成

```
users/{uid}                          # ユーザープロフィール
sessions/{sessionId}                 # マッチングセッション
sessions/{sessionId}/members/{uid}   # セッション参加メンバー
```

### スキーマ図

```mermaid
erDiagram
    %% コレクションの定義
    users {
        string uid PK "ドキュメントID (Auth UID)"
        string iconUrl
        string nickname
        string bio
        timestamp createdAt
        timestamp updatedAt
    }

    sessions {
        string sessionId PK "ドキュメントID"
        string name
        string hostUid FK "主催者のUID (users参照)"
        string qrCode
        string status "waiting | active | result"
        timestamp createdAt
        timestamp updatedAt
    }

    %% サブコレクションの定義
    %% sessions/{sessionId}/members/{uid} を表現
    sessions_members {
        string uid PK, FK "ドキュメントID (Auth UID)"
        string iconUrl "usersからのコピー"
        string nickname "usersからのコピー"
        string bio "usersからのコピー"
        timestamp joinedAt
        timestamp lastActiveAt
        boolean isActive
        string role "host | member"
        map bySender "Map<uid, int>: 被タップ数"
        map Sended "Map<uid, int>: 与タップ数"
    }

    %% リレーションシップの定義
    %% ユーザーは複数のセッションメンバーとして参加する
    users ||--o{ sessions_members : "joins as"
    %% ユーザーは複数のセッションを主催する可能性がある
    users ||--o{ sessions : "hosts"
    %% セッションは複数のメンバー（サブコレクション）を持つ
    sessions ||--|{ sessions_members : "contains (sub-collection)"
```

### users コレクション

ユーザーのプロフィール情報を格納します。

**パス**: `users/{uid}`

```json
{
  "iconUrl": "https://.../avatar.png",      // プロフィール画像URL（デ
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
  "qrCode": "SES-ABCD-1234",          // QRコード値(テキスト入力する場合を考えてある程度入力しやすいものを採番する) 
  "status": "waiting|active|result",  // セッション状態
  "createdAt": "<serverTimestamp>",   // 作成日時
  "updatedAt": "<serverTimestamp>"    // 更新日時
}
```

waiting : 投票が始まっていない状態
active : 投票中の状態
result : 結果表示中の状態
  
タイマーは、各端末で計測する。

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
  },

  "Sended": {
    "uid_AAA": 10,                     // この人 → Aさん へ 10タップ
    "uid_BBB": 5,                      // この人 → Bさん へ 5タップ
    "uid_CCC": 9                       // この人 → Cさん へ 9タップ
  }

}
```

※ bySenderとSended両方あるのは、マッチングの処理を簡単にするため　　

### データフロー

1. **ユーザープロフィール追加**
   - `users/{uid}` にデータ追加

2. **QRコード発行**
   - `sessions/{sessionId}` にデータ作成
   - `status`: `"waiting"`

3. **QRコード読み込み**
   - `sessions/{sessionId}/members/{uid}` にデータ作成

4. **開始ボタン押下**
   - `sessions/{sessionId}` を更新
   - `status`: `"active"`

5. **アイコンタップ**
   - `sessions/{sessionId}/members/{targetUid}` の 
   アイコンに表示されている人の`bySender`と  
   自分の`sended`を更新する

6. **ホストが終了ボタン押下**
   - `sessions/{sessionId}` を更新
   - `status`: `"result"`
