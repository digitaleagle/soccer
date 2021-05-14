import 'package:soccer/data/CommunicationItem.dart';

import 'Player.dart';

class CommunicationPlayer {
  Player _player;
  int player_id;
  bool complete = false;

  Player get player => _player;

  set player(Player value) {
    _player = value;
    player_id = value.id;
  }

  List<CommunicationItem> items = [];
}