import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/nav/args/PositionSelectArgs.dart';
import 'package:soccer/pages/main/FieldPlayer.dart';
import 'package:soccer/pages/main/GameQuarter.dart';
import 'package:soccer/pages/main/PositionSelector.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class GameField extends StatefulWidget {
  final Game game;

  GameField(this.game);

  @override
  _GameFieldState createState() => _GameFieldState(game);
}

class _GameFieldState extends State {
  StorageService storage = locator<StorageService>();
  final Game game;

  _GameFieldState(this.game);

  @override
  Widget build(BuildContext context) {
    var fieldItems = <Widget>[
      Image(
        image: AssetImage("assets/graphics/field.png"),
      ),
    ];
    for(var position in game.positions) {
      Player player = null;
      bool duplicate = false;
      for(var pp in game.byQuarter[game.currentQuarter]) {
        if(pp.position.id == position.id) {
          if(player != null) {
            duplicate = true;
          }
          player = pp.player;
        }
      }
      var item = FieldPlayer(
        position: position,
        player: player,
        duplicate: duplicate,
        onPressed: () {
          Navigator.pushNamed(
              context, PositionSelector.route,
              arguments: PositionSelectArgs(game.currentQuarter, player, game)).then((obj) async {
            if(obj != null) {
              if(obj == "bench") {
                position = null;
                game.setPosition(player, game.currentQuarter, null);
              } else {
                game.setPosition(player, game.currentQuarter, obj);
                position = obj;
              }
              storage.saveGame(game);
              setState(() {

              });
            }
          });

        },
      );
      fieldItems.add(item);
    }

    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          GameQuarter(game: game, onChanged: () {
            setState(() {});
          },),
          Flexible(
            child: InteractiveViewer(
                child: Stack(
              children: fieldItems,
            )),
          ),
        ],
      ),
    );
  }
}
