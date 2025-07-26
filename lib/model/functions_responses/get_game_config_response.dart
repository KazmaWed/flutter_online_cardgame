import 'package:flutter_online_cardgame/model/game_config.dart';

class GetGameConfigResponse {
  final Map<String, int> values;
  final GameConfig config;

  GetGameConfigResponse({required this.values, required this.config});

  factory GetGameConfigResponse.fromJson(Map<String, dynamic> json) {
    final valuesMap = json['values'] as Map<String, dynamic>? ?? {};
    final values = valuesMap.map((key, value) => MapEntry(key, value as int));

    final configJson = json['config'] as Map<String, dynamic>? ?? {};
    final config = GameConfig.fromJson(configJson);

    return GetGameConfigResponse(values: values, config: config);
  }
}
