## 案件概要記載

[Tokyo Flutter Hackathon 2025](https://tokyo-flutter-hackathon.connpass.com/event/368402/)の「ほぼドコドア」チームのアプリ  
  
テーマ : 「みゃく」

## アプリ概要

アプリ名 **Myacle**  
読み : ミャクる  
  
「脈」+「miracle」 奇跡の出会い、「脈来る」 etc.
  
コンセプト   
「熱量（脈）」を「タップ数」で可視化する、合コン終盤専用のモバイルマッチングアプリ。
  
詳細な仕様などは[docs/00_overview](./00_overview/)を参照ください。  

## 環境構築

fvm と VSCode の利用を想定している。  
VSCode 用の設定は追加済みである。

**VSCode の設定**

VSCode でKotlin/Gradle Kotlin DSLファイルを読み込むため
VSCode の拡張機能で以下をインストール：

- Kotlin
- Gradle for Java

**Flutter SDK**

- バージョン管理ツール : [FVM](https://fvm.app/)
  - FVM のインストール・設定については、[こちらの記事](https://zenn.dev/riscait/articles/flutter-version-management)が参考になります。
  - FVM の 3 系を利用しています。[こちらの記事](https://zenn.dev/altiveinc/articles/flutter-version-management-3)を参考ください。
  - ※ 私は`Homebrew`でインストールしています。
- 使用しているバージョンは [.fvmrc](.fvmrc) に記載されています。
- FVM のインストール後、以下の流れで環境構築を実施。
  - プロジェクトのルートディレクトリで、`fvm flutter --version`を実行すると、ローカル環境に該当のバージョンがなければインストールされる。
  - VSCode の場合
    - VSCode を再起動する
    - main.dart などの dart ファイルを開き、エディタの右下の「Dart」部分をクリックして、該当のバージョンの Flutter が読み込まれていれば OK

### 環境分け

環境は公式ドキュメントを参考に`dev`（開発）と`prod`（本番）で分けています。

- [Set up Flutter flavors for Android](https://docs.flutter.dev/deployment/flavors)
- [Set up Flutter flavors for iOS and macOS](https://docs.flutter.dev/deployment/flavors-ios)

アプリアイコンは[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)を使用し環境毎のファイルを用意しています。  
更新する場合は`assets/images/launcher`の画像を差し替えて下記コマンドを実行ください。

```
$ dart run flutter_launcher_icons
```

### Firebase 設定

Firebase は環境ごと（`dev`/`prod`）に分けて設定されています。  
アプリID毎に環境分けをしていますが、実質的には同じFirebaseプロジェクト（`flutter-hackathon-2025`）を参照しています。

- **設定ファイル**: `lib/config/firebase/{dev|prod}/firebase_options.dart`
- **Android**: `android/app/src/{dev|prod}/google-services.json`
- **iOS**: `ios/config/{dev|prod}/GoogleService-Info.plist`

`lib/main.dart` の `initializeFirebaseApp()` で Flavor に応じて適切な設定を読み込みます。

## 実行・ビルド方法

開発環境の実行コマンド

```console
$ fvm flutter run --debug --flavor dev --dart-define=FLAVOR=dev
```

本番環境の実行コマンド

```console
$ fvm flutter run --debug --flavor prod --dart-define=FLAVOR=prod
```

ビルドコマンド

```console
# Android
$ fvm flutter build appbundle --release --flavor prod --dart-define=FLAVOR=prod
# iOS
$ fvm flutter build ipa --flavor prod --dart-define=FLAVOR=prod
```
