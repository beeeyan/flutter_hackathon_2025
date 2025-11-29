import 'dart:async';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// ネットワーク画像を ui.Image に変換するローダー
class NetworkImageLoader {
  NetworkImageLoader({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  final Map<String, ui.Image> _cache = {};
  final Map<String, Future<ui.Image?>> _pendingRequests = {};

  /// 画像をロード（キャッシュあり）
  Future<ui.Image?> loadImage(String url) async {
    // キャッシュチェック
    if (_cache.containsKey(url)) {
      return _cache[url];
    }

    // 同じURLのリクエストが進行中の場合は待機
    if (_pendingRequests.containsKey(url)) {
      return _pendingRequests[url];
    }

    // 新規リクエスト
    final future = _fetchAndDecodeImage(url);
    _pendingRequests[url] = future;

    try {
      final image = await future;
      if (image != null) {
        _cache[url] = image;
      }
      return image;
    } finally {
      _pendingRequests.remove(url);
    }
  }

  /// 画像を取得してデコード
  Future<ui.Image?> _fetchAndDecodeImage(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data == null) return null;

      final bytes = Uint8List.fromList(response.data!);
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      return frame.image;
    } catch (e) {
      debugPrint('Failed to load image: $url, error: $e');
      return null;
    }
  }

  /// キャッシュをクリア
  void clearCache() {
    _cache.clear();
  }

  /// 特定のURLのキャッシュを削除
  void removeFromCache(String url) {
    _cache.remove(url);
  }

  /// キャッシュに画像が存在するか
  bool hasCache(String url) {
    return _cache.containsKey(url);
  }
}
