import 'package:flutter_online_cardgame/constants/app_images.dart';
import 'package:flutter_online_cardgame/model/player_state.dart';

class PlayerInfo {
  final String id;
  final String name;
  final int avatar;
  final DateTime entrance;

  PlayerInfo({required this.id, required this.name, required this.avatar, required this.entrance});

  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    return PlayerInfo(
      id: json['id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as int? ?? 0,
      entrance: json['entrance'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['entrance'] as int)
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'PlayerInfo('
        'id: $id, '
        'name: $name, '
        'avatar: $avatar, '
        'entrance: $entrance'
        ')';
  }

  String get avatarFileName => AppImages.avatar(avatar);
}

extension PlayerInfoIterableExtension on Iterable<PlayerInfo> {
  List<PlayerInfo> activePlayers(Map<String, PlayerState> playerState) {
    final activePlayerIds = playerState.activePlayers.keys;
    return where((info) => activePlayerIds.contains(info.id)).toList();
  }
}
