import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/GamePosition.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/PlayerArgs.dart';
import 'package:soccer/nav/args/PositionSelectArgs.dart';
import 'package:soccer/nav/args/TeamArgs.dart';
import 'package:soccer/pages/main/CaptainList.dart';
import 'package:soccer/pages/main/GamePositionWidget.dart';
import 'package:soccer/pages/main/PositionSelector.dart';
import 'package:soccer/pages/setup/PlayerSetup.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class GameAttendance extends StatefulWidget {
  final Game game;
  final Team team;

  const GameAttendance({Key key, this.game, this.team}) : super(key: key);

  @override
  _GameAttendanceSetup createState() => _GameAttendanceSetup(game, team);
}

class _GameAttendanceSetup extends State {
  StorageService storage = locator<StorageService>();
  final Game game;
  final Team team;

  _GameAttendanceSetup(this.game, this.team);

  @override
  Widget build(BuildContext context) {

    // attendance count
    var attendanceCount = 0;
    for (var player in game.players) {
      if(player.attended) {
        attendanceCount++;
      }
    }

    List<TableRow> rows = [
      TableRow(children: [
        Text(
          "Player",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        Text(
          "Jersey",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Here ($attendanceCount)",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, CaptainList.route,
                arguments: TeamArgs(game.teamId));
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Captain",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Goalie",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ])
    ];
    for (var player in game.players) {
      rows.add(TableRow(children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, PlayerSetup.route,
                arguments: PlayerArgs(player.player.id, team));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              player.player.name,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Text(
          player.player.jersey,
          style: TextStyle(fontSize: 18),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Checkbox(
            value: player.attended,
            onChanged: (value) {
              player.attended = value;
              setState(() {

              });
              storage.saveGame(game);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Checkbox(
            value: player.captain,
            onChanged: (value) {
              player.captain = value;
              setState(() {

              });
              storage.saveGame(game);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Checkbox(
            value: player.goalie,
            onChanged: (value) {
              player.goalie = value;
              setState(() {

              });
              storage.saveGame(game);
            },
          ),
        ),
      ]));
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Table(
          // border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FixedColumnWidth(25),
            2: FixedColumnWidth(50),
            3: FixedColumnWidth(50),
            4: FixedColumnWidth(50),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: rows,
        ),
      ),
    );
  }


}
