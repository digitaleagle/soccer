import 'package:flutter/material.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/nav/args/EventArgs.dart';
import 'package:soccer/pages/main/GameAttendance.dart';
import 'package:soccer/pages/main/GameField.dart';
import 'package:soccer/pages/main/GameInfo.dart';
import 'package:soccer/pages/main/GamePlan.dart';
import 'package:soccer/pages/main/GameRun.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class GameMain extends StatefulWidget {
  static const route = "/game";

  @override
  _GameMainState createState() => _GameMainState();
}

class _GameMainState extends State {
  StorageService storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    final EventArgs args = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
        future: loadData(args.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Game game = snapshot.data["game"];
            return DefaultTabController(
              length: 5,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Soccer: ${args.team.name} v. ${game.opponent}"),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.info_outline),
                      ),
                      Tab(
                        icon: Icon(Icons.notes),
                      ),
                      Tab(
                        icon: Icon(Icons.beenhere),
                      ),
                      Tab(
                        icon: Icon(Icons.directions_run),
                      ),
                      Tab(
                        icon: Icon(Icons.map),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    GameInfo(game),
                    GamePlan(game, args.team),
                    GameAttendance(
                        game: game,
                    ),
                    GameRun(game: game,),
                    GameField(game),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Soccer: Loading Game"),
              ),
              body: CircularProgressIndicator(),
            );
          }
        });
  }

  dynamic loadData(int id) async {
    var game = await storage.getGame(id);
    return {
      "game": game,
    };
  }
}
