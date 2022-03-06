import 'dart:convert';

import 'package:soccer/data/Event.dart';
import 'package:soccer/data/GamePlayer.dart';
import 'package:soccer/data/GamePosition.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Position.dart';

import 'Team.dart';

class Game extends Event {
  int id;
  String field = "";
  String opponent = "";
  String refreshments = "";
  bool pictureDay = false;
  bool triStar = false;
  int teamId = 0;
  final List<GamePosition> playerPositions = [];
  List _playerPositionsToLoad = [];
  final List<GamePlayer> players = [];
  final byQuarter = {
    1: <GamePosition>[],
    2: <GamePosition>[],
    3: <GamePosition>[],
    4: <GamePosition>[],
  };
  final positions = <Position>[];
  final List<int> attendees = [];
  final List<int> goalies = [];
  final List<int> captains = [];
  int currentQuarter = 1;

  Game({this.id = -1, required DateTime eventDate}) : super(id: id, eventDate: eventDate);

  bool get hasAttendance => (attendees.length > 0);

  String toJSON() {
    var playerPositions = [];
    for(var position in this.playerPositions) {
      if(position.position != null) {
        playerPositions.add({
          "player": position.player.id,
          "position": position.position.id,
          "quarter": position.quarter,
        });
      }
    }
    Object obj = {
      "id": id,
      "eventDate": Event.dateFormat.format(eventDate),
      "field": field,
      "opponent": opponent,
      "refreshments": refreshments,
      "pictureDay": pictureDay,
      "triStar": triStar,
      "teamId": teamId,
      "positions": playerPositions,
      "attendees": attendees,
      "goalies": goalies,
      "captains": captains,
    };
    return jsonEncode(obj);
  }

  static Game fromJSON(String json) {
    try {
      Map<String, dynamic> data = jsonDecode(json);
      Game game = Game(id: data["id"], eventDate: Event.dateFormat.parse(data["eventDate"]));
      game.field = data["field"];
      game.opponent = data["opponent"];
      game.refreshments = data["refreshments"];
      game.pictureDay = data["pictureDay"];
      game.triStar = data["triStar"];
      if(data["teamId"] == null) {
        game.teamId = data["teamId"];
      }
      if(data["positions"] != null) {
        game._playerPositionsToLoad = data["positions"];
      }
      game.attendees.clear();
      if(data["attendees"] != null) {
        for(var a in data["attendees"]) {
          game.attendees.add(a);
        }
      }
      game.goalies.clear();
      if(data["goalies"] != null) {
        for(var a in data["goalies"]) {
          game.goalies.add(a);
        }
      }
      game.captains.clear();
      if(data["captains"] != null) {
        for(var a in data["captains"]) {
          game.captains.add(a);
        }
      }
      return game;
    } catch(e) {
      print("Failed to load $json");
      throw Exception("Failed to load game");
    }
  }

  Future<void> loadTeam(Team team) async {
    var teamPlayers = await team.players;
    players.clear();
    for(var player in teamPlayers) {
      var gamePlayer = GamePlayer(player, this);
      players.add(gamePlayer);
    }
    for(var position in team.positions) {
      this.positions.add(position);
    }
    if(_playerPositionsToLoad != null && _playerPositionsToLoad.isNotEmpty) {
      playerPositions.clear();
      byQuarter[1]!.clear();
      byQuarter[2]!.clear();
      byQuarter[3]!.clear();
      byQuarter[4]!.clear();
      while(_playerPositionsToLoad.isNotEmpty) {
        var p = _playerPositionsToLoad.removeLast();
        Player? foundPlayer;
        Position? foundPosition;
        for(var p2 in teamPlayers) {
          if(p2.id == p["player"]) {
            foundPlayer = p2;
          }
        }
        for(var position in positions) {
          if(position.id == p["position"]) {
            foundPosition = position;
          }
        }
        if(foundPlayer == null) {
          throw Exception("No player found for ${p['player']}");
        }
        if(foundPosition == null) {
          throw Exception("No position found for ${p['position']}");
        }
        var player = GamePosition(
            player: foundPlayer,
          position: foundPosition,
          quarter: p["quarter"],
        );
        playerPositions.add(player);
        byQuarter[player.quarter]!.add(player);
      }
    }
  }

  void setPosition(Player player, int quarter, Position? position) {
    bool found = false;
    GamePosition? gamePlayer = null;
    for(var p in playerPositions) {
      if(p.player.id == player.id && p.quarter == quarter) {
        found = true;
        if(position == null) {
          playerPositions.remove(p);
        } else {
          gamePlayer = p;
        }
        break;
      }
    }
    if(position != null) {
      if (found) {
        gamePlayer!.position = position;
      } else {
        gamePlayer = GamePosition(
          player: player,
          position: position,
          quarter: quarter
        );
        playerPositions.add(gamePlayer);
      }
    }
    found = false;
    for(var p in byQuarter[quarter]!) {
      if(p.player.id == player.id && p.quarter == quarter) {
        found = true;
        if(position == null) {
          byQuarter[quarter]!.remove(p);
        } else {
          gamePlayer = p;
        }
        break;
      }
    }
    if(!found && position != null) {
      gamePlayer = gamePlayer ??GamePosition(
        player: player,
        position: position,
        quarter: quarter,
      );
      byQuarter[quarter]!.add(gamePlayer);
    }
  }

  Position? getPosition(Player player, int quarter) {
    for(var playerPosition in byQuarter[quarter]!) {
      if(playerPosition.player.id == player.id) {
        return playerPosition.position;
      }
    }
    return null;
  }

}
