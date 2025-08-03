import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/functions_responses/end_game_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/enter_game_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/exit_game_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/get_game_config_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/get_game_info_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/get_value_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/init_player_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/kick_player_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/start_game_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/submit_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/update_avatar_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/update_hint_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/update_name_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/update_topic_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/withdraw_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/heartbeat_response.dart';
import 'package:flutter_online_cardgame/model/functions_responses/reset_game_response.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';

class FirebaseRepository {
  FirebaseRepository._internal();
  static final FirebaseRepository _instance = FirebaseRepository._internal();
  factory FirebaseRepository() => _instance;

  static bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // ゲーム終了中にStream接続しないためのフラグ
  static bool exitingGame = false;

  static DateTime? lastConnected;
  static Duration get heartbeatInterval => const Duration(seconds: 10);
  static bool get shouldHeartbeat =>
      lastConnected == null || DateTime.now().difference(lastConnected!) >= heartbeatInterval;
  static bool get isConnected =>
      lastConnected != null &&
      DateTime.now().difference(lastConnected!).compareTo(heartbeatInterval) < 0;
  static bool get isDisconnected => !isConnected;

  // Helper method for consistent function calls with logging
  static Future<T> _callFunction<T>(
    String functionName,
    Map<String, dynamic>? data,
    T Function(Map<String, dynamic>) fromJson, {
    bool updateLastConnected = false,
    VoidCallback? onComplete,
  }) async {
    log('$functionName: start', name: 'FirebaseRepository');

    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(functionName);
      final result = await callable(data);
      final responseData = result.data;

      if (updateLastConnected) {
        lastConnected = DateTime.now();
      }
      log('$functionName: end (response: $responseData)', name: 'FirebaseRepository');
      return fromJson(responseData);
    } catch (e) {
      log('$functionName: fail ($e)', name: 'FirebaseRepository');
      rethrow;
    } finally {
      onComplete?.call();
    }
  }

  // 最新の認証状態を常に取得
  static User get user {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User is not authenticated.');
    return user;
  }

  static Stream<GameState> watchGameState(String gameId) {
    return FirebaseDatabase.instance.ref('games/$gameId/state').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) throw Exception('Game state not found for gameId: $gameId');
      final json = Map.fromEntries(
        data.entries.map((entry) {
          return MapEntry(entry.key.toString(), entry.value);
        }),
      );
      // print('Game state updated: ${data.runtimeType}');
      return GameState.fromJson(json);
    });
  }

  /// 新しいゲームを作成し、作成者を自動的にゲームに参加させます。
  /// POST /create_game
  /// 認証必須。リクエストボディなし。
  /// 1分間に30回までの作成制限あり。
  ///
  /// @return ゲームIDやパスワード等を含むサーバーからのレスポンス
  static Future<GameInfo> createGame() async {
    return _callFunction('create_game', null, GameInfo.fromJson);
  }

  /// パスワードを使用して既存のゲームに参加します。
  /// POST /enter_game
  /// 認証必須。パラメータ: password（4桁の数字）。
  /// ゲームがマッチング段階（phase 0）の場合のみ参加可能。
  ///
  /// @param password 参加するゲームのパスワード
  /// @return ゲーム情報やユーザーID等を含むサーバーからのレスポンス
  static Future<EnterGameResponse> enterGame({required String password}) async {
    return _callFunction(
      'enter_game',
      {'password': password},
      EnterGameResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// プレイヤー名を更新します。
  /// POST /update_name
  /// 認証必須。パラメータ: name, gameId。
  /// ゲームに参加していない場合やキックされた場合は実行不可。
  /// ゲームのphaseが0（マッチング段階）の場合のみ実行可能。
  ///
  /// @param name 新しいプレイヤー名
  /// @param gameId 対象ゲームID
  /// @return 更新結果等を含むサーバーからのレスポンス
  static Future<UpdateNameResponse> updateName({
    required String name,
    required String gameId,
  }) async {
    return _callFunction(
      'update_name',
      {'name': name, 'gameId': gameId},
      UpdateNameResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// プレイヤーのヒントを更新します。
  /// POST /update_hint
  /// 認証必須。パラメータ: hint, gameId。
  /// ゲームのphaseが1（ゲーム開始後）の場合のみ実行可能。
  ///
  /// @param hint 新しいヒント文
  /// @param gameId 対象ゲームID
  /// @return 更新結果等を含むサーバーからのレスポンス
  static Future<UpdateHintResponse> updateHint({
    required String hint,
    required String gameId,
  }) async {
    return _callFunction(
      'update_hint',
      {'hint': hint, 'gameId': gameId},
      UpdateHintResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// プレイヤーのアバターを更新します。
  /// POST /update_avatar
  /// 認証必須。パラメータ: avatar, gameId。
  /// ゲームのphaseが0（マッチング段階）の場合のみ実行可能。
  ///
  /// @param avatar 新しいアバター番号（0-11推奨）
  /// @param gameId 対象ゲームID
  /// @return 更新結果等を含むサーバーからのレスポンス
  static Future<UpdateAvatarResponse> updateAvatar({
    required int avatar,
    required String gameId,
  }) async {
    return _callFunction(
      'update_avatar',
      {'avatar': avatar, 'gameId': gameId},
      UpdateAvatarResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// プレイヤーの提出時刻を記録します。
  /// POST /submit
  /// 認証必須。パラメータ: gameId。
  /// ゲームのphaseが1（ゲーム開始後）の場合のみ実行可能。
  ///
  /// @param gameId 対象ゲームID
  /// @return 提出時刻等を含むサーバーからのレスポンス
  static Future<SubmitResponse> submit({required String gameId}) async {
    return _callFunction(
      'submit',
      {'gameId': gameId},
      SubmitResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// プレイヤーの提出を取り消します。
  /// POST /withdraw
  /// 認証必須。パラメータ: gameId。
  /// ゲームのphaseが1（ゲーム開始後）の場合のみ実行可能。
  ///
  /// @param gameId 対象ゲームID
  /// @return 提出取り消し結果等を含むサーバーからのレスポンス
  static Future<WithdrawResponse> withdraw({required String gameId}) async {
    return _callFunction(
      'withdraw',
      {'gameId': gameId},
      WithdrawResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// プレイヤーの接続状態を更新します。
  /// POST /heartbeat
  /// 認証必須。パラメータ: gameId。
  /// 自分のlastConnectedタイムスタンプのみを更新します。
  ///
  /// @param gameId 対象ゲームID
  /// @return ハートビート更新結果等を含むサーバーからのレスポンス
  static Future<HeartbeatResponse> heartbeat({required String gameId}) async {
    return _callFunction(
      'heartbeat',
      {'gameId': gameId},
      HeartbeatResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// ゲームから退出します。
  /// POST /exit_game
  /// 認証必須。リクエストボディなし。
  /// 最後のプレイヤーが退出した場合はゲーム全体が削除されます。
  ///
  /// @return 退出結果等を含むサーバーからのレスポンス
  static Future<ExitGameResponse> exitGame({required String gameId}) async {
    exitingGame = true;
    return _callFunction(
      'exit_game',
      {'gameId': gameId},
      ExitGameResponse.fromJson,
      onComplete: () => exitingGame = false,
    );
  }

  /// ゲームを終了します。
  /// POST /end_game
  /// 認証必須。パラメータ: gameId。
  /// 管理者（最初に参加したプレイヤー）のみ実行可能。
  ///
  /// @param gameId 対象ゲームID
  /// @return ゲーム終了結果等を含むサーバーからのレスポンス
  static Future<EndGameResponse> endGame({required String gameId}) async {
    return _callFunction(
      'end_game',
      {'gameId': gameId},
      EndGameResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// ゲームをリセットします。
  /// POST /reset_game
  /// 認証必須。パラメータ: gameId。
  /// 管理者（最初に参加したプレイヤー）のみ実行可能。
  ///
  /// @param gameId 対象ゲームID
  /// @return ゲームリセット結果等を含むサーバーからのレスポンス
  static Future<ResetGameResponse> resetGame({required String gameId}) async {
    return _callFunction(
      'reset_game',
      {'gameId': gameId},
      ResetGameResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// 指定したプレイヤーをキックします。
  /// POST /kick_player
  /// 認証必須。パラメータ: gameId, playerId。
  /// 管理者（最初に参加したプレイヤー）のみ実行可能。
  ///
  /// @param gameId 対象ゲームID
  /// @param playerId キック対象のプレイヤーID
  /// @return キック結果等を含むサーバーからのレスポンス
  static Future<KickPlayerResponse> kickPlayer({
    required String gameId,
    required String playerId,
  }) async {
    return _callFunction(
      'kick_player',
      {'gameId': gameId, 'playerId': playerId},
      KickPlayerResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// ゲームのトピックを更新します。
  /// POST /update_topic
  /// 認証必須。パラメータ: gameId, topic。
  /// 管理者（最初に参加したプレイヤー）のみ実行可能。
  /// ゲームのphaseが0（マッチング段階）の場合のみ実行可能。
  ///
  /// @param gameId 対象ゲームID
  /// @param topic 新しいトピック
  /// @return 更新結果等を含むサーバーからのレスポンス
  static Future<UpdateTopicResponse> updateTopic({
    required String gameId,
    required String topic,
  }) async {
    return _callFunction(
      'update_topic',
      {'gameId': gameId, 'topic': topic},
      UpdateTopicResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// ゲームを開始し、各プレイヤーにユニークな値を割り当てます。
  /// POST /start_game
  /// 認証必須。パラメータ: gameId。
  /// 管理者（最初に参加したプレイヤー）のみ実行可能。
  /// ゲームのphaseが0（マッチング段階）の場合のみ実行可能。
  ///
  /// @param gameId 対象ゲームID
  /// @return ゲーム開始結果や割り当て値等を含むサーバーからのレスポンス
  static Future<StartGameResponse> startGame({
    required String gameId,
    required String topic,
    required int playerCount,
  }) async {
    FirebaseAnalytics.instance.logEvent(
      name: 'game_started',
      parameters: {'topic': topic, 'playerCount': playerCount},
    );
    return _callFunction(
      'start_game',
      {'gameId': gameId},
      StartGameResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// プレイヤーを初期化し、現在のゲームIDを返します。
  /// POST /init_player
  /// 認証必須。リクエストボディなし。
  /// 現在のゲームがない場合はgameIdがnullとなります。
  ///
  /// @return 現在のゲームID等を含むサーバーからのレスポンス
  static Future<InitPlayerResponse> initPlayer() async {
    return _callFunction('init_player', null, InitPlayerResponse.fromJson);
  }

  /// プレイヤーの値を取得します。
  /// POST /get_value
  /// 認証必須。パラメータ: gameId。
  /// ゲームのphaseが1以降でのみ取得可能。
  ///
  /// @param gameId 対象ゲームID
  /// @return 値等を含むサーバーからのレスポンス
  static Future<GetValueResponse> getValue({required String gameId}) async {
    return _callFunction(
      'get_value',
      {'gameId': gameId},
      GetValueResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// ゲーム情報を取得します。
  /// POST /get_game_info
  /// 認証必須。パラメータ: gameId。
  /// プレイヤーが参加しているゲームの情報のみ取得可能。
  ///
  /// @param gameId 対象ゲームID
  /// @return ゲーム情報（gameId、password）等を含むサーバーからのレスポンス
  static Future<GetGameInfoResponse> getGameInfo({required String gameId}) async {
    return _callFunction(
      'get_game_info',
      {'gameId': gameId},
      GetGameInfoResponse.fromJson,
      updateLastConnected: true,
    );
  }

  /// ゲームの設定や値を取得します。
  /// POST /get_game_config
  /// 認証必須。リクエストボディなし。
  /// プレイヤーが現在参加しているゲームの情報のみ取得可能。
  ///
  /// @return ゲーム設定や値等を含むサーバーからのレスポンス
  static Future<GetGameConfigResponse> getGameConfig({required String gameId}) async {
    return _callFunction(
      'get_game_config',
      {'gameId': gameId},
      GetGameConfigResponse.fromJson,
      updateLastConnected: true,
    );
  }
}