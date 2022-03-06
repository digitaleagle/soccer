import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Player.dart';

class GamePlayer {
  final Player player;
  final Game game;
  bool _attended = false;
  bool _goalie = false;
  bool _captain = false;

  GamePlayer(this.player, this.game);

  get attended {
    _attended = game.attendees.contains(player.id);
    return _attended;
  }
  set attended(value) {
    _attended = value;
    if(_attended) {
      if(!game.attendees.contains(player.id)) {
        game.attendees.add(player.id);
      }
    } else {
      if(game.attendees.contains(player.id)) {
        game.attendees.remove(player.id);
      }
    }
  }

  get goalie {
    _goalie = game.goalies.contains(player.id);
    return _goalie;
  }
  set goalie(value) {
    _goalie = value;
    if(_goalie) {
      if(!game.goalies.contains(player.id)) {
        game.goalies.add(player.id);
      }
    } else {
      if(game.goalies.contains(player.id)) {
        game.goalies.remove(player.id);
      }
    }
  }

  get captain {
    _captain = game.captains.contains(player.id);
    return _captain;
  }
  set captain(value) {
    _captain = value;
    if(_captain) {
      if(!game.captains.contains(player.id)) {
        game.captains.add(player.id);
      }
    } else {
      if(game.captains.contains(player.id)) {
        game.captains.remove(player.id);
      }
    }
  }

}