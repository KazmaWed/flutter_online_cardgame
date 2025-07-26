import 'package:flutter_online_cardgame/constants/app_constants.dart';
import 'package:flutter_online_cardgame/model/player_info.dart';

class PlayerState {
  final String id;
  final String hint;
  final DateTime lastConnected;
  final DateTime? submitted;
  final bool kicked;

  PlayerState({
    required this.id,
    required this.hint,
    required this.lastConnected,
    this.submitted,
    required this.kicked,
  });

  factory PlayerState.fromJson(Map<String, dynamic> json) {
    return PlayerState(
      id: json['id'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
      lastConnected: json['lastConnected'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastConnected'] as int)
          : DateTime.now(),
      submitted: json['submitted'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['submitted'] as int)
          : null,
      kicked: json['kicked'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'PlayerState('
        'id: $id, '
        'hint: $hint, '
        'lastConnected: $lastConnected, '
        'submitted: $submitted, '
        'kicked: $kicked'
        ')';
  }

  bool get isActive =>
      !kicked && DateTime.now().difference(lastConnected) < AppConstants.playerLifeTime;
}

extension PlayerStateIterableExtension on Iterable<PlayerState> {
  List<PlayerState> get activePlayers => where((state) => state.isActive).toList();

  List<PlayerState> get pendingPlayers =>
      activePlayers.where((state) => state.submitted == null).toList();

  List<PlayerState> get submittedPlayers =>
      activePlayers.where((state) => state.submitted != null).toList()
        ..sort((a, b) => a.submitted!.compareTo(b.submitted!));

  int? submittedOrderOf(PlayerInfo info) {
    final index = submittedPlayers.map((e) => e.id).toList().indexOf(info.id);
    return index < 0 ? null : index + 1;
  }
}

extension PlayerStateMapExtension on Map<String, PlayerState> {
  Map<String, PlayerState> get activePlayers =>
      Map.fromEntries(entries.where((entry) => entry.value.isActive));

  Map<String, PlayerState> get pendingPlayers =>
      Map.fromEntries(entries.where((entry) => entry.value.submitted == null));

  Map<String, PlayerState> get submittedPlayers =>
      Map.fromEntries(entries.where((entry) => entry.value.submitted != null));
}
