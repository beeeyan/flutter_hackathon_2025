import 'package:freezed_annotation/freezed_annotation.dart';

part 'voting_state.freezed.dart';

/// 投票画面の状態
@freezed
abstract class VotingState with _$VotingState {
  const factory VotingState({
    /// 残り時間（秒）
    @Default(60) int remainingSeconds,

    /// 残り持ち点
    @Default(100) int remainingPoints,

    /// タイムアップフラグ
    @Default(false) bool isTimeUp,

    /// 送信待ちキュー {targetUid: count}
    @Default({}) Map<String, int> sendQueue,

    /// 最後にキューをフラッシュした時間
    DateTime? lastFlushTime,
  }) = _VotingState;
}

/// 投票設定の定数
class VotingConfig {
  VotingConfig._();

  /// 投票時間（秒）
  static const int votingDurationSeconds = 60;

  /// 持ち点上限
  static const int maxPoints = 100;

  /// キューフラッシュ閾値（タップ数）
  static const int flushThresholdCount = 20;

  /// キューフラッシュ閾値（秒数）
  static const int flushThresholdSeconds = 1;
}
