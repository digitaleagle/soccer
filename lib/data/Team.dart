import 'dart:convert';

import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Position.dart';
import 'package:soccer/data/Practice.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class Team {
  int id = -1;
  String name = "";
  String age = "";
  int playersOnField = 0;
  final List<int> playerIds = [];
  List<Player> _players = [];
  final List<int> gameIds = [];
  List<Game> _games = [];
  final List<int> practiceIds = [];
  List<Practice> _practices = [];
  final List<Position> positions = [];

  String toJSON() {
    var positions = [];
    for (var position in this.positions) {
      positions.add({
        "id": position.id,
        "name": position.name,
        "top": position.top,
        "left": position.left,
      });
    }
    Object obj = {
      "id": id,
      "name": name,
      "age": age,
      "playersOnField": playersOnField,
      "playerIds": playerIds,
      "gameIds": gameIds,
      "practiceIds": practiceIds,
      "positions": positions,
    };
    return jsonEncode(obj);
  }

  static Team fromJSON(String json) {
    try {
      var obj = jsonDecode(json);
      Team team = Team();
      team.id = obj["id"];
      team.name = obj["name"];
      team.age = obj["age"];
      team.playersOnField = obj["playersOnField"];
      team.playerIds.clear();
      if (obj["playerIds"] != null) {
        for (int id in obj["playerIds"]) {
          team.playerIds.add(id);
        }
      }
      team.gameIds.clear();
      if (obj["gameIds"] != null) {
        for (int id in obj["gameIds"]) {
          team.gameIds.add(id);
        }
      }
      team.practiceIds.clear();
      if (obj["practiceIds"] != null) {
        for (int id in obj["practiceIds"]) {
          team.practiceIds.add(id);
        }
      }
      team.positions.clear();
      if(obj["positions"] != null) {
        for(var position in obj["positions"]) {
          Position p = Position();
          p.id = position["id"];
          p.name = position["name"];
          if(position["top"] != null) {
            p.top = position["top"];
          }
          if(position["left"] != null) {
            p.left = position["left"];
          }
          team.positions.add(p);
        }
      }
      return team;
    } catch (e) {
      print("Failed to load team: $e");
      print("... while loading $json");
      print(StackTrace.current);
      throw Exception("Failed to load team: $json");
    }
  }

  Future<List<Player>> get players async {
    StorageService storage = locator<StorageService>();

    if (this._players == null) {
      this._players = [];
      for (int id in this.playerIds) {
        Player player = await storage.getPlayer(id);
        if (player == null) {
          print("Player failed to load for player list (id $id)");
          throw Exception("Player failed to load for player list (id $id)");
        }
        this._players.add(player);
      }
    }
    return this._players;
  }

  addPlayer(Player player) {
    if (player.id <= 0) {
      throw Exception("Player must be saved first");
    }
    this.playerIds.add(player.id);
    if (this._players != null) {
      this._players.add(player);
    }
  }

  Future<List<Game>> get games async {
    StorageService storage = locator<StorageService>();

    if (this._games == null) {
      this._games = [];
      for (int id in this.gameIds) {
        this._games.add(await storage.getGame(id));
      }
    }

    return this._games;
  }

  addGame(Game game) {
    if (game.id <= 0) {
      throw Exception("Game must be saved first");
    }
    this.gameIds.add(game.id);
    if (this._games != null) {
      this._games.add(game);
    }
  }

  Future<List<Practice>> get practices async {
    StorageService storage = locator<StorageService>();

    if (this._practices == null) {
      this._practices = [];
      for (int id in this.practiceIds) {
        this._practices.add(await storage.getPractice(id));
      }
    }

    return this._practices;
  }

  addPractice(Practice practice) {
    if (practice.id <= 0) {
      throw Exception("Practice must be saved first");
    }
    this.practiceIds.add(practice.id);
    if (this._practices != null) {
      this._practices.add(practice);
    }
  }

  void removePlayer(Player player) {
    this._players.remove(player);
    this.playerIds.remove(player.id);
  }
}
