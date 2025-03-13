import 'app_exception.dart';

enum ApiExceptionDetail implements ErrorDetail {
  badRequest('400', 'リクエストが不正です。'),
  unauthorized('401', '認証されていません。'),
  forbidden('403', '指定した操作を行う権限がありません。'),
  notFound('404', 'リクエストした API が見つかりませんでした。'),
  notConnected('timeout', 'API通信がタイムアウトしました。通信環境をご確認のうえ、再度実行してください。'),
  networkNotConnected('notConnected', 'ネットワーク接続がありません。通信環境をご確認のうえ、再度実行してください。');

  const ApiExceptionDetail(this._code, this._message);

  final String _code;
  final String _message;

  @override
  String get code => _code;

  @override
  String get message => _message;
}

class ApiException extends AppException {
  ApiException({required ApiExceptionDetail super.errorDetail});
}
