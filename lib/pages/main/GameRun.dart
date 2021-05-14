import 'package:flutter/material.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/GamePlayer.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/pages/main/GameQuarter.dart';

class GameRun extends StatefulWidget {
  final Game game;

  const GameRun({Key key, this.game}) : super(key: key);

  _GameRunState createState() => _GameRunState(game);
}

class _GameRunState extends State {
  final Game game;

  _GameRunState(this.game);

  @override
  Widget build(BuildContext context) {

    // get the not here players
    List<Player> notHere = [];
    List<GamePlayer> here = [];
    for(var player in game.players) {
      if(player.attended) {
        here.add(player);
      } else {
        notHere.add(player.player);
      }
    }

    // get the positions
    List<Player> bench = [];
    List<Player> onField = [];
    for(var player in here) {
      var position = game.getPosition(player.player, game.currentQuarter);
      if(position == null) {
        bench.add(player.player);
      } else {
        onField.add(player.player);
      }
    }

    // build the widgets for the players
    List<Widget> playerWidgets = [];
    playerWidgets.add(Text("Bench"));
    for(var player in bench) {
      playerWidgets.add(ListTile(
        title: Text(player.name),
      ));
    }
    playerWidgets.add(Text("On the Field"));
    for(var player in onField) {
      playerWidgets.add(ListTile(
        title: Text(player.name),
      ));
    }
    playerWidgets.add(Text("Not Here"));
    for(var player in notHere) {
      playerWidgets.add(ListTile(
        title: Text(player.name),
      ));
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              child: Column(
                children: [
                  GameQuarter(game: game, onChanged: () {
                    setState(() {});
                  },),
                  Text("Score"),
                ],
              )),
          Flexible(
            child: ListView(
              children: playerWidgets,
            ),
          )
        ],
      ),
    );
  }

}