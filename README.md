
各案件では削除してよい部分

----------------------------------

# 初期設定済みプロジェクト

## プロジェクト作成方法（FVM前提）

プロジェクトは以下で作成している。  
※fvm前提  
※大本はFlutterバージョン「3.29.0」で作成

```console
$ fvm use stable --force

$ fvm flutter create \
  --org jp.co.docodoor \
  app
```

## 利用方法  

### 各種書き換え
  
本プロジェクトを`clone`後以下を案件ごとに書き換える。  
  
### アプリ名称
「アプリ名」で検索して、正しいアプリ名に置換  
  
### パッケージ名（bundle Id Application ID）の変更
  
※プロジェクト直下で実行すること
  
```console
$ chmod 755 change_package_name.sh 
```
  
パッケージ名を引数とすると、変更が必要な箇所全て書き換わる。  
例) 「com.example.app」の場合  
  
```console
$ ./change_package_name.sh com.example.app
```
  
※注意  
**元々のパッケージ名と近い内容で変更しようとすると、フォルダを再作成時に余計なファイルまで削除してしまいます。**  
例)
`jp.co.xxx.app` から `jp.co.yyy.app`の変更など  
回避策として、全く違うパッケージ名に変更してからの処理してください。  
  
```console
$ ./change_package_name.sh xxx.yyyy.bbb
$ ./change_package_name.sh com.example.app
```
  
処理が終わったら`change_package_name.sh`は消しておいてもいいかと思う。  
  
## Flutterバージョン
FVMが使用しているFlutterのバージョンは[.fvmrc](.fvmrc)に記載されている。  
Flutterのバージョンを変更したい場合は`fvm use`コマンドを使用する。 
```
$ fvm use stable
$ fvm use 3.29.0
```

## Githubの設定

- 案件のリポジトリを作成
- remote urlを案件のリポジトリに変更。

```console
# 現在のremote url を確認
$ git remote -v
# remote url を変更
$ git remote set-url origin {new-url}
# 正しく変更できているか確認
$ git remote -v
```
  
あとは新しいリポジトリにpushできればOK  
  
## 事前追加している実装・対応
  
以下、本プロジェクトにて実装済みの内容について記載する。
変更が必要な場合は、案件ごとに変更すること。
  
