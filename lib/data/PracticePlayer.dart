import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Practice.dart';

class PracticePlayer {
  final Player player;
  final Practice practice;
  bool _attended = false;
  bool _goalie = false;

  PracticePlayer(this.player, this.practice);

  get attended {
    return _attended;
  }
  set attended(value) {
    _attended = value;
    if(_attended) {
      if(!practice.attendees.contains(player.id)) {
        practice.attendees.add(player.id);
      }
    } else {
      if(practice.attendees.contains(player.id)) {
        practice.attendees.remove(player.id);
      }
    }
  }

  get goalie {
    return _goalie;
  }
  set goalie(value) {
    _goalie = value;
    if(_goalie) {
      if(!practice.goalies.contains(player.id)) {
        practice.goalies.add(player.id);
      }
    } else {
      if(practice.goalies.contains(player.id)) {
        practice.goalies.remove(player.id);
      }
    }
  }
}