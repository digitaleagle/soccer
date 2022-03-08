import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer/data/Communication.dart';
import 'package:soccer/data/CommunicationList.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Practice.dart';
import 'package:soccer/data/RestoreResult.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/data/TeamList.dart';
import 'package:soccer/service/StorageService.dart';

// Google APIs: https://pub.dev/packages/googleapis
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class StorageServiceImpl extends StorageService {
  // manage this on: https://console.cloud.google.com/home/dashboard?folder=&project=soccer-307515
  //  and: https://console.cloud.google.com/apis/credentials?_ga=2.124150986.1362063560.1615649407-2080822853.1615648751&project=soccer-307515&folder=&organizationId=
  final _credentials = null /*= ServiceAccountCredentials.fromJson('''
{
  "private_key_id": ...,
  "private_key": ...,
  "client_email": ...,
  "client_id": ...,
  "type": ...
}
''')*/;

  static const _scopes = [StorageApi.devstorageReadOnlyScope];

  @override
  Future<Team> getTeam(int id) async {
    final prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString("Team$id");
    if(json == null) {
      print("Team #$id does not exist");
      print(StackTrace.current);
      throw Exception("Team #$id does not exist");
    }
    return Team.fromJSON(json);
  }

  @override
  Future<List<Team>> listTeams() async {
    List<Team> teams = [];
    TeamList teamList = await getTeamList();
    for (int id in teamList.idList) {
      Team team = await getTeam(id);
      teams.add(team);
    }
    return teams;
  }

  Future<TeamList> getTeamList() async {
    final prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString("TeamList");
    if (json == null) {
      return TeamList();
    }
    return TeamList.fromJSON(json);
  }

  @override
  Future<Team> findPlayersTeam(Player player) async {
    TeamList teams = await getTeamList();
    for(int teamID in teams.idList) {
      Team team = await getTeam(teamID);
      for(Player p in await team.players) {
        if(p.id == player.id) {
          return team;
        }
      }
    }
    throw Exception("Team not found for player ${player.id} ${player.name}");
  }

  Future<void> saveTeamList(TeamList teamList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("TeamList", teamList.toJSON());
  }

  @override
  Future<void> saveTeam(Team team) async {
    final prefs = await SharedPreferences.getInstance();

    if (team.id <= 0) {
      TeamList teamList = await getTeamList();
      team.id = teamList.nextId++;
      teamList.idList.add(team.id);
      saveTeamList(teamList);
    }

    prefs.setString("Team${team.id}", team.toJSON());
  }

  @override
  Future<Player> getPlayer(int id) async {
    final prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString("Player$id");
    if(json == null) {
      return Player();
    }
    return Player.fromJSON(json);
  }

  @override
  Future<void> savePlayer(Player player) async {
    final prefs = await SharedPreferences.getInstance();

    if (player.id <= 0) {
      int nextId = 1;
      if (prefs.containsKey("NextPlayerId")) {
        nextId = prefs.getInt("NextPlayerId")!;
      }
      player.id = nextId++;
      prefs.setInt("NextPlayerId", nextId);
    }

    String json = player.toJSON();
    prefs.setString("Player${player.id}", json);
  }

  @override
  Future<Game> getGame(int id) async {
    final prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString("Game$id");
    if(json == null) {
      throw Exception("Game not found for ID $id");
    }
    Game game = Game.fromJSON(json);

    /* Look up the team Id */
    // if(game.teamId == null) {
      var teamList = await this.getTeamList();
      for(var teamId in teamList.idList) {
        String? json = prefs.getString("Team$teamId");
        var team;
        if(json == null) {
          team = Team();
        } else {
          team = jsonDecode(json);
        }
        if (team["gameIds"] != null) {
          for(var gameId in team["gameIds"]) {
            if(gameId == game.id) {
              game.teamId = teamId;
            }
          }
        }
      }
    //}
    // if(game.teamId == null) {
    //   print("Game doesn't have a team: $id");
    //   print(StackTrace.current);
    //   throw Exception("Game doesn't have a team: $id");
    // }

    try {
      game.loadTeam(await getTeam(game.teamId));
    } catch (e, trace) {
      print("Print this shouldn't happen, but we can't load the team (${game.teamId}) for game #$id");
      print(e.toString());
      print(trace);
      var teamList = await listTeams();
      game.loadTeam(teamList[0]);
    }
    return game;
  }

  @override
  Future<void> saveGame(Game game) async {
    final prefs = await SharedPreferences.getInstance();

    if (game.id <= 0) {
      int nextId = 1;
      if (prefs.containsKey("NextGameId")) {
        nextId = prefs.getInt("NextGameId")!;
      }
      game.id = nextId++;
      prefs.setInt("NextGameId", nextId);
    }

    String json = game.toJSON();
    prefs.setString("Game${game.id}", json);
  }

  @override
  Future<Practice> getPractice(int id) async {
    final prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString("Practice$id");
    if(json == null) {
      return Practice(eventDate: DateTime.now());
    }
    return Practice.fromJSON(json);
  }

  @override
  Future<void> savePractice(Practice practice) async {
    final prefs = await SharedPreferences.getInstance();

    if (practice.id <= 0) {
      int nextId = 1;
      if (prefs.containsKey("NextPracticeId")) {
        nextId = prefs.getInt("NextPracticeId")!;
      }
      practice.id = nextId++;
      print("next practice id ... $nextId");
      prefs.setInt("NextPracticeId", nextId);
    }

    String json = practice.toJSON();
    print("saving practice $json");
    prefs.setString("Practice${practice.id}", json);
  }

  @override
  Future<Communication> getCommunication(int id) async {
    final prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString("Comm$id");
    if(json == null) {
      return Communication();
    }
    return Communication.fromJSON(json);
  }
  @override
  Future<void> saveCommunication(Communication communication) async {
    final prefs = await SharedPreferences.getInstance();

    if(communication.id <= 0) {
      CommunicationList communicationList = await getCommunicationList();
      communication.id = communicationList.nextId++;
      communicationList.idList.add(communication.id);
      saveCommunicationList(communicationList);
    }

    prefs.setString("Comm${communication.id}", communication.toJSON());
  }
  Future<CommunicationList> getCommunicationList() async {
    final prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString("CommList");
    if(json == null) {
      return CommunicationList();
    } else {
      return CommunicationList.fromJSON(json);
    }
  }
  Future<void> saveCommunicationList(CommunicationList communicationList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("CommList", communicationList.toJSON());
  }
  @override
  Future<List<Communication>> listCommunications() async {
    CommunicationList list = await getCommunicationList();
    List<Communication> returnList = [];
    for(int id in list.idList) {
      returnList.add(await getCommunication(id));
    }
    return returnList;
  }
  @override
  Future<void> deleteCommunication(Communication communication) async {
    CommunicationList list = await getCommunicationList();
    list.idList.remove(communication.id);
    saveCommunicationList(list);
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("Comm${communication.id}");
  }



  @override
  Future<String> backup() async {
    List<String> outTeams = [];
    List<String> outPlayers = [];
    List<String> outGames = [];
    List<String> outPractices = [];
    List<String> outCommunications = [];
    var teams = await getTeamList();
    for (var id in teams.idList) {
      var team = await getTeam(id);
      outTeams.add(team.toJSON());
      for (var player in await team.players) {
        outPlayers.add(player.toJSON());
      }
      for (var game in await team.games) {
        await game.loadTeam(team);
        outGames.add(game.toJSON());
      }
      for (var practice in await team.practices) {
        outPractices.add(practice.toJSON());
      }
    }
    for(var communiciation in await listCommunications()) {
      outCommunications.add(communiciation.toJSON());
    }
    var obj = {
      "teams": outTeams,
      "players": outPlayers,
      "games": outGames,
      "practices": outPractices,
      "communications": outCommunications,
    };
    return jsonEncode(obj);
  }

  @override
  Future<RestoreResult> restore(String json) async {
    var result = RestoreResult();
    try {
      var teamMap = <int, dynamic>{};

      var obj = jsonDecode(json);
      List teams = obj["teams"];
      TeamList teamList = TeamList();
      for (var strTeam in teams) {
        Team team = Team.fromJSON(strTeam);
        saveTeam(team);
        teamList.idList.add(team.id);
        result.teamsLoaded++;

        for(int gameId in team.gameIds) {
          teamMap[gameId] = team;
        }
      }
      saveTeamList(teamList);

      List players = obj["players"];
      for (var strPlayer in players) {
        Player player = Player.fromJSON(strPlayer);
        savePlayer(player);
        result.playersLoaded++;
      }

      List games = obj["games"];
      for (var strGame in games) {
        Game game = Game.fromJSON(strGame);
        await game.loadTeam(teamMap[game.id]);
        saveGame(game);
        result.gamesLoaded++;
      }

      List practices = obj["practices"];
      for (var strPractice in practices) {
        Practice practice = Practice.fromJSON(strPractice);
        savePractice(practice);
        result.practicesLoaded++;
      }

      if(obj["communications"] != null) {
        CommunicationList commList = CommunicationList();
        for(String strCommunication in obj["communications"]) {
          var communication = Communication.fromJSON(strCommunication);
          commList.idList.add(communication.id);
          saveCommunication(communication);
          if(commList.nextId <= communication.id) {
            commList.nextId = communication.id + 1;
          }
          result.communicationsLoaded++;
        }
        saveCommunicationList(commList);
      }
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;

  }

  @override
  Future<RestoreResult> restoreUpdate(String json) async {
    var result = RestoreResult();
    try {
      var gameMap = <int, Team>{};
      var playerMap = <int, Team>{};
      var practiceMap = <int, Team>{};

      var obj = jsonDecode(json);
      List teams = obj["teams"];
      for (var strTeam in teams) {
        Team team = Team.fromJSON(strTeam);
        var shouldLoad = false;
        Team? existing;
        try {
          existing = await getTeam(team.id);
        } catch(e) {
          shouldLoad = true;
          team.id = -1;
        }
        var fileTeam = team;
        if(shouldLoad) {
          saveTeam(team);
        } else {
          if(existing != null) {
            team = existing;
          }
        }

        for(int gameId in fileTeam.gameIds) {
          gameMap[gameId] = team;
        }
        for(int playerId in fileTeam.playerIds) {
          playerMap[playerId] = team;
        }
        for(int practiceId in fileTeam.practiceIds) {
          practiceMap[practiceId] = team;
        }
        // Clear them so we add the players back
        team.playerIds.clear();
        team.gameIds.clear();
        team.practiceIds.clear();
        saveTeam(team);
      }

      List players = obj["players"];
      for (var strPlayer in players) {
        Player player = Player.fromJSON(strPlayer);
        var shouldLoad = false;
        try {
          var existing = await getPlayer(player.id);
          if(player.hasPreferences && !existing.hasPreferences) {
            shouldLoad = true;
          }
        } catch (e) {
          shouldLoad = true;
        }
        var team = playerMap[player.id];
        if(team == null) {
          throw Exception("Null team");
        }
        var isDuplicate = false;
        for(var existingId in team.playerIds) {
          var existing = await getPlayer(existingId);
          if(existing.name == player.name) {
            // this is a duplicate
            shouldLoad = false;
            isDuplicate = true;
          }
        }
        if(shouldLoad) {
          savePlayer(player);
          result.playersLoaded++;
        }
        if(!isDuplicate) {
          // add back to the team
          team.playerIds.add(player.id);
          saveTeam(team);
        }
      }

      List games = obj["games"];
      for (var strGame in games) {
        Game game = Game.fromJSON(strGame);

        // add back to the team -- have to do this early because the getGame() checks
        var team = gameMap[game.id];
        if(team == null) {
          throw Exception("Failed to get to game map for ${game.id}");
        }
        team.gameIds.add(game.id);
        saveTeam(team);

        var shouldLoad = false;
        try {
          var existing = await getGame(game.id);
          if(!existing.hasAttendance && game.hasAttendance) {
            shouldLoad = true;
          }
        } catch(e) {
          shouldLoad = true;
        }
        if(shouldLoad) {
          await game.loadTeam(gameMap[game.id]!);
          saveGame(game);
          result.gamesLoaded++;
        }
      }

      List practices = obj["practices"];
      for (var strPractice in practices) {
        Practice practice = Practice.fromJSON(strPractice);
        var shouldLoad = false;
        try {
          var existing = await getPractice(practice.id);
          if(!existing.hasAttendance && practice.hasAttendance) {
            shouldLoad = true;
          }
        } catch(e) {
          shouldLoad = true;
        }
        if(shouldLoad) {
          savePractice(practice);
          result.practicesLoaded++;
        }
        // add back to the team
        var team = practiceMap[practice.id];
        if(team == null) {
          throw Exception("Failed to find Team for ${practice.id}");
        }
        team.practiceIds.add(practice.id);
        saveTeam(team);
      }

      if(obj["communications"] != null) {
        for(String strCommunication in obj["communications"]) {
          var communication = Communication.fromJSON(strCommunication);
          var shouldLoad = false;
          try {
            var existing = await getCommunication(communication.id);
            if(existing.descr != communication.descr) {
              shouldLoad = true;
            }
            if(existing.text != communication.text) {
              shouldLoad = true;
            }
            if(shouldLoad) {
              var list = await listCommunications();
              for(var search in list) {
                if(search.descr == communication.descr && search.text == communication.text) {
                  shouldLoad = false;
                  break;
                }
              }
            }
          } catch(e) {
            shouldLoad = true;
          }
          if(shouldLoad) {
            communication.id = -1;
            saveCommunication(communication);
            result.communicationsLoaded++;
          }
        }
      }
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;

  }

  Future<void> googleservice() async {
    final httpClient = await clientViaServiceAccount(_credentials, _scopes);
    try {
      final storage = StorageApi(httpClient);

      final buckets = await storage.buckets.list('dart-on-cloud');
      if(buckets.items == null) {
        throw Exception("Failed to get buckets.items");
      }
      print('Received ${buckets.items!.length} bucket names:');
      for (var file in buckets.items!) {
        print(file.name);
      }
    } finally {
      httpClient.close();
    }
  }

  @override
  Future<void> googleSignIn() async {
    // https://medium.com/flutter-community/flutter-sign-in-with-google-in-android-without-firebase-a91b977d166f
    var   _googleSignIn  =  GoogleSignIn();
    await _googleSignIn.signIn();

    if(_googleSignIn.currentUser == null) {
      throw Exception("Current User null");
    }
    final authHeaders = _googleSignIn.currentUser!.authHeaders;

    print(authHeaders);
    // final httpClient = GoogleHttpClient(authHeaders);
  }
}