### lintの設定  
[pedantic_mono](https://pub.dev/packages/pedantic_mono)を採用。versionはanyとしている。  
変更可否の判断基準 : 外的要因で指定がある場合。それ以外は変更しないことを推奨。  
該当コミット : [a872](https://github.com/docodoor-inc/app_initial_settings_project/commit/a87281c31a30e34311dc6f1bf7af7d3d4c21374a)
  
### 輸出コンプライアンスの設定  
  
暗号化を使用していない、もしくは免除の対象になる暗号化のみを使用していることを示す。　
Appleのストアでの操作を楽にできる。([参考](https://tommy10344.hatenablog.com/entry/2020/04/29/025809))  
免除の対象になる暗号化 : HTTPSや、OSに組み込まれた標準の暗号化  
変更可否の判断基準 : 免除の対象になる暗号化以外を使用している場合。※ 2023/1/5時点では、弊社実績なし。  
該当コミット : [e7b0](https://github.com/docodoor-inc/app_initial_settings_project/commit/e7b0d47a7e895f5ae4663f9cd127e4a804726751)
  
### パッケージのimport方法を自動で修正する設定
  
相対パス・絶対パスを使い分けるようにしており、人力でやるとミスが発生するので自動でimport方法を修正するように追加した。  
「相対パス・絶対パスを使い分ける」方針にしたのは以下の公式ガイドが参考。  
[PREFER relative import paths](https://dart.dev/effective-dart/usage#prefer-relative-import-paths)  
  
変更可否の判断基準 : 「絶対パス」で統一する指定がある場合など。  
該当コミット : [7637](https://github.com/docodoor-inc/app_initial_settings_project/commit/7637091b4cc4237bc89655087c3865113def33bc)
  
上記コミットでは`analysis_options.yaml`の設定不足があったので注意。  
※ `prefer_relative_imports: true` が必要。  
  
### 縦向き固定
  
対応方法の参考 : https://gist.github.com/blendthink/7529efc701be36b9bd1f3a9b55570225  
iPadは横向きにしてもある程度縦幅があるので、未対応としている。  
※ 「Support Split Screen Multitasking」観点からも、Apple公式では横向きの対応が推奨されている認識。  
  
参考 : [Support Split Screen Multitaskingの話](https://qiita.com/sussan0416/items/4b5f390711de1675a66b#support-split-screen-multitasking%E3%81%A8%E6%A8%AA%E7%94%BB%E9%9D%A2%E5%AF%BE%E5%BF%9C)  
  
※ iPadも縦向き固定する場合  
Xcode上でiPadの設定で「Requires full screen」をチェック  
main上で以下を実行。  
（検証した限り両方とも実装することで、iPadの縦向き固定ができる）  
  
```dart
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
```
  
検証時の別プロジェクトのプルリク : [ocrimagegenのプルリク](https://github.com/docodoor-inc/ocrimagegen/pull/40#issuecomment-1855049814)
  
変更可否の判断基準 : 横向きの対応が必要な場合  
該当コミット（複数の対応が入っている） : [d908](https://github.com/docodoor-inc/app_initial_settings_project/commit/d908e27029d4af66bca04540cdec7207f2a3de49)  
  
### Appleの対応言語に日本語を追加
  
Apple Storeで言語表示を「日本語」にするには本対応が必要。
最低限の対応しかしていない。  
参考 : https://eda-inc.jp/post-4472/  
注意 言語ごとにATTを設定する場合は、対応言語のファイルに記載する必要がある。（日本語のみの場合は`info.plist`のみの記載でも最悪可能）  
  
変更可否の判断基準 : 対応言語に日本語がない  
該当コミット（複数の対応が入っている） : [d908](https://github.com/docodoor-inc/app_initial_settings_project/commit/d908e27029d4af66bca04540cdec7207f2a3de49)  
  
### 文字サイズ固定
  
ドコドアとして、文字サイズ固定することに決定したため設定している。  
※ 文字サイズを固定しない場合、別途見積もりとしやすくするため。  
  
変更可否の判断基準 : 文字サイズ固定しない場合  
該当コミット（複数の対応が入っている） : [d908](https://github.com/docodoor-inc/app_initial_settings_project/commit/d908e27029d4af66bca04540cdec7207f2a3de49)  
  
### Dioの実装

[フォルダ](./lib/api/)  

元々の参考  
https://github.com/KosukeSaigusa/flutterfire-commons/tree/main/packages/routing_with_riverpod/example  
  
変更可否の判断基準 : APIとのやりとりがない場合は削除推奨。  
  
また[base_response_data](./lib/api/model/base_response_data/base_response_data.dart)は要件によって変えた方がいいかもしれない。  
※ 現状そのままmainにデータ入れている。「参考」の実装などでは「message」はどのAPIでも存在する想定で作成されている。

### PrivateManifestの設定

shared_preferencesはほぼほぼ利用する想定で、以下のみデフォルトで追加している。  
※ 必要なければ消す・適宜アプリごとに必要な設定を追加すること。
Privacy Accessed API Type : User Defaults  
Privacy Accessed API Reasons : CA92.1
  
[参考](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api/#4278401)

### アプリバージョン

`0.0.0+1`としている  
※AppleDeveloperで初回ストア申請通過後、取り下げを行うかビルドナンバーをインクリメントしないと媒体アップロードができないため。

### ThemeData

`lib/config/theme`に雛形を作成している。  


以下README雛形

----------------------------------

## 案件概要記載

公式サイトのURL
バックログのURL

## 環境構築

fvmとVSCodeの利用を想定している。  
VSCode用の設定は追加済みである。  

**Flutter SDK**  

- バージョン管理ツール : [FVM](https://fvm.app/)
    - FVMのインストール・設定については、[こちらの記事](https://zenn.dev/riscait/articles/flutter-version-management)が参考になります。
    - FVMの3系を利用しています。[こちらの記事](https://zenn.dev/altiveinc/articles/flutter-version-management-3)を参考ください。
    - ※ 私は`Homebrew`でインストールしています。
- 使用しているバージョンは [.fvmrc](.fvmrc) に記載されています。
- FVMのインストール後、以下の流れで環境構築を実施。
    - プロジェクトのルートディレクトリで、`fvm flutter --version`を実行すると、ローカル環境に該当のバージョンがなければインストールされる。
    - VSCode の場合
        - VSCode を再起動する
        - main.dart などの dart ファイルを開き、エディタの右下の「Dart」部分をクリックして、該当のバージョンのFlutterが読み込まれていればOK

### 環境分け
環境は公式ドキュメントを参考に`dev`（開発）と`prod`（本番）で分けています。  

* [Set up Flutter flavors for Android](https://docs.flutter.dev/deployment/flavors)
* [Set up Flutter flavors for iOS and macOS](https://docs.flutter.dev/deployment/flavors-ios)

アプリアイコンは[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)を使用し環境毎のファイルを用意しています。  
更新する場合は`assets/images/launcher`の画像を差し替えて下記コマンドを実行ください。

```
$ dart run flutter_launcher_icons
```

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
$ flutter build appbundle --release --flavor prod --dart-define=FLAVOR=prod
# iOS
$ flutter build ipa --flavor prod --dart-define=FLAVOR=prod
```

## 構成図
