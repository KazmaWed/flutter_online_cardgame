import 'package:flutter_online_cardgame/model/game_info.dart';

class GetGameInfoResponse {
  final String gameId;
  final String password;

  GetGameInfoResponse({required this.gameId, required this.password});

  factory GetGameInfoResponse.fromJson(Map<String, dynamic> json) {
    return GetGameInfoResponse(
      gameId: json['gameId'] as String,
      password: json['password'] as String,
    );
  }

  GameInfo get toGameInfo => GameInfo(gameId: gameId, password: password);
}
