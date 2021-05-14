import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/GamePosition.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/PlayerArgs.dart';
import 'package:soccer/nav/args/PositionSelectArgs.dart';
import 'package:soccer/pages/main/GamePositionWidget.dart';
import 'package:soccer/pages/main/PositionSelector.dart';
import 'package:soccer/pages/setup/PlayerSetup.dart';

class GamePlan extends StatelessWidget {
  final Game game;
  final Team team;

  GamePlan(this.game, this.team);

  @override
  Widget build(BuildContext context) {
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
            "Q1",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Q2",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Q3",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Q4",
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
            child: Hero(
              tag: "player-name-${player.player.id}",
              child: Text(
                player.player.name,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        Text(
          player.player.jersey,
          style: TextStyle(fontSize: 18),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: GamePositionWidget(
            game: game,
            player: player.player,
            quarter: 1,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: GamePositionWidget(
            game: game,
            player: player.player,
            quarter: 2,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: GamePositionWidget(
            game: game,
            player: player.player,
            quarter: 3,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: GamePositionWidget(
            game: game,
            player: player.player,
            quarter: 4,
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
            5: FixedColumnWidth(50),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: rows,
        ),
      ),
    );
  }


}
