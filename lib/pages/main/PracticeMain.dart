import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Practice.dart';
import 'package:soccer/data/PracticePlayer.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/EventArgs.dart';
import 'package:soccer/pages/main/PlayerPracticeTile.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class PracticeMain extends StatefulWidget {
  static const route = "/practice";

  @override
  _PracticeMainState createState() => _PracticeMainState();
}

class _PracticeMainState extends State {
  StorageService storage = locator<StorageService>();
  final ValueNotifier<int> _attendance = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final EventArgs args = ModalRoute.of(context).settings.arguments;
    DateFormat dateFormat = DateFormat.yMd();

    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer: Practice"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
          future: loadData(args),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Practice practice = snapshot.data["practice"];
              Team team = snapshot.data["team"];
              List<PracticePlayer> players = snapshot.data["players"];
              /* count */
              var count = 0;
              for (var player in players) {
                if (player.attended) {
                  count++;
                }
              }
              _attendance.value = count;
              bool test = false;
              return Column(children: [
                Text(dateFormat.format(practice.eventDate)),
                Row(
                  children: [
                    Expanded(
                      child: Text("Player"),
                    ),
                    Text("Here?"),
                    Text("Goalie?")
                  ],
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      PracticePlayer player = players[index];
                      return PlayerPracticeTile(
                        player: player,
                        colored: ((index % 2) == 0),
                        team: team,
                        counter: _attendance,
                      );
                    },
                  ),
                )
              ]);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5),
        child: ValueListenableBuilder(
          valueListenable: _attendance,
          builder: (context, value, child) {
            return Text(
              "$value players",
              style: TextStyle(color: Colors.white),
            );
          },
        ),
        color: Colors.blue,
      ),
    );
  }

  Future<dynamic> loadData(EventArgs args) async {
    print("loading Data");
    Practice practice = await storage.getPractice(args.id);
    Team team = args.team;
    List<PracticePlayer> players = practice.loadPlayers(await team.players);
    return {
      "practice": practice,
      "team": team,
      "players": players,
    };
  }
}
