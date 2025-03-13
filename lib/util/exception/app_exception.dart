/*
 ApiExceptionを参考に、案件毎に共通の例外処理を実装するための基底クラスを作成します。
 多言語化対応する場合は、ErrorDetailのmessageフィールドは除外し、Presentationで指定するように調整が必要です。
 */

/// アプリ内で使用する例外処理の基礎クラス
abstract class AppException implements Exception {
  const AppException({required this.errorDetail});

  final ErrorDetail errorDetail;

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'AppException{code: ${errorDetail.code}, message: ${errorDetail.message}}';
  }
}

/// エラー詳細情報を持つ基礎クラス
abstract class ErrorDetail {
  const ErrorDetail();

  /// ステータスコード
  String get code;

  /// メッセージ
  String get message;
}
