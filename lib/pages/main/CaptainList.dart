import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/EventArgs.dart';
import 'package:soccer/nav/args/TeamArgs.dart';
import 'package:soccer/pages/main/GameMain.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class CaptainList extends StatefulWidget {
  static const route = "/game/captains";

  @override
  _CaptainListState createState() => _CaptainListState();
}

class _CaptainListState extends State<CaptainList> {
  StorageService storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    final TeamArgs args = ModalRoute.of(context)!.settings.arguments as TeamArgs;

    return Scaffold(
        appBar: AppBar(
          title: Text("Pick Captains"),
        ),
        body: FutureBuilder(
          future: loadTeam(args.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CaptainListTeamObj data = snapshot.data as CaptainListTeamObj;
              final Team team = data.team;
              final List<Game> games = data.games;
              final List<ListTile>list = data.list;

              return Container(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: list,
                  ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }

  Future<CaptainListTeamObj> loadTeam(int id) async {
    final Team team = await storage.getTeam(id);

    // build list of players that we could take off
    List<Player> players = [];
    for(var player in await team.players) {
      players.add(player);
    }

    List<ListTile> list = [];
    var games = await team.games;
    var df = DateFormat.yM();

    for(Game game in games) {
      await game.loadTeam(team);
      list.add(
          ListTile(
            title: Text("Game -- ${game.opponent}  ${df.format(game.eventDate)}"),
            onTap: () {
              Navigator.pushNamed(context, GameMain.route,
                  arguments: EventArgs(game.id, team));

            },
          )
      );
      var gamePlayers = game.players;
      for(var player in gamePlayers) {
        if(player.captain) {
          list.add(
              ListTile(
                title: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(player.player.name)),
              )
          );
          for(var p in players) {
            if(p.id == player.player.id) {
              players.remove(p);
              break;
            }
          }
        }
      }
    }
    var index = 0;
    for(var player in players) {
      list.insert(index++, ListTile(
        title: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(player.name)),
      ));
    }
    list.insert(0, ListTile(
      title: Text("Waiting for turn to be captain"),
    ));

    return CaptainListTeamObj(
      team: team,
      games: await team.games,
      list: list
    );
  }
}

//  this is just a quick object to let us return multiple things
class CaptainListTeamObj {
  Team team;
  List<Game> games;
  List<ListTile> list;

  CaptainListTeamObj({required this.team, required this.games, required this.list});
}
